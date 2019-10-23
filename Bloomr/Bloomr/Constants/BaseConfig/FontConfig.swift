//
//  FontConfig.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

public enum FontFormat: String {
    case regular = "Regular"
    case italic = "Italic"
    case light = "Light"
    case medium = "Medium"
    case bold = "Bold"
}

struct PHFont {
    var fontNames: [FontFormat: String]
    
    init(_ dictionary: [String: String]? = nil) {
        self.fontNames = [:]
        
        guard let dictionary = dictionary else { return }
        
        for value in dictionary {
            if let format = FontFormat(rawValue: value.key) {
                self.fontNames[format] = value.value
            }
        }
    }
}

struct FontConfig {
    // MARK: - Define Variables
    var primary: PHFont = PHFont()
    
}
