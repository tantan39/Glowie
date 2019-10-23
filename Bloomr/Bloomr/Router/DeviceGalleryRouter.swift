//
//  DeviceGalleryViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/27/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct DeviceGalleryRouter: Router {    
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let galleryVC = GalleryViewController()
        RoutingExecutor.navigate(from: root, to: galleryVC.embbedToNavigationController(), transitionType: transitionType, animated: animated, completion: completion)
        return galleryVC
    }
}
