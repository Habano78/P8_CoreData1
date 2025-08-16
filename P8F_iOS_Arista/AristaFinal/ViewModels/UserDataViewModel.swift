import Foundation
import CoreData

@MainActor
class UserDataViewModel: ObservableObject {
        
        @Published var firstName: String = ""
        @Published var lastName: String = ""
        
        private let userRepository: UserRepositoryProtocol
        
        init(service: UserRepositoryProtocol)
        {
                self.userRepository = service
        }
        
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
