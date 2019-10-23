//
//  EditCoverViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 9/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift
import Photos
class EditCoverViewModel: BaseViewModel {
    
    var selectedAlbumType = BehaviorRelay<AlbumType>(value: .device)
    let galleryViewModel = GalleryViewModel()
    let selectedIndexPath = BehaviorRelay<IndexPath?>(value: nil)
    let covers = BehaviorRelay<[UIImage]>(value: [])
}
