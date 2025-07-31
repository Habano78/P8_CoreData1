//
//  SleepRepository.swift
//  Arista
//
//  Created by Perez William on 29/07/2025.
//

import Foundation
import CoreData

struct SleepRepository {
        // Le "bureau de travail" de CoreData
        let viewContext: NSManagedObjectContext
        
        // L'initialiseur permet de recevoir le contexte depuis l'extérieur
        init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
                self.viewContext = viewContext
        }
        /// Récupère toutes les sessions de sommeil, triées par date (la plus récente en premier).
        func getSleepSessions() throws -> [Sleep] {
                // Crée une requête pour chercher des objets de type "Sleep"
                let request: NSFetchRequest<Sleep> = Sleep.fetchRequest()
                
                // Ajoute une règle de tri pour afficher les plus récentes en premier
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Sleep.startDate, ascending: false)]
                
                // Exécute la requête et retourne le tableau de résultats
                return try viewContext.fetch(request)
        }
}
