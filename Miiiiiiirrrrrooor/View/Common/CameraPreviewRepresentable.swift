//
//  CameraPreviewRepresentable.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 2023/09/22.
//
//  Original code from https://stackoverflow.com/questions/58847638/swiftui-custom-camera-view
//

import SwiftUI
import AVFoundation
import CoreImage
import Vision

struct CameraPreviewRepresentable: UIViewControllerRepresentable {
    @ObservedObject var model: MirrorView.ViewModel
    
    @Binding var viewSize: CGSize
    @Binding var isWaitingForCapture: Bool
    @Binding var photoImage: UIImage?
    @Binding var currentFilter: Filters
    
    @State private(set) var lastZoomFactor: CGFloat = 1.0
    @State private(set) var lastOffset: Offset = (0, 0)
    
    func makeUIViewController(context: Context) -> CameraPreviewController {
        let controller = CameraPreviewController()
        controller.delegate = context.coordinator
        controller.filter = $currentFilter
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraPreviewController, context: Context) {
        uiViewController.viewSize = $viewSize
        
        if self.isWaitingForCapture {
            uiViewController.capturePhoto()
        }
        
        if lastZoomFactor != model.zoomRate {
            uiViewController.changeZoom(to: model.zoomRate) {
                lastZoomFactor = model.zoomRate
            }
        }
        
        if lastOffset != model.offset {            
            uiViewController.changeOffset(to: model.offset) {
                lastOffset = model.offset
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }    
    
    class Coordinator: NSObject, UINavigationControllerDelegate {
        let parent: CameraPreviewRepresentable
        
        init(parent: CameraPreviewRepresentable) {
            self.parent = parent
        }
        
        func sendCurrentImage(image: UIImage?) {
            if let image {
                DispatchQueue.main.async { [unowned self] in
                    parent.isWaitingForCapture = false
                    parent.photoImage = image
                }
            }
        }
    }
}

class CameraPreviewController: UIViewController {
    private let minZoomFactor: CGFloat = 1.0
    private var maxZoomFactor: CGFloat = 1.0
    
    private var maxOffset: Offset = (0, 0)
    
    private var originPosition: CGPoint?
    
    private var captureSession = AVCaptureSession()
    private var frontCamera: AVCaptureDevice?
    private var videoOutput = AVCaptureVideoDataOutput()
    private let imageView = UIImageView()
    private let context = CIContext()
    
    private var _delegate: CameraPreviewRepresentable.Coordinator?
    public var delegate: CameraPreviewRepresentable.Coordinator? {
        get { return _delegate }
        set { _delegate = newValue }
    }
    
    var viewSize: Binding<CGSize>?
    var filter: Binding<Filters>?
    var image: UIImage? { imageView.image }
    
    public func updatePreviewQuality(quality: AVCaptureSession.Preset, onComplete: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.stopRunning()
            self.captureSession.sessionPreset = quality
            self.captureSession.startRunning()
            
            onComplete?()
        }
    }
    
    public func capturePhoto() {
        if let delegate {
            delegate.sendCurrentImage(image: image)
        }
    }
    
    public func changeZoom(to newFactor: CGFloat, onComplete: (() -> Void)? = nil) {
        let newZoomFactor = min(max(newFactor, minZoomFactor), maxZoomFactor)
        
        if let frontCamera {
            do {
                try frontCamera.lockForConfiguration()
                
                defer {
                    frontCamera.unlockForConfiguration()
                    
                    if let originPosition {
                        imageView.layer.position = originPosition
                    }
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        onComplete?()
                    }
                }
                
                if let viewSize = viewSize?.wrappedValue {
                    setMaxOffset(size: viewSize, zoomRate: newFactor)
                }
                
                let scale = CGAffineTransform(scaleX: newZoomFactor, y: newZoomFactor)
                imageView.layer.setAffineTransform(scale)
            } catch {
                debugPrint(error)
            }
        }
    }
    
    public func changeOffset(to newOffset: Offset, onComplete: (() -> Void)? = nil) {
        guard let originPosition else { return }
        let layer = imageView.layer
        
        let minX = originPosition.x - maxOffset.x
        let maxX = originPosition.x + maxOffset.x
        let minY = originPosition.y - maxOffset.y
        let maxY = originPosition.y + maxOffset.y
        
        let px = layer.position.x + newOffset.x
        let py = layer.position.y + newOffset.y
        
        let x = px > maxX ? maxX : px < minX ? minX : px
        let y = py > maxY ? maxY : py < minY ? minY : py
        
        if let frontCamera {
            do {
                try frontCamera.lockForConfiguration()
                
                defer {
                    frontCamera.unlockForConfiguration()
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        onComplete?()
                    }
                }
                
                layer.position = CGPoint(x: x, y: y)
            } catch {
                debugPrint(error)
            }
        }
    }
    
    public func setMaxOffset(size: CGSize, zoomRate: CGFloat) {
        if zoomRate < 1.01 {
            self.maxOffset = (0, 0)
        } else {
            self.maxOffset = ((size.width * zoomRate - size.width) / 2,
                              (size.height * zoomRate - size.height) / 2)
        }
    }
    
    //MARK: - Private functions for inner process
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup only when it is not a preview
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
            setup()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        originPosition = imageView.layer.position
    }
    
    private func setup() {
        setupCaptureSession()
        setupDevice()
        setupInput()
        setupOutput()
        setupImageView()
        startRunningCaptureSession()
    }
    
    private func setupCaptureSession() {
        captureSession.sessionPreset = .photo
    }
    
    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
            mediaType: .video,
            position: .front)
        
        for device in deviceDiscoverySession.devices {
            if device.position == .front {
                self.frontCamera = device
                maxZoomFactor = device.activeFormat.videoMaxZoomFactor
                break
            }
        }
    }
    
    private func setupInput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: frontCamera!)
            captureSession.addInput(captureDeviceInput)
            
            if captureSession.canSetSessionPreset(.high) {
                captureSession.sessionPreset = .high
            }
        } catch {
            debugPrint(error)
        }
    }
    
    private func setupOutput() {
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(videoOutput)
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func startRunningCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
}

extension CameraPreviewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        var ciImage = CIImage(cvImageBuffer: pixelBuffer)

        if let filter = filter?.wrappedValue.filter {
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            
            guard let filteredImage = filter.outputImage else { return }
            ciImage = filteredImage
        }
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
                
        let uiImage = UIImage(cgImage: cgImage, scale: 1, orientation: .leftMirrored)
        
        DispatchQueue.main.async {
            self.imageView.image = uiImage
        }
    }
}
