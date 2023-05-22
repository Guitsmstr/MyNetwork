//
//  PostDisplayModel.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import Foundation

class UserPostDisplayModel {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    init(apiUserPost: APIUserPost) {
        self.id = apiUserPost.id
        self.userId = apiUserPost.userId
        self.title = apiUserPost.title
        self.body = apiUserPost.body
    }
    
}
