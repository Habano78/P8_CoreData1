//
//  UserRepository.swift
//  Arista
//
//  Created by Perez William on 29/07/2025.
//
import Foundation
import CoreData

struct UserRepository: UserRepositoryProtocol {
        
        private let persistenceController: PersistenceController
        private var viewContext: NSManagedObjectContext { persistenceController.viewContext }
        
        init(persistenceController: PersistenceController = .shared)
        {
                self.persistenceController = persistenceController
        }
        
        func getUser() async throws -> User? {
                let request: NSFetchRequest<User> = User.fetchRequest()
                request.fetchLimit = 1
                
                return try await viewContext.perform {
                        try self.viewContext.fetch(request).first
                }
        }
}
