//
//  BaseTabbarViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/8/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeTabBarController: UITabBarController, SEDraggableLocationEventResponder {
    
    let homeTabBarSize = CGSize(width: 42, height: 80)
    
    lazy var homeTabBar: HomeTabBarView = {
        let view = HomeTabBarView(frame: CGRect(x: (self.tabBar.bounds.width - homeTabBarSize.width)/2, y: -15, width: homeTabBarSize.width, height: homeTabBarSize.height))
        return view
    }()
    
    let viewModel = HomeTabbarViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeContestViewController = HomeContestViewController()
        let view2 = UIViewController()
        let view3 = ViewController()
        let view4 = ViewController()
        let myProfileViewController = MyProfileViewController()
        
        self.viewControllers = [homeContestViewController.embbedToNavigationController(), view2.embbedToNavigationController(), view3.embbedToNavigationController(), view4.embbedToNavigationController(), myProfileViewController.embbedToNavigationController()]
        
        homeContestViewController.tabBarItem = ESTabBarItem.init(ESTabBarItemContentView(), title: nil,
                                             image: UIImage(named: "icon_tabbar_contest_normal")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "icon_tabbar_contest_active")?.withRenderingMode(.alwaysOriginal))
        
        view2.tabBarItem = ESTabBarItem.init(ESTabBarItemContentView(), title: nil,
                                             image: UIImage(named: "icon_tabbar_mybloomer_normal")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "icon_tabbar_mybloomer_active")?.withRenderingMode(.alwaysOriginal))
        view3.tabBarItem = UITabBarItem()
        
        view4.tabBarItem = ESTabBarItem.init(ESTabBarItemContentView(), title: nil,
                                             image: UIImage(named: "icon_tabbar_chat_normal")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "icon_tabbar_chat_active")?.withRenderingMode(.alwaysOriginal))
        
        myProfileViewController.tabBarItem = ESTabBarItem.init(ESTabBarItemContentView(), title: nil,
                                             image: UIImage(named: "icon_tabbar_me_normal")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "icon_tabbar_me_active")?.withRenderingMode(.alwaysOriginal))
        
        self.tabBar.setValue(true, forKey: "_hidesShadow")
        self.tabBar.addSubview(self.homeTabBar)
        AppManager.shared.homeTabBarView = self.homeTabBar
        
        handleObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func handleObservers() {
        self.viewModel.user.subscribe(onNext: { [weak self] (user) in
            guard let self = self, let user = user else { return }
            
            AppManager.shared.homeTabBarView?.flowerNumber = user.flowers
        }).disposed(by: self.disposeBag)
    }
    
    private func configureDraggableLocation(location: SEDraggableLocation) {
        location.delegate = self
        location.objectWidth = 42
        location.objectHeight = 42
        location.marginTop = Float(location.centerY - 21)
        location.marginLeft = Float(location.centerX - 21)
    }
    
    func draggableLocation(_ location: SEDraggableLocation!, didAcceptObject object: SEDraggable!, entryMethod method: SEDraggableLocationEntryMethod) {
        object.isHidden = true
        logDebug("didAcceptObject object")
    }
    
}
