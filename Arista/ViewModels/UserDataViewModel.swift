//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class UserDataViewModel: ObservableObject {
        @Published var firstName: String = ""
        @Published var lastName: String = ""
        
        private var viewContext: NSManagedObjectContext
        
        init(context: NSManagedObjectContext) {
                self.viewContext = context
                fetchUserData()
        }
        
        private func fetchUserData() {
                // 1. création d'une requête pour a request to find all objects of type "Utilisateur"
                let fetchRequest: NSFetchRequest<Utilisateur> = Utilisateur.fetchRequest()
                
                do {
                        // 2. On demande à CoreData : "Trouve-moi l'utilisateur"
                        let users = try viewContext.fetch(fetchRequest)
                        
                        // 3. On prend le premier utilisateur trouvé (Gabriel Perez)
                        if let user = users.first {
                                // 4. On copie ses informations dans les propriétés du ViewModel
                                self.firstName = user.prenom ?? ""
                                self.lastName = user.nom ?? ""
                        }
                } catch {
                        // In a real app, handle the error more gracefully
                        print("Failed to fetch user: \(error)")
                }
        }
}
