//
//  UserListViewControllerBuilder.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import UIKit

struct UserListViewControllerBuilder {
    func build() -> UINavigationController {
        let coreDataManager = CoreDataManager.shared
        let networkingManager = NetworkingManager()
        let repository = UserRepository(coreDataManager: coreDataManager, networkingManager: networkingManager)
        let viewModel = UserListViewModel(userRepository: repository)
        let viewController = UserListViewController()
        viewController.viewModel = viewModel

        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.hidesBackButton = true
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
}
