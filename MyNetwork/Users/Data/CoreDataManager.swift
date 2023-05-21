//
//  CoreDataManager.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import Foundation

import CoreData

protocol CoreDataManagerProtocol {
    func fetchUsers(by searchText: String?) throws -> [MNUser]
    var context: NSManagedObjectContext { get }
    func saveContext() throws
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourModelName")
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
    
    func fetchUsers(by searchText: String? = nil) throws -> [MNUser] {
        let fetchRequest: NSFetchRequest<MNUser> = MNUser.fetchRequest()
        if let searchText = searchText, !searchText.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
        let users = try context.fetch(fetchRequest)
        return users
        
    }
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

