//
//  UserListViewModel.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import Foundation



class UserListViewModel {
    @Published var users: [UserDisplayModel] = []

    func fetchUsers(by searchText: String? = nil){
        
        // fetch users from the coreData

    }

    func saveUsers() {
        // save users to coredata
    }


}