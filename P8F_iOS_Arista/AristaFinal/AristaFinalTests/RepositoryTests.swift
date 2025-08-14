//
//  RepositoryTests.swift
//  AristaTests
//
//  Created by Perez William on 03/08/2025.
//
import Testing
import CoreData
@testable import AristaFinal

struct RepositoryTests {
        
        // MARK: - Properties
        
        // Ces variables seront réinitialisées pour chaque test.
        var persistenceController: PersistenceController
        var viewContext: NSManagedObjectContext
        var repository: ExerciseRepository
        
        // MARK: - Setup
        
        // L'initialiseur de la struct est appelé avant chaque exécution de @Test
        init() {
                // On crée une base de données fraîche et en mémoire
                let persistenceController = PersistenceController(inMemory: true)
                self.persistenceController = persistenceController
                self.viewContext = persistenceController.container.viewContext
                self.repository = ExerciseRepository(viewContext: self.viewContext)
        }
        
        // MARK: - Tests
        
        @Test("Le Repository peut ajouter et récupérer un exercice")
        func testAddAndFetchExercise() async throws {
                // Arrange
                let category = "Running"
                let date = Date()
                
                // Act
                try await repository.addExercise(category: category, duration: 30, intensity: 5, startDate: date)
                let exercises = try await repository.getExercises()
                
                // Assert
                #expect(exercises.count == 1)
                #expect(exercises.first?.category == category)
        }
        
        @Test("Le Repository peut supprimer un exercice")
        func testDeleteExercise() async throws {
                // Arrange
                try await repository.addExercise(category: "Test", duration: 10, intensity: 1, startDate: Date())
                guard let exerciseToDelete = try await repository.getExercises().first else {
                        Issue.record("Failed to fetch exercise to delete")
                        return
                }
                
                // Act
                try await repository.deleteExercise(exercise: exerciseToDelete)
                
                // Assert
                let exercisesAfterDelete = try await repository.getExercises()
                #expect(exercisesAfterDelete.isEmpty)
        }
}
