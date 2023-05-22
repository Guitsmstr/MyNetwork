//
//  UserPostsViewModel.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import Foundation
import Combine


class UserPostsViewModel {
    
    var user: UserDisplayModel
    @Published var posts: [UserPostDisplayModel] = []
    @Published var loading: Bool = false
    var cancellables = Set<AnyCancellable>()
    var userRepository : UserRepositoryProtocol
    
    init(user: UserDisplayModel, userRepository: UserRepositoryProtocol) {
        self.user = user
        self.userRepository = userRepository
    }
    
    func fetchPosts(){
        loading = true
        userRepository.fetchPosts(by: user.id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching posts: \(error)")
                case .finished:
                    print("Finished fetching posts")
                }
                self?.loading = false
            } receiveValue: { [weak self] posts in
                self?.posts = posts
                self?.loading = false
            }.store(in: &cancellables)
    }
    
}
