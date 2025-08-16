//
//  UserDataViewModelTests.swift
//  AristaTests
//
//  Created by Perez William on 03/08/2025.
//

import Testing
import CoreData
@testable import Arista

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
                let mockService = MockUserRepository()
                mockService.shouldFail = true
                
                let viewModel = UserDataViewModel(service: mockService)
                
                // Act
                await viewModel.fetchUserData()
                
                // Assert
                #expect(viewModel.firstName.isEmpty)
                #expect(viewModel.lastName.isEmpty)
        }
        
        @Test("Le ViewModel gère le cas où aucun utilisateur n'est trouvé")
        func testUserDataViewModel_UserNotFound() async {
                // Arrange
                // On crée un mock qui retourne "nil" (aucun utilisateur)
                let mockService = MockUserRepository(mockUser: nil)
                let viewModel = UserDataViewModel(service: mockService)
                
                // Act
                await viewModel.fetchUserData()
                
                // Assert
                // Les propriétés doivent rester vides
                #expect(viewModel.firstName.isEmpty)
                #expect(viewModel.lastName.isEmpty)
        }
        
        @Test("Le ViewModel gère un prénom vide (nil)")
        func testUserDataViewModel_NilFirstName() async {
                // Arrange
                let context = createInMemoryContext()
                let fakeUser = User(context: context)
                fakeUser.firstName = nil // Le prénom est volontairement nil
                fakeUser.lastName = "Appleseed"
                
                let mockService = MockUserRepository(mockUser: fakeUser)
                let viewModel = UserDataViewModel(service: mockService)
                
                // Act
                await viewModel.fetchUserData()
                
                // Assert
                // Le prénom doit être une chaîne vide, pas nil
                #expect(viewModel.firstName == "")
                #expect(viewModel.lastName == "Appleseed")
        }
        
        @Test("Le ViewModel gère un utilisateur avec un nom de famille nil")
        func testUserDataViewModel_HandlesUserWithNilLastName() async {
                // Arrange
                let context = createInMemoryContext()
                let fakeUser = User(context: context)
                fakeUser.firstName = "Gabriel"
                fakeUser.lastName = nil // <-- Le cas que nous voulons tester
                
                let mockService = MockUserRepository(mockUser: fakeUser)
                let viewModel = UserDataViewModel(service: mockService)
                
                // Act
                await viewModel.fetchUserData()
                
                // Assert
                // On vérifie que le prénom est correct et que le nom est bien une chaîne vide.
                #expect(viewModel.firstName == "Gabriel")
                #expect(viewModel.lastName.isEmpty)
        }
}
