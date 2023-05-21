//
//  NetworkManager.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import Foundation
import Combine

protocol NetworkingManagerProtocol {
    func fetchUsers(from url: URL?) -> AnyPublisher<[APIUser], NetworkError>
}

enum NetworkError: Error {
    case urlError
    case decodingError
    case networkError
}

class NetworkingManager: NetworkingManagerProtocol {
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUsers(from url: URL?) -> AnyPublisher<[APIUser], NetworkError> {
        guard let url = url else {
            return Fail(error: NetworkError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw NetworkError.networkError
                }
                return output.data
            }
            .decode(type: [APIUser].self, decoder: JSONDecoder())
            .mapError { error in
                switch error {
                case is URLError:
                    return NetworkError.urlError
                case is DecodingError:
                    return NetworkError.decodingError
                default:
                    return NetworkError.networkError
                }
            }
            .eraseToAnyPublisher()
    }
}
