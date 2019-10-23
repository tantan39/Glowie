//
//  DetailStatusRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 8/22/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct DetailStatusRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let detailVC = DetailStatusViewController()
        RoutingExecutor.navigate(from: root, to: detailVC, transitionType: transitionType, animated: animated, completion: nil)
        return detailVC
    }
}
