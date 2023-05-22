//
//  UserDisplayModel.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import Foundation

struct UserDisplayModel {
    let name: String
    let phone: String
    let email: String
    let id: Int

    
    init (name: String, phone: String, email: String, id: Int){
        self.name = name
        self.phone = phone
        self.email = email
        self.id = id
    }
    
    init(apiUser: APIUser) {
        self.name = apiUser.name
        self.phone = apiUser.phone
        self.email = apiUser.email
        self.id = apiUser.id
    }
    
    init(user: MNUser) {
        self.name = user.name ?? ""
        self.phone = user.phone ?? ""
        self.email = user.email ?? ""
        self.id = Int(user.id)
        }
}
