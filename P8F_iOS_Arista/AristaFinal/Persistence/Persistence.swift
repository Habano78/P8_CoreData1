import CoreData
import Foundation

/// Contrôleur unique pour Core Data, compatible prod, tests et previews.
struct PersistenceController {
        
        // MARK: - Instances partagées
        
        /// Instance partagée pour l'app (SQLite par défaut)
        static let shared = PersistenceController()
        
        /// Contexte principal
        var viewContext: NSManagedObjectContext { container.viewContext }
        
        let container: NSPersistentContainer
        
        // MARK: - Init
        
        /// - Parameters:
        ///   - inMemory: `true` pour un store éphémère (tests / previews)
        ///   - bundle: Bundle contenant le modèle Core Data
        init(inMemory: Bool = false, bundle: Bundle? = nil) {
                let modelName = "AristaFinal"
                let bundleToUse = bundle ?? .main
                
                // 1) Charger le modèle depuis le bundle fourni
                guard let modelURL = bundleToUse.url(forResource: modelName, withExtension: "momd"),
                      let model = NSManagedObjectModel(contentsOf: modelURL) else {
                        fatalError("Impossible de charger le modèle Core Data '\(modelName)' depuis \(bundleToUse.bundlePath)")
                }
                
                // 2) Créer le conteneur
                container = NSPersistentContainer(name: modelName, managedObjectModel: model)
                
                // 3) Configurer le store
                if inMemory {
                        let description = NSPersistentStoreDescription()
                        description.type = NSInMemoryStoreType
                        description.shouldAddStoreAsynchronously = false
                        container.persistentStoreDescriptions = [description]
                } else {
                        let description = container.persistentStoreDescriptions.first ?? NSPersistentStoreDescription()
                        description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
                        description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
                        container.persistentStoreDescriptions = [description]
                }
                
                // 4) Charger le store
                container.loadPersistentStores { _, error in
                        if let error = error as NSError? {
                                fatalError("Unresolved Core Data error: \(error), \(error.userInfo)")
                        }
                }
                
                // 5) Configurer le contexte
                container.viewContext.automaticallyMergesChangesFromParent = true
                container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                container.viewContext.undoManager = nil
                
                // 6) Prépopulation uniquement en prod
                if !inMemory {
                        prepopulateDatabaseIfNeeded()
                }
        }
        
        /// Exécute une tâche Core Data dans un contexte d'arrière-plan privé et sauvegarde les changements.
        /// - Parameter block: Le travail à effectuer, recevant le contexte d'arrière-plan.
        func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
                // Crée un nouveau contexte privé qui s'exécute sur une file d'attente d'arrière-plan
                let backgroundContext = container.newBackgroundContext()
                
                // Exécute le code sur la file d'attente du contexte
                return try await backgroundContext.perform {
                        let result = try block(backgroundContext)
                        
                        // Sauvegarde le contexte d'arrière-plan s'il y a eu des changements
                        if backgroundContext.hasChanges {
                                try backgroundContext.save()
                        }
                        
                        return result
                }
        }
        
        // MARK: - Helpers
        
        /// Sauvegarde si nécessaire
        func saveIfNeeded() {
                let context = container.viewContext
                guard context.hasChanges else { return }
                do { try context.save() } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
        }
        
        // MARK: - Seed (prod uniquement)
        
        /// Remplit la base de données avec des données par défaut au premier lancement
        private func prepopulateDatabaseIfNeeded() {
                let defaults = UserDefaults.standard
                guard !defaults.bool(forKey: "hasLaunchedBefore") else { return }
                
                let context = container.viewContext
                
                let newUser = User(context: context)
                newUser.lastName = "Perez"
                newUser.firstName = "Gabriel"
                
                let sleepRecord1 = Sleep(context: context)
                sleepRecord1.startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                sleepRecord1.duration = Int64((360...540).randomElement()!)
                sleepRecord1.quality  = Int64((5...10).randomElement()!)
                
                let sleepRecord2 = Sleep(context: context)
                sleepRecord2.startDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())
                sleepRecord2.duration = Int64((360...540).randomElement()!)
                sleepRecord2.quality  = Int64((5...10).randomElement()!)
                
                newUser.addToSleeps(sleepRecord1)
                newUser.addToSleeps(sleepRecord2)
                
                do {
                        try context.save()
                        defaults.set(true, forKey: "hasLaunchedBefore")
                } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
        }
}
