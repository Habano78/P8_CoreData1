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
        
        //MARK: Propriétés
        @Published var firstName: String = ""
        @Published var lastName: String = ""
        
        private let userRepository: UserRepository
        
        //MARK: Init
        init(context: NSManagedObjectContext) {
                self.userRepository = UserRepository (viewContext: context)
        }
        
        func fetchUserData() async {
                do {
                        /// On appelle bien le Repository
                        guard let user = try await userRepository.getUser() else {
                                print("User not found from repository.")
                                return
                        }
                        /// mise à jour sécurisée grâce à @MainActor
                        self.firstName = user.firstName ?? ""
                        self.lastName = user.lastName ?? ""
                } catch {
                        print("Failed to fetch user via repository: \(error)")
                }
        }
}



