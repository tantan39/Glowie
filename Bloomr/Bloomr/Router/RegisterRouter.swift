//
//  RegisterRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/23/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct RegisterRouter: Router {
    
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let viewModel = RegisterViewModel()
        let viewController = RegisterViewController(viewModel: viewModel)
        RoutingExecutor.navigate(from: root, to: viewController, transitionType: transitionType, animated: animated, completion: completion)
        return viewController
    }
}
