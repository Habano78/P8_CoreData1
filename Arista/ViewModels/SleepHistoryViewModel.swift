//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
import Foundation
import CoreData

@MainActor
class SleepHistoryViewModel: ObservableObject {
        
        // MARK: Propriété
        @Published var sleepSessions = [Sleep]()
        
        private let sleepRepository: SleepRepository
        
        // MARK: - Init
        init(context: NSManagedObjectContext) {
                self.sleepRepository = SleepRepository(viewContext: context)
        }
        
        // MARK: - Action
        func fetchSleepSessions() async {
                do {
                        sleepSessions = try await sleepRepository.getSleepSessions()
                } catch {
                        print("Failed to fetch sleep sessions: \(error)")
                }
        }
}
