//
//  UserProfileRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/18/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct UserProfileRouter: Router {
    var uid: Int?
    init(uid: Int?) {
        self.uid = uid
    }
    
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let viewModel = MyProfileViewModel()
        viewModel.uid = self.uid
        let viewController = UserProfileViewController(viewModel: viewModel)
        RoutingExecutor.navigate(from: root, to: viewController, transitionType: transitionType, animated: animated, completion: completion)
        return viewController
    }
}
