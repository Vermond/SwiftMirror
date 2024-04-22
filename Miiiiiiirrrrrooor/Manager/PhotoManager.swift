//
//  PhotoController.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 10/5/23.
//

import Foundation
import UIKit
import PhotosUI

class PhotoManager: NSObject {
    static let shared = PhotoManager()
    
    private var onComplete: ((Error?) -> Void)? = nil
    
    override init() {
        super.init()        
    }
    
    public var isAlbumAuthorized: Bool {
        PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized
    }
    
    func writeToPhotoAlbum(image: CGImage, isFlipped: Bool, onComplete: ((Error?) -> Void)? = nil) {
        self.onComplete = onComplete
        let image = UIImage(cgImage: image, scale: 1, orientation: isFlipped ? .up : .upMirrored)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveComplete), nil)
    }
    
    @objc private func saveComplete(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            // error
        } else {
            // finish
        }
        
        if onComplete != nil {
            onComplete!(error)
            onComplete = nil
        }
    }
}
