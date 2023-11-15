//
//  PhotoController.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 10/5/23.
//

import Foundation
import UIKit
import PhotosUI

class PhotoController: NSObject {
    static let shared = PhotoController()
    
    private var onComplete: ((Error?) -> Void)? = nil
    
    override init() {
        super.init()        
    }
    
    public var isAlbumAuthorized: Bool {
        PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized
    }
    
    func writeToPhotoAlbum(image: UIImage, onComplete: ((Error?) -> Void)? = nil) {
        self.onComplete = onComplete
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveComplete), nil)
    }
    
    @objc private func saveComplete(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error {
            print(error)
        } else {
            print("save finished")
        }
        
        if onComplete != nil {
            onComplete!(error)
            onComplete = nil
        }
    }
}
