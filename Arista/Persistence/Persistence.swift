//
//  Persistence.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
//  Persistence.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import CoreData
import Foundation

struct PersistenceController {
        
        // MARK: Instances
        static let shared = PersistenceController() ///singleton
        
        let container: NSPersistentContainer
        var viewContext: NSManagedObjectContext { container.viewContext }
       
        
        // MARK: - Init
        init(inMemory: Bool = false, bundle: Bundle? = nil) {
                let modelName = "Arista"
                let bundleToUse = bundle ?? .main
                
                // 1Charger le modèle depuis le bundle fourni
                guard let modelURL = bundleToUse.url(forResource: modelName, withExtension: "momd"),
                      let model = NSManagedObjectModel(contentsOf: modelURL) else {
                        fatalError("Impossible de charger le modèle Core Data '\(modelName)' depuis \(bundleToUse.bundlePath)")
                }
                
                // 2Création du conteneur CoreData
                container = NSPersistentContainer(name: modelName, managedObjectModel: model)
                
                // 3Configurer le store
                if inMemory { ///pour les test
                        let description = NSPersistentStoreDescription()
                        description.type = NSInMemoryStoreType
                        description.shouldAddStoreAsynchronously = false
                        container.persistentStoreDescriptions = [description]
                } else { ///pour la prod
                        let description = container.persistentStoreDescriptions.first ?? NSPersistentStoreDescription()
                        description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
                        description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
                        container.persistentStoreDescriptions = [description]
                }
                
                // 4Charger le store
                container.loadPersistentStores { _, error in
                        if let error = error as NSError? {
                                fatalError("Unresolved Core Data error: \(error), \(error.userInfo)")
                        }
                }
                
                // 5Configurer le contexte
                container.viewContext.automaticallyMergesChangesFromParent = true
                container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                container.viewContext.undoManager = nil
                
                // 6Prépopulation uniquement en prod
                if !inMemory {
                        prepopulateDatabaseIfNeeded()
                }
        }
        
        func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
                /// Crée un contexte qui vit sur un thread d'arrière-plan
                let backgroundContext = container.newBackgroundContext()
                /// Exécute le code sur la file d'attente du contexte
                return try await backgroundContext.perform {
                        /// Le travail (création, suppression) se fait ici
                        let result = try block(backgroundContext)
                        
                        if backgroundContext.hasChanges {
                                try backgroundContext.save() /// le signal est envoyé ici !
                        }
                        
                        return result
                }
        }
        
        // MARK: func Helpers
        func saveIfNeeded() {
                let context = container.viewContext
                guard context.hasChanges else { return }
                do { try context.save() } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
        }
        
        // MARK: remplissage
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
