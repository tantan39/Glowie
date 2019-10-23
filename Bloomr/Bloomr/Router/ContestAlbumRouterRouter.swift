//
//  ContestAlbumRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct ContestAlbumRouter: Router {
    var contest: Contest?
    init(contest: Contest?) {
        self.contest = contest
    }
    
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let contestAlbum = ContestAlbumViewController()
        contestAlbum.viewModel.contest = self.contest
        RoutingExecutor.navigate(from: root, to: contestAlbum, transitionType: transitionType, animated: animated)
        return contestAlbum
    }
}
