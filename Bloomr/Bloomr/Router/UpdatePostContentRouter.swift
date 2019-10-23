//
//  UpdateContentPostRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct UpdatePostContentRouter: Router {

    var galleryViewModel: GalleryViewModel?
    var audioUrl: String?
    init(viewModel: GalleryViewModel?, audioUrl: String?) {
        self.galleryViewModel = viewModel
        self.audioUrl = audioUrl
    }
    
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let updatePostContentVC = UpdatePostContentViewController(viewModel: self.galleryViewModel, audioUrl: self.audioUrl)
        RoutingExecutor.navigate(from: root, to: updatePostContentVC, transitionType: transitionType, animated: animated, completion: nil)
        return updatePostContentVC
    }
}
