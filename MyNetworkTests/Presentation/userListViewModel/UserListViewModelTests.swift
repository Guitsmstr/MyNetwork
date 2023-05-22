//
//  UserListViewModelTests.swift
//  MyNetworkTests
//
//  Created by Guillermo on 21/05/23.
//

import XCTest
import Combine
@testable import MyNetwork // Replace with your actual project module name

class UserListViewModelTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    private var mockRepository: MockUserRepository!
    private var viewModel: UserListViewModel!

    override func setUp() {
        super.setUp()
        cancellables = []
        mockRepository = MockUserRepository()
        viewModel = UserListViewModel(userRepository: mockRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchUsersFromCacheOrService() {
        let expectation = XCTestExpectation(description: "Fetch users from cache or service")

        mockRepository.expectedUsers = [UserDisplayModel(name: "Test",  phone: "1234567890", email: "test@email.com", id: 1)]

        viewModel.$users
            .sink { users in
                if !users.isEmpty {
                    XCTAssertEqual(users[0].id, 1)
                    XCTAssertEqual(users[0].name, "Test")
                    XCTAssertEqual(users[0].email, "test@email.com")
                    XCTAssertEqual(users[0].phone, "1234567890")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchUsersFromCacheOrService()
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testFilterUsers() {
        let expectation = XCTestExpectation(description: "Filter users")

        mockRepository.expectedUsers = [
            UserDisplayModel(name: "Test",  phone: "1234567890", email: "test@email.com", id: 1),
            UserDisplayModel(name: "Bob", phone: "0987654321",  email: "bob@email.com", id: 2)
        ]

        viewModel.$users
            .sink { users in
                if users.count == 1 {
                    XCTAssertEqual(users[0].id, 2)
                    XCTAssertEqual(users[0].name, "Bob")
                    XCTAssertEqual(users[0].email, "bob@email.com")
                    XCTAssertEqual(users[0].phone, "0987654321")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.filterUsers(by: "Bob")
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock UserRepository

//class MockUserRepository: UserRepositoryProtocol {
//    var mockUsers = [UserDisplayModel]()
//    
//    func getUsersFromCacheOrService() -> AnyPublisher<[UserDisplayModel], AppError> {
//        Just(mockUsers).setFailureType(to: AppError.self).eraseToAnyPublisher()
//    }
//
//    func filterUsers(by searchText: String) -> AnyPublisher<[UserDisplayModel], AppError> {
//        Just(mockUsers.filter { $0.name.contains(searchText) })
//            .setFailureType(to: AppError.self)
//            .eraseToAnyPublisher()
//    }
//
//    func fetchPosts(by userID: Int) -> AnyPublisher<[UserPostDisplayModel], AppError> {
//        // For simplicity, we don't use this method in the testing of the UserListViewModel.
//        fatalError("Not implemented")
//    }
//}

class MockUserRepository: UserRepositoryProtocol {

    var expectedUsers: [UserDisplayModel] = []
    var expectedPosts: [UserPostDisplayModel] = []
    var expectedFetchUsersError: AppError?
    var expectedFetchPostsError: AppError?
    
    var mockUsers = [UserDisplayModel]()

    func getUsersFromCacheOrService() -> AnyPublisher<[UserDisplayModel], AppError> {
        if let error = expectedFetchUsersError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(expectedUsers).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func filterUsers(by searchText: String) -> AnyPublisher<[UserDisplayModel], AppError> {
        let filteredUsers = expectedUsers.filter { $0.name.contains(searchText) }
        return Just(filteredUsers).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func fetchPosts(by userID: Int) -> AnyPublisher<[UserPostDisplayModel], AppError> {
        if let error = expectedFetchPostsError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(expectedPosts).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}
