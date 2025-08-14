//
//  Untitled.swift
//  Arista
//
//  Created by Perez William on 13/08/2025.
//
import Foundation
@testable import AristaFinal

// MARK: Erreur factice 
enum DummyError: Error {
        case testError
}

// MARK: - Mock pour UserRepository
struct MockUserRepository: UserRepositoryProtocol {
        var shouldFail = false
        var mockUser: User?
        
        func getUser() async throws -> User? {
                if shouldFail { throw DummyError.testError }
                return mockUser
        }
}

// MARK: - Mock pour SleepRepository
struct MockSleepRepository: SleepRepositoryProtocol {
        var shouldFail = false
        var mockSleepSessions: [Sleep] = []
        
        func getSleepSessions() async throws -> [Sleep] {
                if shouldFail { throw DummyError.testError }
                return mockSleepSessions
        }
}

// MARK: - Mock pour ExerciseRepository
class MockExerciseRepository: ExerciseRepositoryProtocol {
        
        var shouldFail = false
        var addExerciseCallCount = 0
        var deleteExerciseCallCount = 0
        
        var exercises: [Exercise] = [] /// pour stocker les exercices factices
        
        
        func getExercises() async throws -> [Exercise] {
                if shouldFail { throw DummyError.testError }
                return exercises // Retourne la propriété "exercises" que le test a préparée
        }
        
        func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) async throws {
                if shouldFail { throw DummyError.testError }
                addExerciseCallCount += 1
        }
        
        func deleteExercise(exercise: Exercise) async throws {
                if shouldFail { throw DummyError.testError }
                deleteExerciseCallCount += 1
        }
}
