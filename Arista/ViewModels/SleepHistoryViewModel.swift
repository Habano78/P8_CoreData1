//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class SleepHistoryViewModel: ObservableObject {
        // 1. On change le type du tableau pour qu'il contienne nos vrais objets CoreData
        @Published var sleepSessions = [EnregistrementSommeil]()
        
        private var viewContext: NSManagedObjectContext
        
        init(context: NSManagedObjectContext) {
                self.viewContext = context
                fetchSleepSessions()
        }
        
        private func fetchSleepSessions() {
                // 2. On crée une requête de recherche pour les enregistrements de sommeil
                let fetchRequest: NSFetchRequest<EnregistrementSommeil> = EnregistrementSommeil.fetchRequest()
                
                // 3. On ajoute un tri pour afficher les plus récents en premier
                fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \EnregistrementSommeil.date, ascending: false)]
                
                do {
                        // 4. On exécute la requête et on met à jour notre tableau
                        sleepSessions = try viewContext.fetch(fetchRequest)
                } catch {
                        print("Failed to fetch sleep sessions: \(error)")
                }
        }
}
