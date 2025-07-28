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
        
        // AJOUT de la FONCTION COMPLÈTE
        private func prepopulateDatabaseIfNeeded() {
                // Étape 1 : Vérifier si l'action a déjà été faite
                let defaults = UserDefaults.standard
                let hasLaunchedBefore = defaults.bool(forKey: "hasLaunchedBefore")
                
                guard !hasLaunchedBefore else { return }
                
                // Étape 2 : Obtenir le contexte (notre "bureau de travail")
                let context = container.viewContext
                
                // Étape 3 : Créer l'objet Utilisateur
                let newUser = Utilisateur(context: context)
                newUser.nom = "Perez"
                newUser.prenom = "Gabriel"
                newUser.email = "perez.gabriel@arista.com"
                newUser.poids = 77.5
                newUser.taille = 176
                
                // Création d'une date de naissance pour l'exemple
                var dateComponents = DateComponents()
                dateComponents.year = 1990
                dateComponents.month = 5
                dateComponents.day = 15
                newUser.dateDeNaissance = Calendar.current.date(from: dateComponents)
                
                // Étape 4 : Créer deux enregistrements de sommeil
                let sleepRecord1 = EnregistrementSommeil(context: context)
                sleepRecord1.date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) // Hier
                sleepRecord1.heureDebut = sleepRecord1.date
                sleepRecord1.heureFin = Date()
                
                let sleepRecord2 = EnregistrementSommeil(context: context)
                sleepRecord2.date = Calendar.current.date(byAdding: .day, value: -2, to: Date()) // Avant-hier
                sleepRecord2.heureDebut = sleepRecord2.date
                sleepRecord2.heureFin = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                
                // Étape 5 : Lier les enregistrements de sommeil à l'utilisateur
                newUser.addToEnregistrementsSommeil(sleepRecord1)
                newUser.addToEnregistrementsSommeil(sleepRecord2)
                
                // Étape 6 : Sauvegarder le contexte
                do {
                        try context.save()
                        // Marquer que le pré-remplissage a été fait
                        defaults.set(true, forKey: "hasLaunchedBefore")
                } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
        }
}
