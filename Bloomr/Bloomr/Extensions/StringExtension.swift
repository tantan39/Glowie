//
//  StringExtension.swift
//  PizzaHutGlobal
//
//  Created by Jacob on 11/14/18.
//  Copyright © 2018 PHDV Asia. All rights reserved.
//

import UIKit
import Localize_Swift
import CryptoSwift
public extension String {
    
//    public func localized() -> String {
//        return NSLocalizedString(self, comment: "")
//    }
    
    /*
     Triming white space from start and end of the string
     */
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func removeEmoji() -> String {
        return trimmingCharacters(in: CharacterSet.symbols)
    }
    
    func contains(_ string: String) -> Bool {
        return (self.range(of: string) != nil) ? true : false
    }
    
    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
/**
 * String file path processing
 */
public extension String {
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    var stringByDeletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
    
    func firstChars(length: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: length)
        return String(self[..<index])
    }
}

/**
 * String is number only
 */
public extension String {
    var isNumeric: Bool {
        guard !self.isEmpty else {
            return false
        }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    var intValue: Int? {
        return Int(self)
    }
    
    var doubleValue: Double? {
        return Double(self)
    }
}

// MARK: - Handle with subscript ...
extension String {
    public subscript(value: NSRange) -> Substring {
        return self[value.lowerBound..<value.upperBound]
    }
}

extension String {
    public subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }
    
    public subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }
    
    public subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }
    
    public subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(at: value.upperBound)]
        }
    }
    
    public subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }
    
    public func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
}

extension String {
    public func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    public func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    public func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

extension String {
    static func random() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<8).map { _ in letters.randomElement()! })
    }
    
    func aesEncrypt(key: String, iv: String) -> String? {
        var result: String?
        do {
            // 用UTF8的编碼方式將字串轉成Data
            let data: Data = self.data(using: String.Encoding.utf8, allowLossyConversion: true)!
            
            // 用AES的方式將Data加密
            let aecEnc: AES = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .noPadding)
            let enc = try aecEnc.encrypt(data.bytes)
            
            // 使用Base64編碼方式將Data轉回字串
            let encData: Data = Data(bytes: enc, count: enc.count)
            result = encData.base64EncodedString()
        } catch {
            print("\(error.localizedDescription)")
        }
        
        return result
    }
    
    func aesDecrypt(key: String, iv: String) -> String? {
        var result: String?
        do {
            // 使用Base64的解碼方式將字串解碼後再轉换Data
            let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0))!
            
            // 用AES方式將Data解密
            let aesDec: AES = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7)
            let dec = try aesDec.decrypt(data.bytes)
            
            // 用UTF8的編碼方式將解完密的Data轉回字串
            let desData: Data = Data(bytes: dec, count: dec.count)
            result = String(data: desData, encoding: .utf8)!
        } catch {
            print("\(error.localizedDescription)")
        }
        
        return result
    }
    
    func aesEncrypt() throws -> String {
        let KeyPassword = "GatePasswords123"
        let KeyIv  = "1234567890123456"
        if let data = self.data(using: .utf8) {
            do {
                
                let aes = try AES(key: KeyPassword.bytes, blockMode: CBC(iv: KeyIv.bytes), padding: Padding.pkcs5)
                
                let encrypted = try aes.encrypt(data.bytes)
                
                let encryptedData = Data(encrypted)
                
                print(encryptedData.base64EncodedString())
                return encryptedData.base64EncodedString()
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        return ""
    }

}
