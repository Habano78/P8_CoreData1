//
//  SleepRepository.swift
//  Arista
//
//  Created by Perez William on 29/07/2025.
//
import Foundation
import CoreData

//MARK: Contrat
struct SleepRepository: SleepRepositoryProtocol {
        
        let viewContext: NSManagedObjectContext
        
        init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
                self.viewContext = viewContext
        }
        
        //MARK: Methode (récupère in async toutes les sessions de sommeil)
        func getSleepSessions() async throws -> [Sleep] {
                let request: NSFetchRequest<Sleep> = Sleep.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Sleep.startDate, ascending: false)]
                
                return try await viewContext.perform {
                        try self.viewContext.fetch(request)
                }
        }
}
