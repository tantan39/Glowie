//
//  NotificationRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/14/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct NotificationListRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let viewController = NotificationListViewController()
        viewController.hidesBottomBarWhenPushed = true
        RoutingExecutor.navigate(from: root, to: viewController, transitionType: .push, animated: animated, completion: completion)
        return viewController
    }
}
