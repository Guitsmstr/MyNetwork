//
//  CoreDataManager.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import Foundation
import Combine
import CoreData

protocol CoreDataManagerProtocol {
    func fetchUsers(by searchText: String?) -> AnyPublisher<[MNUser], Error>
    var context: NSManagedObjectContext { get }
    func save(users: [APIUser]) -> AnyPublisher<[MNUser], Error>
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyNetwork")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetchUsers(by searchText: String? = nil) -> AnyPublisher<[MNUser], Error> {
        return Deferred {
            Future { promise in
                let fetchRequest: NSFetchRequest<MNUser> = MNUser.fetchRequest()
                if let searchText = searchText, !searchText.isEmpty {
                    fetchRequest.predicate = NSPredicate(format: "name BEGINSWITH[cd] %@", searchText)
                }
                do{
                    let users = try self.context.fetch(fetchRequest)
                    promise(.success(users))
                }
                catch{
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
        
        
//        let fetchRequest: NSFetchRequest<MNUser> = MNUser.fetchRequest()
//        if let searchText = searchText, !searchText.isEmpty {
//            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
//        }
//        let users = try context.fetch(fetchRequest)
//        return users
        
    }
    
    
    func save(users: [APIUser]) -> AnyPublisher<[MNUser], Error> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self else {
                    return
                }
                
                var savedUsers = [MNUser]()
                
                users.forEach { apiUser in
                    let user = MNUser(context: self.context)
                    user.id = Int64(apiUser.id)
                    user.name = apiUser.name
                    user.email = apiUser.email
                    user.phone = apiUser.phone
                    
                    savedUsers.append(user)
                }
                
                do {
                    try self.context.save()
                    promise(.success(savedUsers))
                } catch {
                    self.context.rollback()
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

