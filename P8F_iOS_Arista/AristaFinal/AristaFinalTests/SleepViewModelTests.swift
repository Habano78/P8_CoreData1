//
//  Test.swift
//  AristaTests
//
//  Created by Perez William on 14/08/2025.
//

import Testing
import CoreData
@testable import AristaFinal

@MainActor
struct SleepHistoryViewModelTests {
        
        /// Contexte CoreData en mémoire pour créer des objets factices.
        func createInMemoryContext() -> NSManagedObjectContext {
                return PersistenceController(inMemory: true).container.viewContext
        }
        
        @Test("Le SleepHistoryViewModel récupère bien les sessions de sommeil")
        func testSleepHistoryViewModel_FetchesSleep_Succeeds() async {
                // Arrange
                let context = createInMemoryContext()
                let fakeSleep = Sleep(context: context)
                fakeSleep.duration = 480
                
                var mockService = MockSleepRepository()
                mockService.mockSleepSessions = [fakeSleep]
                
                let viewModel = SleepHistoryViewModel(service: mockService)
                
                // Act
                await viewModel.fetchSleepSessions()
                
                // Assert
                #expect(viewModel.sleepSessions.count == 1)
                #expect(viewModel.sleepSessions.first?.duration == 480)
        }
        
        @Test("Le SleepHistoryViewModel gère un échec de récupération")
        func testSleepHistoryViewModel_FetchesSleep_Fails() async {
                // Arrange
                var mockService = MockSleepRepository()
                mockService.shouldFail = true
                
                let viewModel = SleepHistoryViewModel(service: mockService)
                
                // Act
                await viewModel.fetchSleepSessions()
                
                // Assert
                #expect(viewModel.sleepSessions.isEmpty)
        }
}
