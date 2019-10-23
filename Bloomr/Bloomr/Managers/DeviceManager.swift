//
//  DeviceManager.swift
//  Bloomr
//
//  Created by Tan Tan on 9/18/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct DeviceManager {
    static let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
//    static let deviceID = UserSessionManager.accessToken() ?? ""
//    static let deviceID = String.random()
}
