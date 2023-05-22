//
//  APIUserPost.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import Foundation

struct APIUserPost: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
