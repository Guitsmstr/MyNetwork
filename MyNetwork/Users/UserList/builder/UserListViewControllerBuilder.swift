//
//  UserListViewControllerBuilder.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import Foundation

struct UserListViewControllerBuilder {
    func build()->UserListViewController{
        let coreDataManager = CoreDataManager.shared
        let networkingManager = NetworkingManager()
        let repository = UserRepository(coreDataManager: coreDataManager, networkingManager: networkingManager)
        let viewModel = UserListViewModel(userRepository: repository)
        let viewController = UserListViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
