//
//  UserRepository.swift
//  Arista
//
//  Created by Perez William on 29/07/2025.
//
import Foundation
import CoreData

//MARK: Contrat
struct UserRepository: UserRepositoryProtocol {
        
        let viewContext: NSManagedObjectContext
        
        init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
                self.viewContext = viewContext
        }
        
        //MARK: Methode (récupère in async l'unique utilisateur)
        func getUser() async throws -> User? {
                let request: NSFetchRequest<User> = User.fetchRequest()
                request.fetchLimit = 1
                
                return try await viewContext.perform {
                        try self.viewContext.fetch(request).first
                }
        }
}
