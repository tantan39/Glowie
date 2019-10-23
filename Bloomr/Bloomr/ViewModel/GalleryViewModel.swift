//
//  GalleryViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift
import Photos

enum MediaSource {
    case camera
    case deviceAlbum
    case none
}

class GalleryViewModel: BaseViewModel {
    var albums = BehaviorRelay<[PHAssetCollection]?>(value: nil)
    var selectedAlbum = BehaviorRelay<PHAssetCollection?>(value: nil)
    var assets = BehaviorRelay<PHFetchResult<PHAsset>?>(value: nil)
    var indexSelecteds = BehaviorRelay<[Int]>(value: [])
    var mediaSource = BehaviorRelay<MediaSource>(value: .none)
    
    var selectedAssets: [PHAsset]? {
        let indexs = self.indexSelecteds.value
        let assets: [PHAsset]? = indexs.compactMap({ self.assets.value?[$0 - 1] })
        return assets
    }
    
    var captureImage = BehaviorRelay<UIImage?>(value: nil)
    var videoURL = BehaviorRelay<URL?>(value: nil)
    
    var albumsTitle: [String] {
        let albums = self.albums.value
        let titles: [String] = albums?.compactMap({ $0.localizedTitle }) ?? []
        return titles
    }
    
    var contestFormat: ContestItemFormatType {
        let contest = AppManager.shared.selectedContest
        return contest?.contestFormat ?? .all
    }

    override init() {
        super.init()
        self.loadPhotosFromDevice()
    }
 
    func loadPhotosFromDevice() {
        PHPhotoLibrary.checkAuthorizationStatus { (authorized) in
            if authorized {
                self.fetchAlbums()
            } else {
                logDebug("Please authorize gallery access.")
            }
        }
    }
    
    func fetchAlbums() {
//        self.albums.value?.removeAll()
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        var albums = [PHAssetCollection]()
        let result = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        result.enumerateObjects({ (collection, _, _) in
            if (collection.hasAssets()) {
                albums.append(collection)
            }
        })
        self.albums.accept(albums)
    }
    
    func fetchAssets(from album: PHAssetCollection?) {
        var assets: PHFetchResult<PHAsset>?
        
        DispatchQueue.main.async {
            let fetchOptions = PHFetchOptions()
            if self.contestFormat == .video {
                fetchOptions.predicate = NSPredicate(format: "mediaType == %d",
                                                                PHAssetMediaType.video.rawValue)
            } else {
                fetchOptions.predicate = NSPredicate(format: "mediaType == %d || mediaType == %d",
                                                                PHAssetMediaType.image.rawValue,
                                                                PHAssetMediaType.video.rawValue)
            }
           
            if let collection = album {
                assets = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            } else {
                assets = PHAsset.fetchAssets(with: fetchOptions)
            }
            self.assets.accept(assets)
        }
    }

}
