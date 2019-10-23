//
//  PHAsset.swift
//  CustomGallery
//
//  Created by Pavle Pesic on 7/14/18.
//  Copyright © 2018 Pavle Pesic. All rights reserved.
//

import PhotosUI
import Photos

extension PHAsset {
    
    // MARK: - Public methods
    
    func getAssetThumbnail(size: CGSize) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: self, targetSize: size, contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        
        return thumbnail
    }
    
    func getOrginalImage(complition:@escaping (UIImage) -> Void) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        manager.requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: option, resultHandler: {(result, info)->Void in
            image = result!
            
            complition(image)
        })
    }
        
    func getImageFromPHAsset() -> UIImage {
        var image = UIImage()
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        requestOptions.isSynchronous = true
        
        if (self.mediaType == PHAssetMediaType.image) {
            PHImageManager.default().requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: requestOptions, resultHandler: { (pickedImage, info) in
                image = pickedImage!
            })
        }
        return image
    }
    
    func getVideoUrlFromPHAsset(_ asset:PHAsset)->AVURLAsset?{

        let semaphore = DispatchSemaphore(value: 0)

        var videoObj:AVURLAsset? = nil

        let options = PHVideoRequestOptions()

        // options.isSynchronous = true

        options.deliveryMode = .highQualityFormat

        PHImageManager().requestAVAsset(forVideo:asset, options: options, resultHandler: { (avurlAsset, audioMix, dict) in

            videoObj = avurlAsset as? AVURLAsset

            semaphore.signal()
        })

        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        return videoObj!
    }
    
    func getVideoDataFromPHAsset() -> Data? {
        guard let urlAsset = self.getVideoUrlFromPHAsset(self) else { return nil }
        let videoData = try? Data(contentsOf: urlAsset.url)
        return videoData
    }
    
}
