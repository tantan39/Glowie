//
//  Constant.swift
//  PizzaHutGlobal
//
//  Created by Jacob on 11/14/18.
//  Copyright © 2018 PHDV Asia. All rights reserved.
//

import UIKit

public struct Constant {
    
    #if PRODUCTION
        public static let apiBaseUrl = URL(string: "http://dev.glowieapp.com:8081/glowie-apis")!
        public static let photoBaseUrl = URL(string: "http://dev.glowieapp.com:8081/glowie-photo")!
    #else
        public static let apiBaseUrl = URL(string: "http://dev.glowieapp.com:8081/glowie-apis")!
        public static let photoBaseUrl = URL(string: "http://dev.glowieapp.com:8081/glowie-photo")!
    #endif
    static let uploadMediaMaxNumber = 5
    static let statusMaxLength = 700
    static let lastIndex = -1
    public static let appName = "Glowie"
    public static let alertOkayButtonTitle = "OK" //"alert.ok.title"
    public static let alertDismissButtonTitle = "Dismiss" //"alert.ok.dismiss"
    
    public static let emailFormatPattern = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]{2,64})+\\.[A-Za-z]{2,64}"
    
    // Keypath for api response
    public static let defaultKeypathForItem = "item"
    public static let defaultKeypathForArray = "list"
    public static let defaultKeypathForPagination = "pagination"
    
    public static let primary = "Primary"
    public static let secondary = "Secondary"
}

// MARK: - Encode/ Decode Key
extension Constant {
    /*
     countryID = 1 - VN
     appID = 2 - iOS
     */
    static let appKey: String = "glowier452678od9m0daedcw"
    static let secretKey: String = "glowiios"
    static let countryID: Int = 1
    static let appID: Int = 2
}

// MARK: - Language Constants
extension Constant {
    public static let selectedLanguageKey = "gms.core.selectedLanguage"
}

// MARK: - Font Constant
extension Constant {
    public static let font = "Font"
}

// MARK: - Color Constant
extension Constant {
    public static let color = "Color"
    
    public static let primary1 = "Primary1"
    public static let primary1Dark = "Primary1Dark"
    public static let primary1Light = "Primary1Light"
    
    public static let primary2 = "Primary2"
    
    public static let secondary1 = "Secondary1"
    public static let secondary2 = "Secondary2"
    public static let secondary3 = "Secondary3"
    public static let secondary4 = "Secondary4"
    public static let secondary5 = "Secondary5"
    
    public static let background1 = "Background1"
    public static let background2 = "Background2"
    
    public static let remark1 = "Remark1"
    public static let remark2 = "Remark2"
}
