//
//  ContestInfoRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 8/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct ContestInfoRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let contestInfoViewController = ContestInfoViewController()
        contestInfoViewController.hidesBottomBarWhenPushed = true
        RoutingExecutor.navigate(from: root, to: contestInfoViewController, transitionType: transitionType, animated: animated, completion: nil)
        return contestInfoViewController
    }
}
