//
//  PostProfile.swift
//  Bloomr
//
//  Created by Tan Tan on 10/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

protocol PostProfileProtocol {
    var name: String? { get set }
    var username: String? { get set }
    var isShare: Bool { get set }
    var isFollow: Bool { get set }
    var uid: Int? { get set }
    var avatar: String? { get set }

}
