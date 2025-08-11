//
//  SleepRepository.swift
//  Arista
//
//  Created by Perez William on 29/07/2025.
//

import Foundation
import CoreData

struct SleepRepository {
        //MARK: Propriété
        let viewContext: NSManagedObjectContext
        
        //MARK: Init
        init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
                self.viewContext = viewContext
        }
        //MARK: Action
        func getSleepSessions() async throws -> [Sleep] {
                let request: NSFetchRequest<Sleep> = Sleep.fetchRequest()
                ///tri pour afficher les plus récentes en premier
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Sleep.startDate, ascending: false)]
                return try await viewContext.perform {
                        try self.viewContext.fetch(request)
                }
        }
}
