//
//  PostItemProtocol.swift
//  Bloomr
//
//  Created by Tan Tan on 8/25/19.
//  Copyright © 2019 phdv. All rights reserved.
//
protocol UserPostItemProtocol {
    var postItems: [PostItem] { get }
    var user: String? { get }
}

protocol PostItemProtocol {
    var type: ContestItemFormatType { get }
}
