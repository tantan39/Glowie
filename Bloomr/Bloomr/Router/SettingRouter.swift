//
//  SettingRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct SettingRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let viewController = SettingViewController()
        RoutingExecutor.navigate(from: root, to: viewController, transitionType: transitionType, animated: animated, completion: completion)
        return viewController
    }
}
