//
//  AppDelegate.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import IQKeyboardManager
import AppCenter
import SVProgressHUD
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIGestureRecognizerDelegate {

    var window: UIWindow?
    let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Logging.setupLogger()
        
        SVProgressHUD.setBackgroundLayerColor(.veryLightPinkTwo)
        SVProgressHUD.setDefaultMaskType(.black)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        MSAppCenter.start("a57e98bf-0387-4f02-8fdb-f4c25a02bc34", withServices: nil)
        
//        window?.rootViewController = ViewController()
//        _ = HomeTabBarRouter().navigate(from: window, transitionType: .changeRootController, animated: true)
        
        _ = WelcomeRouter().navigate(from: window, transitionType: .changeRootController, animated: true)
        
//        var backButtonImage = UIImage(named: "back")
//        backButtonImage = backButtonImage?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 30)
//        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, for: .normal, barMetrics: .default)
        
//        let api = SampleAPI.getActiveAlbumContest
//        SampleAPIProvider.rx.requestGetArray(ofType: UserAlbumContest.self, api).subscribe(onNext: { (response) in
//            guard let res = response else { return }
//            
//        }).disposed(by: self.disposeBag)
        
//        SampleAPIProvider.rx.requestWithProgress(api).map { (data) -> [GalleryThumbnail]? in
//            guard let response = data.response?.mapApi(), let json = response.data else { return nil }
//            let list = json["list"].arrayValue
//            let objects = list.compactMap({ GalleryThumbnail(json: $0 )})
//            return objects
//        }.subscribe(onNext: { (array) in
//            guard let arr = array else { return }
//
//        }).disposed(by: self.disposeBag)
        return true
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        return true
//    }
}
