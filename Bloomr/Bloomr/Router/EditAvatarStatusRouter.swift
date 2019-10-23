//
//  EditAvatarStatusRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/12/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct EditAvatarStatusRouter: Router {
    var viewModel: EditAvatarViewModel?
    
    init(viewModel: EditAvatarViewModel?) {
        self.viewModel = viewModel
    }
    
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let viewController = EditAvatarStatusViewController()
        viewController.viewModel = self.viewModel
        
        RoutingExecutor.navigate(from: root, to: viewController, transitionType: transitionType, animated: animated, completion: completion)
        return viewController
    }
}
