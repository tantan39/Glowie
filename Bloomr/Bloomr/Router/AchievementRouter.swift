//
//  AchievementRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/13/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct AchievementRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let viewController = AchievementViewController()
        viewController.hidesBottomBarWhenPushed = true
        RoutingExecutor.navigate(from: root, to: viewController, transitionType: transitionType, animated: animated, completion: completion)
        return viewController
    }
}
