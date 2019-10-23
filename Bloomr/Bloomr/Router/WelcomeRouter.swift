//
//  RegisterRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/23/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct WelcomeRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let viewController = WelcomeViewController()
        
        RoutingExecutor.navigate(from: root, to: viewController.embbedToNavigationController(), transitionType: transitionType)
        return viewController
    }
}
