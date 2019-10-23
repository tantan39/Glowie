//
//  FillPostStatusRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 8/28/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct FillPostStatusRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let viewController = FillPostStatusViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        RoutingExecutor.navigate(from: root, to: viewController, transitionType: transitionType, animated: animated, completion: completion)
        return viewController
    }
}
