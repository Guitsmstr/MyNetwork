//
//  UserListViewModel.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import Foundation
import Combine


class UserListViewModel {
    private let userRepository: UserRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published var users: [UserDisplayModel] = []
    @Published var isFirstFetchCompleted: Bool = false
    @Published var loading: Bool = false
    
    init(userRepository: UserRepositoryProtocol){
        self.userRepository = userRepository
    }

    func fetchUsersFromCacheOrService(){
        loading = true
        userRepository.getUsersFromCacheOrService()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching users: \(error)")
                case .finished:
                    print("Finished fetching users")
                }
                self?.loading = false
            } receiveValue: { [weak self] users in
                self?.users = users
                self?.isFirstFetchCompleted = true
                self?.loading = false
            }
            .store(in: &cancellables)

    }

    func filterUsers(by searchText: String) {
        userRepository.filterUsers(by: searchText)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching users: \(error)")
                case .finished:
                    print("Finished fetching users")
                }
            } receiveValue: { [weak self] users in
                self?.users = users
            }
            .store(in: &cancellables)
    }



}
