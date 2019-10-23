//
//  ChangePasswordRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/28/19.
//  Copyright © 2019 phdv. All rights reserved.
//
struct ChangePasswordRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let viewController = ChangePasswordViewController()
        RoutingExecutor.navigate(from: root, to: viewController, transitionType: transitionType, animated: animated, completion: completion)
        return viewController
    }
}
