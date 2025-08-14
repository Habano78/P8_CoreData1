//
//  ViewModelsTests.swift
//  AristaTests
//
//  Created by Perez William on 03/08/2025.
//

import Testing
import CoreData
@testable import AristaFinal

@MainActor
struct UserDataViewModelTests {
        
        /// Crée un contexte CoreData en mémoire, utile pour créer des objets factices.
        func createInMemoryContext() -> NSManagedObjectContext {
                return PersistenceController(inMemory: true).container.viewContext
        }
        
        @Test("Le ViewModel récupère bien les données utilisateur du Mock")
        func testUserDataViewModel_FetchesUser_Succeeds() async {
                // Arrange
                let context = createInMemoryContext()
                let fakeUser = User(context: context)
                fakeUser.firstName = "Gabriel"
                fakeUser.lastName = "Perez"
                
                let mockService = MockUserRepository(mockUser: fakeUser)
                let viewModel = UserDataViewModel(service: mockService)
                
                // Act
                await viewModel.fetchUserData()
                
                // Assert
                #expect(viewModel.firstName == "Gabriel")
                #expect(viewModel.lastName == "Perez")
        }
        
        @Test("Le ViewModel gère une erreur venant du Mock")
        func testUserDataViewModel_FetchesUser_Fails() async {
                // Arrange
                var mockService = MockUserRepository()
                mockService.shouldFail = true
                
                let viewModel = UserDataViewModel(service: mockService)
                
                // Act
                await viewModel.fetchUserData()
                
                // Assert
                #expect(viewModel.firstName.isEmpty)
                #expect(viewModel.lastName.isEmpty)
        }
}
