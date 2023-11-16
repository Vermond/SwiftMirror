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

struct CameraPreviewRepresentable: UIViewControllerRepresentable {
    @ObservedObject var viewModel: MirrorViewModel
    
    @Binding var isWaitingForChangeQuality: Bool
    @Binding var isWaitingForCapture: Bool
    @Binding var photoImage: UIImage?
    
    @State var lastZoomFactor: CGFloat = 1.0
    
    func makeUIViewController(context: Context) -> CameraPreviewController {
        let controller = CameraPreviewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraPreviewController, context: Context) {
        if self.isWaitingForChangeQuality {
            uiViewController.updatePreviewQuality(quality: viewModel.currentPreviewQuality) {
                isWaitingForChangeQuality = false
            }
        }
        
        if self.isWaitingForCapture {
            uiViewController.capturePhoto()
        }
        
        if lastZoomFactor != viewModel.zoomRate {
            uiViewController.changeZoom(to: viewModel.zoomRate) {
                lastZoomFactor = viewModel.zoomRate                
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
        let parent: CameraPreviewRepresentable
        
        init(parent: CameraPreviewRepresentable) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {            
            parent.isWaitingForCapture = false
            
            if let imageData = photo.fileDataRepresentation()
            {
                parent.photoImage = UIImage(data: imageData)
            }
        }
    }
}

class CameraPreviewController: UIViewController {
    private var zoomFactor: CGFloat = 1.0
    
    private let minZoomFactor: CGFloat = 1.0
    private var maxZoomFactor: CGFloat = 1.0
    
    private var captureSession = AVCaptureSession()
    private var frontCamera: AVCaptureDevice?
    private var photoOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    private var _delegate: AVCapturePhotoCaptureDelegate?
    public var delegate: AVCapturePhotoCaptureDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
    
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
            let setting = AVCapturePhotoSettings()
            photoOutput?.capturePhoto(with: setting, delegate: delegate)
        }
    }
    
    public func changeZoom(to newFactor: CGFloat, onComplete: (()->Void)? = nil) {
        let newZoomFactor = min(max(newFactor, minZoomFactor), maxZoomFactor)
        self.zoomFactor = newZoomFactor
        
        if let frontCamera {
            do {
                try frontCamera.lockForConfiguration()
                defer {
                    frontCamera.unlockForConfiguration()
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        onComplete?()
                    }
                }
                frontCamera.videoZoomFactor = newZoomFactor
            } catch {
                debugPrint(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup only when it is not a preview
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
            setup()
        }
    }
    
    private func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
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
    
    private func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: frontCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            
            if captureSession.canSetSessionPreset(.high) {
                captureSession.sessionPreset = .high
            }
            
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])])
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    private func setupPreviewLayer() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = .resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait //videoOrientation will be deprecated -> usind videoRotationAngle is recommanded
        self.previewLayer?.frame = self.view.layer.bounds
        self.view.layer.insertSublayer(previewLayer!, at: 0)
    }
    
    private func startRunningCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
}
