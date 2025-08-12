//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
import Foundation
import CoreData
import SwiftUI

@MainActor
class SleepHistoryViewModel: ObservableObject {
        
        //MARK: Properties
        @Published var sleepSessions = [Sleep]()
        private let sleepRepository: SleepRepositoryProtocol
        
        //MARK: Init
        init(service: SleepRepositoryProtocol = SleepRepository()) {
                self.sleepRepository = service
        }
        
        //MARK: Action
        func fetchSleepSessions() async {
                do {
                        self.sleepSessions = try await sleepRepository.getSleepSessions()
                } catch {
                        print("Failed to fetch sleep sessions: \(error)")
                }
        }
}
