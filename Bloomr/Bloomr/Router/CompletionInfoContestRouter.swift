//
//  ChooseInfoContestRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct CompletionInfoContestRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let chooseInfoContestVC = CompletionInfoContestViewController()
        RoutingExecutor.navigate(from: root, to: chooseInfoContestVC, transitionType: transitionType, animated: animated, completion: completion)
        return chooseInfoContestVC
    }
}
