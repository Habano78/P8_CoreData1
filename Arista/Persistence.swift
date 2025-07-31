//
//  Persistence.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
import CoreData
import Foundation

// PersistenceController est le chef d'orchestre de CoreData. C'est le point d'entrée unique pour tout ce qui concerne la base de données.
// Son unique but est de préparer et de configurer toute la pile CoreData pour que le reste de votre application puisse l'utiliser facilement.


struct PersistenceController {
        static let shared = PersistenceController()
        
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
        
        let container: NSPersistentContainer
        
        init(inMemory: Bool = false) {
                container = NSPersistentContainer(name: "Arista")
                if inMemory {
                        container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
                }
                container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                        if let error = error as NSError? {
                                fatalError("Unresolved error \(error), \(error.userInfo)")
                        }
                })
                container.viewContext.automaticallyMergesChangesFromParent = true
                
                // APPELLE de la FONCTION ICI, APRÈS LE CHARGEMENT
                prepopulateDatabaseIfNeeded()
        }
        
        private func prepopulateDatabaseIfNeeded() {
                // Étape 1 : Vérifier si l'action a déjà été faite
                let defaults = UserDefaults.standard
                let hasLaunchedBefore = defaults.bool(forKey: "hasLaunchedBefore")
                
                guard !hasLaunchedBefore else { return }
                
                // Étape 2 : Obtenir le contexte
                let context = container.viewContext
                
                // Étape 3 : Créer l'objet User avec les bons attributs
                let newUser = User(context: context)
                newUser.lastName = "Perez"
                newUser.firstName = "Gabriel"
               
                // Étape 4 : Créer des enregistrements de sommeil avec les bons attributs
                let sleepRecord1 = Sleep(context: context)
                sleepRecord1.startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) // Hier
                sleepRecord1.duration = Int64((360...540).randomElement()!) // Durée en minutes (ex: 6 à 9h)
                sleepRecord1.quality = Int64((5...10).randomElement()!)   // Qualité sur 10
                
                let sleepRecord2 = Sleep(context: context)
                sleepRecord2.startDate = Calendar.current.date(byAdding: .day, value: -2, to: Date()) // Avant-hier
                sleepRecord2.duration = Int64((360...540).randomElement()!)
                sleepRecord2.quality = Int64((5...10).randomElement()!)
                
                // Étape 5 : Lier les enregistrements de sommeil à l'utilisateur
                // Assurez-vous que la relation dans votre .xcdatamodeld s'appelle bien "sleeps"
                newUser.addToSleeps(sleepRecord1)
                newUser.addToSleeps(sleepRecord2)
                
                // Étape 6 : Sauvegarder le contexte
                do {
                        try context.save()
                        defaults.set(true, forKey: "hasLaunchedBefore")
                } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
        }
}
