//
//  APIEndpoints.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import Foundation

struct APIEndpoints {
    static let baseURL = "https://jsonplaceholder.typicode.com/"
    
    struct Users {
        static var fetch: String { return baseURL + "users" }
    }
}
