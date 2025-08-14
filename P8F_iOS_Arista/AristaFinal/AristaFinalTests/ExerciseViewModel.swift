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
struct ExerciseViewModelTests {
        
        /// Contexte CoreData en mémoire pour créer des objets factices.
        func createInMemoryContext() -> NSManagedObjectContext {
                return PersistenceController(inMemory: true).container.viewContext
        }
        
        
        @Test("Le ExerciseListViewModel récupère bien les exercices")
        func testExerciseListViewModel_FetchesExercises_Succeeds() async {
                // Arrange
                let context = createInMemoryContext()
                let fakeExercise = Exercise(context: context)
                fakeExercise.category = "Running"
                
                let mockService = MockExerciseRepository()
                mockService.exercises = [fakeExercise]
                
                let viewModel = ExerciseListViewModel(context: context, service: mockService)
                
                // Act
                await viewModel.fetchExercises()
                
                // Assert
                #expect(viewModel.exercises.count == 1)
                #expect(viewModel.exercises.first?.category == "Running")
        }
        
        // MARK: - AddExerciseViewModel Tests
        
        @Test("Le AddExerciseViewModel ajoute un exercice avec succès")
        func testAddExerciseViewModel_Succeeds() async {
                // Arrange
                let mockService = MockExerciseRepository()
                let viewModel = AddExerciseViewModel(context: createInMemoryContext(), service: mockService)
                
                // Act
                let success = await viewModel.addExercise()
                
                // Assert
                #expect(success == true)
                #expect(mockService.addExerciseCallCount == 1)
        }
        
        @Test("Le AddExerciseViewModel gère un échec d'ajout")
        func testAddExerciseViewModel_Fails() async {
                // Arrange
                let mockService = MockExerciseRepository()
                mockService.shouldFail = true
                let viewModel = AddExerciseViewModel(context: createInMemoryContext(), service: mockService)
                
                // Act
                let success = await viewModel.addExercise()
                
                // Assert
                #expect(success == false)
        }
}
