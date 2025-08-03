//
//  RepositoryTests.swift
//  AristaTests
//
//  Created by Perez William on 03/08/2025.
//

import Testing
import CoreData
@testable import Arista

struct RepositoryTests {
        
        /// Base de données temporaire en mémoire pour chaque test.
        func createInMemoryPersistenceController() -> PersistenceController {
                return PersistenceController(inMemory: true)
        }
        
        @Test("Le Repository peut ajouter et récupérer un exercice")
        func testAddAndFetchExercise() throws {
                // Arrange
                let persistenceController = createInMemoryPersistenceController()
                let context = persistenceController.container.viewContext
                let repository = ExerciseRepository(viewContext: context)
                let category = "Running"
                let date = Date()
                
                // Act
                try repository.addExercise(category: category, duration: 30, intensity: 5, startDate: date)
                let exercises = try repository.getExercises()
                
                // Assert
                #expect(exercises.count == 1)
                #expect(exercises.first?.category == category)
        }
        
        @Test("Le Repository peut supprimer un exercice")
        func testDeleteExercise() throws {
                // Arrange
                let persistenceController = createInMemoryPersistenceController()
                let context = persistenceController.container.viewContext
                let repository = ExerciseRepository(viewContext: context)
                try repository.addExercise(category: "Test", duration: 10, intensity: 1, startDate: Date())
                guard let exerciseToDelete = try repository.getExercises().first else {
                        Issue.record("Failed to fetch exercise to delete")
                        return
                }
                
                // Act
                try repository.deleteExercise(exercise: exerciseToDelete)
                
                // Assert
                let exercisesAfterDelete = try repository.getExercises()
                #expect(exercisesAfterDelete.isEmpty)
        }
}
