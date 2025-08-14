//
//  Persistence.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

// PersistenceController est le chef d'orchestre de CoreData. C'est le point d'entrée unique pour tout ce qui concerne la base de données.
// Son unique but est de préparer et de configurer toute la pile CoreData pour que le reste de votre application puisse l'utiliser facilement.

import CoreData
import Foundation

struct PersistenceController {
        /// Le singleton partagé pour l'application principale.
        static let shared = PersistenceController()
        
        /// Un singleton pour les tests
        static var preview: PersistenceController = {
                let result = PersistenceController(inMemory: true)
                let viewContext = result.container.viewContext
                
                do {
                        try viewContext.save()
                } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                return result
        }()
        
        /// Container CoreData qui gère la base de données.
        let container: NSPersistentContainer
        
        //MARK: Init (construit la base de données)
        init(inMemory: Bool = false) {
                
                let modelName = "AristaFinal"
                
                // 1. On charge le modèle de données de manière explicite pour éviter les conflits.
                guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
                        fatalError("Failed to find data model: \(modelName)")
                }
                guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
                        fatalError("Failed to create model from file: \(modelURL)")
                }
                
                container = NSPersistentContainer(name: modelName, managedObjectModel: mom)
                
                if inMemory {
                        // Si c'est pour un test ou une preview, on ne sauvegarde rien sur le disque.
                        container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
                }
                
                // On charge la base de données.
                container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                        if let error = error as NSError? {
                                fatalError("Unresolved error \(error), \(error.userInfo)")
                        }
                })
                container.viewContext.automaticallyMergesChangesFromParent = true
                
                // 2. On appelle la fonction de pré-remplissage après le chargement.
                prepopulateDatabaseIfNeeded()
        }
        
        /// Crée les données de départ (User et Sleep) lors du tout premier lancement de l'application.
        private func prepopulateDatabaseIfNeeded() {
                let defaults = UserDefaults.standard
                let hasLaunchedBefore = defaults.bool(forKey: "hasLaunchedBefore")
                
                guard !hasLaunchedBefore else { return }
                
                let context = container.viewContext
                
                let newUser = User(context: context)
                newUser.lastName = "Perez"
                newUser.firstName = "Gabriel"
                
                let sleepRecord1 = Sleep(context: context)
                sleepRecord1.startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                sleepRecord1.duration = Int64((360...540).randomElement()!)
                sleepRecord1.quality = Int64((5...10).randomElement()!)
                
                let sleepRecord2 = Sleep(context: context)
                sleepRecord2.startDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())
                sleepRecord2.duration = Int64((360...540).randomElement()!)
                sleepRecord2.quality = Int64((5...10).randomElement()!)
                
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
