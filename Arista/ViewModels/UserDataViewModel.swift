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
                        // 1. On appelle bien le Repository, comme vous l'avez dit
                        guard let user = try userRepository.getUser() else {
                                print("User not found from repository.")
                                return
                        }
                        
                        // 2. On s'assure que la mise à jour se fait sur le thread principal
                        DispatchQueue.main.async {
                                self.firstName = user.firstName ?? ""
                                self.lastName = user.lastName ?? ""
                        }
                } catch {
                        print("Failed to fetch user via repository: \(error)")
                }
        }
}



