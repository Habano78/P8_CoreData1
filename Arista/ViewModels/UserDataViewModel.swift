//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
import Foundation
import CoreData

@MainActor
class UserDataViewModel: ObservableObject {
        
        @Published var firstName: String = ""
        @Published var lastName: String = ""
        
        // Le ViewModel dépend maintenant du "contrat" (protocole), pas de l'implémentation concrète.
        private let userService: UserServiceProtocol
        
        /// L'initialiseur accepte n'importe quel objet qui respecte le contrat.
        /// Par défaut, il utilise le vrai UserRepository. Pour les tests, on peut lui injecter un Mock.
        init(service: UserServiceProtocol = UserRepository()) {
                self.userService = service
        }
        
        /// Récupère les données de l'utilisateur de manière asynchrone via le service.
        func fetchUserData() async {
                do {
                        guard let user = try await userService.getUser() else {
                                print("User not found.")
                                return
                        }
                        self.firstName = user.firstName ?? ""
                        self.lastName = user.lastName ?? ""
                } catch {
                        print("Failed to fetch user: \(error)")
                }
        }
}

