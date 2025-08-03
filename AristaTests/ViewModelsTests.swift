//
//  ViewModelsTests.swift
//  AristaTests
//
//  Created by Perez William on 03/08/2025.
//
import Testing
import CoreData
@testable import Arista

struct ViewModelTests {
        
        /// Crée une base de données temporaire en mémoire pour chaque test.
        func createInMemoryPersistenceController() -> PersistenceController {
                return PersistenceController(inMemory: true)
        }
        
        @Test("Le ViewModel peut récupérer les données de l'utilisateur")
        func testUserDataViewModel() throws {
                // Arrange
                let persistenceController = createInMemoryPersistenceController()
                let context = persistenceController.container.viewContext
                // On pré-remplit un faux utilisateur dans notre base de test
                let user = User(context: context)
                user.firstName = "John"
                user.lastName = "Appleseed"
                try context.save()
                
                // Act
                let viewModel = UserDataViewModel(context: context)
                
                // Assert
                #expect(viewModel.firstName == "John")
                #expect(viewModel.lastName == "Appleseed")
        }
}
