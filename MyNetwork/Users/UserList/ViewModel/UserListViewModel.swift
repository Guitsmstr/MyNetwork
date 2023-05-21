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
    
    init(userRepository: UserRepositoryProtocol){
        self.userRepository = userRepository
    }

    func fetchUsers(){
        userRepository.getUsers()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching users: \(error)")
                case .finished:
                    print("Finished fetching users")
                }
            } receiveValue: { users in
                self.users = users
            }
            .store(in: &cancellables)

    }

    func saveUsers() {
        // save users to coredata
    }


}
