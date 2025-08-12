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
        
        //MARK: Properties
        @Published var firstName: String = ""
        @Published var lastName: String = ""
        
        private let userRepository: UserRepositoryProtocol
        
        //MARK: Init
        init(service: UserRepositoryProtocol = UserRepository()) {
                self.userRepository = service
        }
        
        //MARK: Action
        func fetchUserData() async {
                do {
                        guard let user = try await userRepository.getUser() else { return }
                        self.firstName = user.firstName ?? ""
                        self.lastName = user.lastName ?? ""
                } catch {
                        print("Failed to fetch user: \(error)")
                }
        }
}
