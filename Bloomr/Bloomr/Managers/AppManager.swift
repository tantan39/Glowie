//
//  AppManager.swift
//  Bloomr
//
//  Created by Tan Tan on 8/18/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class AppManager {
    static let shared = AppManager()
    var homeTabBarView: HomeTabBarView?
    var menuView: ExpandingMenu?
    var selectedContest: Contest?
    var user: User?
    var selectedGender: Gender = .female
    
    static func showExpandingMenu(from parent: UIView?, style: ExpandingStyle, homeSelected: (() -> Void)?, valueSelected: @escaping (Int) -> Void, storeSelected: (() -> Void)?) {
        AppManager.shared.homeTabBarView?.updateStatus(active: false)
        guard let parentView = parent else { return }
        let convertFrame = parentView.convert(parentView.frame, to: UIApplication.shared.keyWindow)
        
        switch style {
        case .cell:
            AppManager.shared.menuView = ExpandingMenu(frame: convertFrame, style: .cell)
        default:
            AppManager.shared.menuView = ExpandingMenu(frame: CGRect(origin: CGPoint(x: convertFrame.minX, y: convertFrame.height/2), size: CGSize(width: convertFrame.width - convertFrame.minX, height: 65)), style: .postPopup)
        }
        
        let item1 = ExpandingMenuItem(title: "10", image: nil, size: CGSize(width: 35, height: 35), backgroundColor: .deepOrange)
        let item2 = ExpandingMenuItem(title: "100", image: nil, size: CGSize(width: 40, height: 40), backgroundColor: .deepOrange)
        let item3 = ExpandingMenuItem(title: "200", image: nil, size: CGSize(width: 48, height: 48), backgroundColor: .deepOrange)
        let item4 = ExpandingMenuItem(title: "", image: UIImage(named: "icon-menu-shop"), size: CGSize(width: 48, height: 48), backgroundColor: .aqua)
        
        AppManager.shared.menuView?.menuItems = [item1, item2, item3, item4]
        UIApplication.shared.keyWindow?.addSubview(AppManager.shared.menuView ?? ExpandingMenu(frame: .zero))
        AppManager.shared.menuView?.selectedIndex = { index in
            switch index {
            case 0:
                homeSelected?()
            case 1:
                valueSelected(10)
            case 2:
                valueSelected(100)
            case 3:
                valueSelected(200)
            case 4:
                if let viewController = UIViewController.topMostViewController() {
                    _ = FlowerShopRouter().navigate(from: viewController.navigationController, transitionType: .push, animated: true)
                }
                storeSelected?()
            default:
                break
            }
            
            AppManager.shared.menuView?.removeFromSuperview()
            
            AppManager.shared.homeTabBarView?.updateStatus(active: true)
            AppManager.shared.homeTabBarView?.goBackToTabBar()
        }
    }
    
    static func collapseMenu() {
        AppManager.shared.menuView?.removeFromSuperview()
        AppManager.shared.homeTabBarView?.updateStatus(active: true)
        AppManager.shared.homeTabBarView?.goBackToTabBar()
    }
    
    static func showAfterEffect(from parent: UIView?, style: ExpandingStyle) {
        guard let parentView = parent else { return }
        let convertFrame = parentView.convert(parentView.frame, to: UIApplication.shared.keyWindow)
        let thankYou = ThankYouCustomView(frame: CGRect(x: 100, y: 0, width: 100, height: 45))
        switch style {
        case .cell:
            thankYou.centerY = convertFrame.centerY
            UIApplication.shared.keyWindow?.addSubview(thankYou)
        default:
            thankYou.frame.origin = CGPoint(x: 60, y: 0)
            parentView.addSubview(thankYou)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            thankYou.removeFromSuperview()
        }
    }
    
    func showActionSheet(title: String?, itemsTitle: [String]?, cancelTitle: String?, completion: ((() -> Void)?), selectedIndex: ((_ index: Int) -> Void)?) {
        guard let itemsTitle = itemsTitle else { return }
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        for (index, title) in itemsTitle.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                // some functonal
                selectedIndex!(index)
            })
            actionSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        
        actionSheet.addAction(cancelAction)
        
        if let viewController = UIViewController.topMostViewController() {
            viewController.present(actionSheet, animated: true, completion: completion)
        }
    }

    func updateFlowerNumber(flower: Int?) {
        guard let flower = flower, flower > 0 else { return }
        AppManager.shared.homeTabBarView?.flowerNumber = flower
    }
}
