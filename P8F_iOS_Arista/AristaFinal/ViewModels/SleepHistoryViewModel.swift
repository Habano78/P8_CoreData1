import Foundation
import CoreData

@MainActor
class SleepHistoryViewModel: ObservableObject {
        
        @Published var sleepSessions = [Sleep]()
        private let sleepRepository: SleepRepositoryProtocol
        
        init(service: SleepRepositoryProtocol) {
                self.sleepRepository = service
        }
        
        func fetchSleepSessions() async {
                do {
                        self.sleepSessions = try await sleepRepository.getSleepSessions()
                } catch {
                        print("Failed to fetch sleep sessions: \(error)")
                }
        }
}
