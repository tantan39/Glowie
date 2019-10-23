//
//  EditAvatarRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 9/11/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct EditAvatarRouter: Router {
    var editType: EditType = .avatar
    
    init(edit type: EditType) {
        self.editType = type
    }
    
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let viewModel = EditAvatarViewModel()
        viewModel.editType.accept(self.editType)
        let editAvatarVC = EditAvatarViewController(viewModel: viewModel)
        editAvatarVC.hidesBottomBarWhenPushed = true
        RoutingExecutor.navigate(from: root, to: editAvatarVC, transitionType: transitionType, animated: animated, completion: completion)
        return editAvatarVC
    }
}
