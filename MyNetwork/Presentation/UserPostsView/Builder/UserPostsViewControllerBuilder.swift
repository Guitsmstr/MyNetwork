//
//  UserPostsViewControllerBuilder.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import Foundation



struct UserPostsViewControllerBuilder {
    
    func build(user: UserDisplayModel) -> UserPostsViewController {
        let coreDataManager = CoreDataManager.shared
        let networkingManager = NetworkingManager()
        let userRepository = UserRepository(coreDataManager: coreDataManager, networkingManager: networkingManager)
        let viewController = UserPostsViewController()
        let viewModel = UserPostsViewModel(user: user, userRepository: userRepository)
        viewController.viewModel = viewModel
        return viewController
    }
    
}
