//
//  UserRepository.swift
//  Arista
//
//  Created by Perez William on 29/07/2025.
//
import Foundation
import CoreData

struct UserRepository {
        // Le "bureau de travail" de CoreData
        let viewContext: NSManagedObjectContext
        
        // L'initialiseur permet de recevoir le contexte depuis l'extérieur
        init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
                self.viewContext = viewContext
        }
        
        /// Récupère l'utilisateur de la base de données. Nous n'avons qu'un.
        func getUser() throws -> User? {
                // Crée une requête pour chercher des objets de type "User"
                let request: NSFetchRequest<User> = User.fetchRequest()
                
                // On indique qu'on ne veut qu'un seul résultat au maximum
                request.fetchLimit = 1
                
                // Exécute la requête et retourne le premier résultat trouvé
                return try viewContext.fetch(request).first
        }
}
