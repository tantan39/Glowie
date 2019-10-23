//
//  TypeAlias.swift
//  Bloomr
//
//  Created by Tan Tan on 11/14/18.
//  Copyright © 2018 PHDV Asia. All rights reserved.
//

import UIKit

// Define type alias used within the app

public typealias VoidBlock = (() -> Void)
public typealias AnyScreen = AnyObject
public typealias TextFieldLengthRange = (min: Int, max: Int)
typealias OTPResult = (verified: Bool, m_id: Int)
//typealias AuthenResult = (verified: Bool, m_id: Int)

public typealias CompletionBlock = (_ result: Any?, _ error: ServiceErrorAPI?) -> Void
