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
        
        //Dépendance au UserRepo
        private let userRepository: UserRepository
        
        // instantiation de UserRepo
        init(context: NSManagedObjectContext) {
                self.userRepository = UserRepository (viewContext: context)
                fetchUserData()
        }
        
        private func fetchUserData() {
                
                do {
                        // demande au repo de nous donner le user
                        guard let user = try userRepository.getUser() else {
                                // si aucun user n'est trouvé, on gère l'erreur
                                print("User not found. The database might not be prepopulated.")
                                return
                        }
                        // On met à jour nos propriétés avec les données reçues
                                    firstName = user.firstName ?? ""
                                    lastName = user.lastName ?? ""
                } catch {
                        // On gère l'erreur ici
                        print("Failed to fetch user: \(error)")
                }
        }
}
