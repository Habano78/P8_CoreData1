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
    
    // Des flags plus spécifiques selon la func
    var shouldFailGetExercises = false
    var shouldFailAddExercise = false
    var shouldFailDeleteExercise = false
    
    var addExerciseCallCount = 0
    var deleteExerciseCallCount = 0
    var exercises: [Exercise] = []
    
    func getExercises() async throws -> [Exercise] {
        if shouldFailGetExercises { throw DummyError.testError }
        return exercises
    }
    
    func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) async throws {
        if shouldFailAddExercise { throw DummyError.testError }
        addExerciseCallCount += 1
    }
    
    func deleteExercise(exercise: Exercise) async throws {
        if shouldFailDeleteExercise { throw DummyError.testError }
        deleteExerciseCallCount += 1
    }
}
