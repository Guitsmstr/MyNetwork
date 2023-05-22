//
//  UserPostsViewModelTests.swift
//  MyNetworkTests
//
//  Created by Guillermo on 21/05/23.
//

import XCTest
import Combine
@testable import MyNetwork



class UserPostsViewModelTests: XCTestCase {
    var viewModel: UserPostsViewModel!
    var mockRepository: MockUserRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        let user = UserDisplayModel(apiUser: APIUser(id: 1, name: "User 1", email: "user1@example.com", phone: "1234567890"))
        viewModel = UserPostsViewModel(user: user, userRepository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchPosts() {
        let expectation = XCTestExpectation(description: "Fetch user posts")

        let mockPosts = [
            UserPostDisplayModel(apiUserPost: APIUserPost(userId: 1, id: 1, title: "Post 1", body: "Body 1")),
            UserPostDisplayModel(apiUserPost: APIUserPost(userId: 1, id: 2, title: "Post 2", body: "Body 2"))
        ]
        mockRepository.expectedPosts = mockPosts

        viewModel.$posts
            .sink { returnedPosts in
                if returnedPosts.first?.id == mockPosts.first?.id && returnedPosts.last?.id == mockPosts.last?.id {
                    expectation.fulfill()
                } else {
                    XCTFail("Returned posts should match the expected posts.")
                }
            }
            .store(in: &cancellables)

        viewModel.fetchPosts()

        wait(for: [expectation], timeout: 1.0)
    }
}
