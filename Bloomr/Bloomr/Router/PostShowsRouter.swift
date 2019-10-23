//
//  PostDetailsRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 8/24/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Pulley
struct PostShowsRouter: Router {
    var viewModel: PostShowsViewModel?
    
    init(data: [GalleryThumbnail]?, selectedItem: GalleryThumbnail?) {
        self.viewModel = PostShowsViewModel(galleries: data, selectedItem: selectedItem)
    }
    
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        
        let primaryViewController = PostShowsViewController(viewModel: self.viewModel)
        let secondaryViewController = PostContentViewController(viewModel: self.viewModel)
        
        let pulleyViewController = PulleyViewController(contentViewController: primaryViewController, drawerViewController: secondaryViewController)
        RoutingExecutor.navigate(from: root, to: pulleyViewController, transitionType: transitionType, animated: true, completion: nil)
        return pulleyViewController
    }
}
