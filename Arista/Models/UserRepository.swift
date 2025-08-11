//
//  UserRepository.swift
//  Arista
//
//  Created by Perez William on 29/07/2025.
//
import Foundation
import CoreData

struct UserRepository {
        //MARK: Propriété
        let viewContext: NSManagedObjectContext
        
        //MARK: Init
        init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
                self.viewContext = viewContext
        }
        //MARK: Action
        func getUser() async throws -> User? {
                /// Crée une requête pour chercher des objets de type "User"
                let request: NSFetchRequest<User> = User.fetchRequest()
                request.fetchLimit = 1
                /// Exécute la requête de manière asynchrone
                return try await viewContext.perform {
                        try self.viewContext.fetch(request).first
                }
        }
}
