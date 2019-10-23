//
//  ExpandingMenu.swift
//  Bloomr
//
//  Created by Tan Tan on 8/19/19.
//  Copyright © 2019 phdv. All rights reserved.
//

enum ExpandingStyle {
    case cell
    case postPopup
}

class ExpandingMenu: UIView {
    
    private var homeButton: ExpandingMenuItem?
    var homePoint: CGPoint {
        set {
            self.homeButton?.center = newValue
        }
        get {
            return CGPoint(x: 80, y: self.height/2)
        }
    }
    var homeButtonSize: CGSize?
    var itemSize: CGSize?
    var menuItems: [ExpandingMenuItem]? {
        didSet {
            configMenuItems()
        }
    }
    var style: ExpandingStyle {
        get { return self.style }
        set {
            self.backgroundColor = newValue == .cell ? .init(white: 1, alpha: 0.6) : .clear
        }
    }
    
    var selectedIndex: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, style: ExpandingStyle) {
        self.init(frame: frame)
        
        self.style = style
        configHomeButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configHomeButton() {
        self.homeButton = ExpandingMenuItem(title: "...", image: nil, size: CGSize(width: 35, height: 35), backgroundColor: .deepOrange)
        self.addSubview(self.homeButton!)
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.homeButton?.center =  self.homePoint
        }, completion: nil)
        
        self.homeButton?.addTapGestureRecognizer(action: {
            guard let selectedIndex = self.selectedIndex else {return}
            selectedIndex(0)
        })
    }
    
    private func configMenuItems() {
        guard let menuItems = self.menuItems else { return }
        let angle: CGFloat = 0.0
        let distance: CGFloat = 10
        var lastItemOffset: CGFloat = self.homePoint.x
        var lastWidth: CGFloat = self.homeButton?.width ?? 0
        for (index, item) in menuItems.enumerated() {
            
            var pointX =  lastItemOffset + (CGFloat(cos(angle * CGFloat.pi/180)) * (item.width + distance) )
            pointX -= ((item.width - lastWidth) / 2)
            let pointY = self.homePoint.y + (CGFloat(sin(angle * CGFloat.pi/180)) * (item.width + distance) * CGFloat(index + 1))
            
            lastItemOffset = pointX
            lastWidth = item.width
            self.addSubview(item)
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                item.center = CGPoint(x: pointX, y: pointY)
            }, completion: nil)
            
            item.addTapGestureRecognizer {
                guard let selectedIndex = self.selectedIndex else {return}
                selectedIndex(index + 1)
            }
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event) {
            return view
        }
        AppManager.collapseMenu()
        return nil
    }
    
}
