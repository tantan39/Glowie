//
//  EditCoverRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct EditCoverRouter: Router {
    
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let viewModel = EditCoverViewModel()
        let editAvatarVC = EditCoverViewController(viewModel: viewModel)
        editAvatarVC.hidesBottomBarWhenPushed = true
        RoutingExecutor.navigate(from: root, to: editAvatarVC, transitionType: transitionType, animated: animated, completion: completion)
        return editAvatarVC
    }
}
