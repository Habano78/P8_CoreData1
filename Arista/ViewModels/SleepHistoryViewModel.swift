//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
import Foundation
import CoreData

class SleepHistoryViewModel: ObservableObject {
        
        // MARK: Properties
        @Published var sleepSessions = [Sleep]()
        
        private let sleepRepository: SleepRepository
        
        // MARK: - Init
        init(context: NSManagedObjectContext) {
                self.sleepRepository = SleepRepository(viewContext: context)
                fetchSleepSessions()
        }
        
        // MARK: - Methods
        private func fetchSleepSessions() {
                do {
                        sleepSessions = try sleepRepository.getSleepSessions()
                } catch {
                        print("Failed to fetch sleep sessions: \(error)")
                }
        }
}
