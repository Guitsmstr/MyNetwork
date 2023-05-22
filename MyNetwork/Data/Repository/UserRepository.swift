//
//  UserRepository.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import Foundation
import Combine

protocol UserRepositoryProtocol {
    func getUsersFromCacheOrService() -> AnyPublisher<[UserDisplayModel], AppError>
    func filterUsers(by searchText: String) ->AnyPublisher<[UserDisplayModel], AppError>
}

enum AppError: Error {
    case network(NetworkError)
    case coreData(Error)
}


class UserRepository: UserRepositoryProtocol {
    private let coreDataManager: CoreDataManagerProtocol
    private let networkingManager: NetworkingManagerProtocol
    
    
    init(coreDataManager: CoreDataManagerProtocol, networkingManager: NetworkingManagerProtocol) {
        self.coreDataManager = coreDataManager
        self.networkingManager = networkingManager
    }
    
    
    func getUsersFromCacheOrService() -> AnyPublisher<[UserDisplayModel], AppError> {
        return coreDataManager.fetchUsers(by: nil)
            .mapError{AppError.coreData($0)}
            .flatMap{savedUsers -> AnyPublisher<[UserDisplayModel], AppError> in
                if savedUsers.isEmpty {
                    return self.networkingManager.fetchUsers(from: URL(string: APIEndpoints.Users.fetch))
                        .mapError{AppError.network($0)}
                        .flatMap { users in
                            self.coreDataManager.save(users: users)
                                .mapError{AppError.coreData($0)}
                                .map{savedUsers in
                                    savedUsers.map(UserDisplayModel.init)
                                }.eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                }else {
                    return Just(savedUsers)
                        .setFailureType(to: AppError.self)
                        .map{ users in
                            users.map(UserDisplayModel.init)
                        }.eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    func filterUsers(by searchText: String) -> AnyPublisher<[UserDisplayModel], AppError> {
        return coreDataManager.fetchUsers(by: searchText)
            .mapError{AppError.coreData($0)}
            .map{filteredUsers in
                filteredUsers.map(UserDisplayModel.init)
            }.eraseToAnyPublisher()
    }
    
}
