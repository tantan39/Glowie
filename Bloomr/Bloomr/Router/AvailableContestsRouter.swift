//
//  AvailableContestsRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct AvailableContestsRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let availabelContestsViewController = AvailableContestsViewController()
        availabelContestsViewController.hidesBottomBarWhenPushed = true
        RoutingExecutor.navigate(from: root, to: availabelContestsViewController, transitionType: transitionType, animated: animated, completion: completion)
        return availabelContestsViewController
    }
}
