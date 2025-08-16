import Foundation
import CoreData

struct SleepRepository: SleepRepositoryProtocol {
        
        private let persistenceController: PersistenceController
        private var viewContext: NSManagedObjectContext { persistenceController.viewContext }
        
        init(persistenceController: PersistenceController = .shared) {
                self.persistenceController = persistenceController
        }
        
        func getSleepSessions() async throws -> [Sleep] {
                let request: NSFetchRequest<Sleep> = Sleep.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Sleep.startDate, ascending: false)]
                
                return try await viewContext.perform {
                        try self.viewContext.fetch(request)
                }
        }
}
