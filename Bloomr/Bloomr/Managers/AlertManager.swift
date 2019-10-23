//
//  AlertManager.swift
//  Bloomr
//
//  Created by Tan Tan on 9/22/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class AlertManager {
    public static let shared = AlertManager()
    public var allowShowMoreAlert = true
    var presetingAlertControllers = [UIAlertController]()
}

extension AlertManager {
    fileprivate func topMostController() -> UIViewController? {
        return UIViewController.topMostViewController()
    }
    
    // MARK: - Functions
    
    @discardableResult
    func show(_ title: String, message: String) -> UIAlertController? {
        return show(title, message: message, acceptMessage: Constant.alertOkayButtonTitle.localized(), acceptBlock: {
            // Do nothing
        })
    }
    
    @discardableResult
    // Show with default title
    func show(message: String) -> UIAlertController? {
        return show(Constant.appName, message: message, acceptMessage: Constant.alertOkayButtonTitle.localized(), acceptBlock: {
            // Do nothing
        })
    }
    
    @discardableResult
    func show(_ title: String, message: String, acceptMessage: String, acceptBlock: @escaping () -> Void) -> UIAlertController? {
        guard self.allowShowMoreAlert else { return nil }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (_: UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)
        
        topMostController()?.present(alert, animated: true, completion: nil)
        presetingAlertControllers.append(alert)
        return alert
    }
    
    @discardableResult
    func show(_ title: String?, message: String, buttons: [String], tapBlock: ((UIAlertAction, Int) -> Void)?) -> UIAlertController? {
        guard self.allowShowMoreAlert else { return nil }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        topMostController()?.present(alert, animated: true, completion: nil)
        presetingAlertControllers.append(alert)
        return alert
    }
    
    @discardableResult
    func show(_ title: String = "",
              message: String,
              defaultButtonTitle: String? = TextManager.okayText.localized(),
              defaultButtonColor: UIColor? = .deepOrange,
              defaultButtonHandler: ((UIAlertAction) -> Void)? = nil,
              cancelButtonTitle: String? = TextManager.cancelText.localized(),
              cancelButtonColor: UIColor? = .soft_blue,
              cancelButtonHandler: ((UIAlertAction) -> Void)? = nil,
              destructiveButtonTitle: String? = nil,
              destructiveButtonColor: UIColor? = .deepOrange,
              destructiveButtonHandler: ((UIAlertAction) -> Void)? = nil,
              completion: (() -> Void)? = nil
        ) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        var buttonText = TextManager.okayText.localized()
        
        if defaultButtonTitle != nil {
            buttonText = defaultButtonTitle!
        }
        
        let defaultAction = UIAlertAction(title: buttonText, style: .default, handler: defaultButtonHandler)
        
        if let color = defaultButtonColor {
            defaultAction.setValue(color, forKey: "titleTextColor")
        }
        
        alertController.addAction(defaultAction)
        
        if cancelButtonTitle != nil {
            let cancelAction = UIAlertAction(title: cancelButtonTitle!, style: .cancel, handler: cancelButtonHandler)
            
            if let color = cancelButtonColor {
                cancelAction.setValue(color, forKey: "titleTextColor")
            }
            
            alertController.addAction(cancelAction)
        }
        
        if destructiveButtonTitle != nil {
            let destructiveAction = UIAlertAction(title: destructiveButtonTitle!, style: .destructive, handler: destructiveButtonHandler)
            
            if let color = cancelButtonColor {
                destructiveAction.setValue(color, forKey: "titleTextColor")
            }
            
            alertController.addAction(destructiveAction)
        }
        
        alertController.view.tintColor = UIColor.blue
        topMostController()?.present(alertController, animated: true, completion: nil)
        presetingAlertControllers.append(alertController)
        return alertController
    }
    
    @discardableResult
    func actionSheet(_ title: String? = nil, message: String? = nil, sourceView: UIView, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    @discardableResult
    func actionSheet(_ title: String, message: String, sourceView: UIView, buttons: [String], tapBlock: ((UIAlertAction, Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet, buttons: buttons, tapBlock: tapBlock)
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    @discardableResult
    func showTextFieldError(title: String?, message: String?, textField: UITextField, completion: (() -> Void)?) -> UIAlertController {
        // Set focus on text field
        textField.becomeFirstResponder()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constant.alertOkayButtonTitle.localized(), style: .default) { (_) in
            if let completion = completion {
                completion()
            }
        }
        alertController.addAction(okAction)
        topMostController()?.present(alertController, animated: true, completion: nil)
        return alertController
    }
}

private extension UIAlertController {
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, buttons: [String], tapBlock: ((UIAlertAction, Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .default, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            self.addAction(action)
        }
    }
}

private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertAction.Style, buttonIndex: Int, tapBlock: ((UIAlertAction, Int) -> Void)?) {
        self.init(title: title, style: preferredStyle) { (action: UIAlertAction) in
            if let block = tapBlock {
                block(action, buttonIndex)
            }
        }
    }
}
