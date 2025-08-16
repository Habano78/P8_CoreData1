//
//  ExerciseListViewModelTests.swift
//  AristaTests
//
//  Created by Perez William on 12/08/2025.
//

import Testing
import CoreData
@testable import Arista

@MainActor
struct ExerciseViewModelTests {
        
        /// Contexte CoreData en mémoire pour créer des objets factices.
        func createInMemoryContext() -> NSManagedObjectContext {
                return PersistenceController(inMemory: true).container.viewContext
        }
        
        // MARK: - Tests pour fetchExercises
        
        @Test("Le ExerciseListViewModel récupère bien les exercices")
        func testExerciseListViewModel_FetchesExercises_Succeeds() async {
                // Arrange
                let context = createInMemoryContext()
                let fakeExercise = Exercise(context: context)
                fakeExercise.category = "Running"
                
                let mockService = MockExerciseRepository()
                mockService.exercises = [fakeExercise]
                
                let viewModel = ExerciseListViewModel(service: mockService)
                
                // Act
                await viewModel.fetchExercises()
                
                // Assert
                #expect(viewModel.exercises.count == 1)
                #expect(viewModel.exercises.first?.category == "Running")
        }
        
        @Test("Le ExerciseListViewModel gère un échec lors du fetch")
        func testExerciseListViewModel_FetchesExercises_Fails() async {
                // Arrange
                let mockService = MockExerciseRepository()
                mockService.shouldFailGetExercises = true /// On simule une erreur
                let viewModel = ExerciseListViewModel(service: mockService)
                
                // Act
                await viewModel.fetchExercises()
                
                // Assert
                #expect(viewModel.exercises.isEmpty)
        }
        
        // MARK: TESTS POUR LA FONCTION DELETE
        
        @Test("Le ExerciseListViewModel supprime un exercice avec succès")
        func testExerciseListViewModel_Delete_Succeeds() async {
                // Arrange
                let context = createInMemoryContext()
                let fakeExercise = Exercise(context: context)
                
                let mockService = MockExerciseRepository()
                let viewModel = ExerciseListViewModel(service: mockService)
                viewModel.exercises = [fakeExercise] // On peuple la liste manuellement
                
                // Act
                await viewModel.delete(at: IndexSet(integer: 0))
                
                // Assert
                #expect(viewModel.exercises.isEmpty) // La liste locale doit être vide
                #expect(mockService.deleteExerciseCallCount == 1) // Le repository doit avoir été appelé
        }
        
        @Test("Le ExerciseListViewModel gère un échec lors de la suppression")
        func testExerciseListViewModel_Delete_Fails() async {
                // Arrange
                let context = createInMemoryContext()
                let fakeExercise = Exercise(context: context)
                
                let mockService = MockExerciseRepository()
                
                // CORRIGÉ : On spécifie que SEULE la suppression doit échouer
                mockService.shouldFailDeleteExercise = true
                
                // Le mock doit toujours pouvoir retourner la liste si fetch est rappelé
                mockService.exercises = [fakeExercise]
                
                let viewModel = ExerciseListViewModel(service: mockService)
                viewModel.exercises = [fakeExercise]
                
                // Act
                await viewModel.delete(at: IndexSet(integer: 0))
                
                // Assert
                // Maintenant, le fetch va réussir et restaurer la liste.
                #expect(viewModel.exercises.count == 1)
        }
        
        // MARK: - Tests pour AddExerciseViewModel (inchangés)
        
        @Test("Le AddExerciseViewModel ajoute un exercice avec succès")
        func testAddExerciseViewModel_Succeeds() async {
                let mockService = MockExerciseRepository()
                let viewModel = AddExerciseViewModel(service: mockService)
                let success = await viewModel.addExercise()
                #expect(success == true)
                #expect(mockService.addExerciseCallCount == 1)
        }
        
        @Test("Le AddExerciseViewModel gère un échec d'ajout")
        func testAddExerciseViewModel_Fails() async {
                let mockService = MockExerciseRepository()
                mockService.shouldFailAddExercise = true
                let viewModel = AddExerciseViewModel(service: mockService)
                let success = await viewModel.addExercise()
                #expect(success == false)
        }
}
