//
//  Dimension.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

public let dimension = Dimension.shared

open class Dimension {
    public static let shared = Dimension()
    static let homeTabBarButtonWidth: CGFloat = 42
    
    public var widthScreen: CGFloat = 1.0
    public var heightScreen: CGFloat = 1.0
    public var widthScale: CGFloat = 1.0
    public var heightScale: CGFloat = 1.0
    
    private init() {
        self.widthScale = UIScreen.main.bounds.width / 375
        self.heightScale = UIScreen.main.bounds.height / 667
        self.widthScreen = UIScreen.main.bounds.width
        self.heightScreen = UIScreen.main.bounds.height
        
        if self.widthScale >= 2.0 {
            self.widthScale /= 1.4
            self.heightScale /= 1.4
        }
    }
    
    public var fontScale: CGFloat {
        return 1.0
    }
    
    // MARK: Default height
    public var flowerIconWidth: CGFloat {
        return 10 * self.heightScale
    }
    
    public var avatarWidth_38: CGFloat {
        return 38 * self.heightScale
    }
    
    public var avatarWidth_45: CGFloat {
        return 45 * self.heightScale
    }
    
    public var avatarWidth_60: CGFloat {
        return 60 * self.heightScale
    }

    public var buttonHeight_35: CGFloat {
        return 35 //* self.heightScale
    }
    
    public var buttonHeight_40: CGFloat {
        return 40 //* self.heightScale
    }
    
    public var buttonHeight: CGFloat {
        return 48 //* self.heightScale
    }
    
    public var buttonHeight_55: CGFloat {
        return 55 //* self.heightScale
    }
    
    public var mediumButtonHeight: CGFloat {
        return 40 //* self.heightScale
    }
    
    public var smallButtonHeight: CGFloat {
        return 28 //* self.heightScale
    }
    
    public var smallButtonWidth: CGFloat {
        return 77 //* self.heightScale
    }
    
    public var largeButtonWidth: CGFloat {
        return 250 //* self.heightScale
    }
    
    public var textViewHeight: CGFloat {
        return 0.108 * self.heightScreen
    }
    
    public var largeTextViewHeight: CGFloat {
        return 0.231 * self.heightScreen
    }
    
    public var textFieldHeight: CGFloat {
        return 46 * self.heightScale
    }
    
    // MARK: Spacing
    public var smallHorizontalMargin: CGFloat {
        return 4 * self.widthScale
    }
    
    public var smallVerticalMargin: CGFloat {
        return 4 * self.widthScale
    }
    
    public var mediumHorizontalMargin: CGFloat {
        return 8 * self.widthScale
    }
    
    public var mediumVerticalMargin: CGFloat {
        return 8 * self.widthScale
    }
    
    public var mediumVerticalMargin_10: CGFloat {
        return 10 * self.widthScale
    }
    
    public var mediumHorizontalMargin_10: CGFloat {
        return 10 * self.widthScale
    }
    
    public var mediumHorizontalMargin_12: CGFloat {
        return 12 * self.widthScale
    }

    public var mediumVerticalMargin_12: CGFloat {
        return 12 * self.widthScale
    }
    
    public var normalHorizontalMargin_14: CGFloat {
        return 14 * self.widthScale
    }
    
    public var normalVerticalMargin_14: CGFloat {
        return 14 * self.widthScale
    }
    
    public var normalHorizontalMargin: CGFloat {
        return 16 * self.widthScale
    }
    
    public var normalVerticalMargin: CGFloat {
        return 16 * self.widthScale
    }
    
    public var normalHorizontalMargin_20: CGFloat {
        return 20 * self.widthScale
    }
    
    public var normalVerticalMargin_20: CGFloat {
        return 20 * self.widthScale
    }

    public var largeHorizontalMargin: CGFloat {
        return 24 * self.widthScale
    }
    
    public var largeVerticalMargin: CGFloat {
        return 24 * self.widthScale
    }
    
    public var largeHorizontalMargin_32: CGFloat {
        return 32 * self.widthScale
    }
    
    public var largeVerticalMargin_32: CGFloat {
        return 32 * self.widthScale
    }
    
    public var largeHorizontalMargin_38: CGFloat {
        return 38 * self.widthScale
    }
    
    public var largeVerticalMargin_38: CGFloat {
        return 38 * self.widthScale
    }
    
    public var largeHorizontalMargin_40: CGFloat {
        return 40 * self.widthScale
    }
    
    public var largeHorizontalMargin_42: CGFloat {
        return 40 * self.widthScale
    }
    
    public var largeVerticalMargin_40: CGFloat {
        return 40 * self.widthScale
    }
    
    public var largeHorizontalMargin_48: CGFloat {
        return 48 * self.widthScale
    }
    
    public var largeVerticalMargin_48: CGFloat {
        return 48 * self.widthScale
    }
    
    public var largeHorizontalMargin_56: CGFloat {
        return 56 * self.widthScale
    }
    
    public var largeVerticalMargin_56: CGFloat {
        return 56 * self.widthScale
    }
    
    public var largeHorizontalMargin_60: CGFloat {
        return 60 * self.widthScale
    }
    
    public var largeVerticalMargin_60: CGFloat {
        return 60 * self.widthScale
    }
    
    public var largeHorizontalMargin_80: CGFloat {
        return 80 * self.widthScale
    }
    
    public var largeVerticalMargin_80: CGFloat {
        return 80 * self.widthScale
    }
    
    public var largeHorizontalMargin_90: CGFloat {
        return 90 * self.widthScale
    }
    
    public var largeVerticalMargin_90: CGFloat {
        return 90 * self.widthScale
    }
    
    public var largeHorizontalMargin_96: CGFloat {
        return 96 * self.widthScale
    }
    
    public var largeHorizontalMargin_120: CGFloat {
        return 120 * self.widthScale
    }
    
    public var largeVerticalMargin_120: CGFloat {
        return 120 * self.widthScale
    }
    
    public var zeroMargin: CGFloat {
        return 0.0
    }
    
    public var segmentIndicatorHeight: CGFloat {
        return 2 * self.widthScale
    }
    
    public var generalScale: CGFloat {
        let standardArea = CGFloat(375.0 * 667.0)
        let currentArea = UIScreen.main.bounds.width * UIScreen.main.bounds.height
        return sqrt(currentArea/standardArea)
    }
}
