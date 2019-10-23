//
//  UserSessionManager.swift
//  Bloomr
//
//  Created by Tan Tan on 9/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class UserSessionManager: NSObject {
    static var access_token: String?
    public static func accessToken() -> String? {
        return access_token
    }
    
    static var refresh_token: String?
    public static func refreshToken() -> String? {
        return refresh_token
    }
    
    static var expire_time: TimeInterval?
    public static func expireTime() -> TimeInterval? {
        return expire_time
    }
    
    private static var currentUser: User?
    public class func user() -> User? {
        return AppManager.shared.user
    }
    
    public class func saveUser(_ user: User) {
        AppManager.shared.user = user
        self.currentUser = user
    }
}
