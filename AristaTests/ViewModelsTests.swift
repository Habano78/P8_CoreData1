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
        func testUserDataViewModel() async throws {
                // Arrange
                let persistenceController = createInMemoryPersistenceController()
                let context = persistenceController.container.viewContext
                // pré-remplir un faux utilisateur dans notre base de test
                let user = User(context: context)
                user.firstName = "Gabriel"
                user.lastName = "Perez"
                try context.save()
                
                // On utilise "await" car l'initialisation d'un @MainActor est asynchrone depuis un contexte de test.
                let viewModel = await UserDataViewModel(context: context)
                
                // Act
                await viewModel.fetchUserData()
                
                // Assert
                #expect(await viewModel.firstName == "Gabriel")
                #expect(await viewModel.lastName == "Perez")
        }
}
