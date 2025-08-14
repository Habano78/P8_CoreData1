//
//  RepositoryTests.swift
//  AristaTests
//
//  Created by Perez William on 14/08/2025.
//

//
//  RepositoryTests.swift
//  AristaTests
//
//  Created by Perez William on 14/08/2025.
//

import Testing
import CoreData
@testable import Arista


@MainActor
struct RepositoryTests {
        
        /// Crée un contexte Core Data en mémoire, isolé pour chaque test
        func makeTestContext() -> NSManagedObjectContext {
                // Bundle des tests
                let testBundle = Bundle(for: TestBundleClass.self)
                let persistence = PersistenceController(inMemory: true, bundle: testBundle)
                return persistence.container.viewContext
        }
        
        @Test("Le Repository peut ajouter et récupérer un exercice")
        func testAddAndFetchExercise() async throws {
                // Arrange
                let context = makeTestContext()
                let repository = ExerciseRepository(viewContext: context)
                let category = "Running"
                
                // Act
                try await repository.addExercise(category: category, duration: 30, intensity: 5, startDate: Date())
                let exercises = try await repository.getExercises()
                
                // Assert
                #expect(exercises.count == 1)
                #expect(exercises.first?.category == category)
        }
        
        @Test("Le Repository peut supprimer un exercice")
        func testDeleteExercise() async throws {
                // Arrange
                let context = makeTestContext()
                let repository = ExerciseRepository(viewContext: context)
                try await repository.addExercise(category: "Test", duration: 10, intensity: 1, startDate: Date())
                
                guard let exerciseToDelete = try await repository.getExercises().first else {
                        Issue.record("Échec de la récupération de l'exercice à supprimer")
                        return
                }
                
                // Act
                try await repository.deleteExercise(exercise: exerciseToDelete)
                
                // Assert
                let exercisesAfterDelete = try await repository.getExercises()
                #expect(exercisesAfterDelete.isEmpty)
        }
        
        @Test("Le Repository gère un échec lors de l'ajout")
        func testAddExerciseFails() async throws {
                // Arrange
                let context = makeTestContext()
                let mockRepo = MockExerciseRepository(shouldFail: true)
                let viewModel = ExerciseListViewModel(context: context, service: mockRepo)
                
                // Act
                await viewModel.fetchExercises() // simule fetch
                await viewModel.delete(at: IndexSet(integer: 0)) // simule delete
                
                // Assert
                #expect(mockRepo.addExerciseCallCount == 0) // Rien n'a été ajouté
        }
}
