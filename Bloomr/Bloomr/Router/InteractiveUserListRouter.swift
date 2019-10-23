//
//  InteractiveUserListRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/15/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct InteractiveUserListRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let viewController = InteractiveUserListViewController()
        viewController.hidesBottomBarWhenPushed = true
        RoutingExecutor.navigate(from: root, to: viewController, transitionType: transitionType, animated: animated, completion: completion)
        return viewController
    }
}
