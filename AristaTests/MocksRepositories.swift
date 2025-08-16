//
//  Test.swift
//  AristaTests
//
//  Created by Perez William on 14/08/2025.
//

import Foundation
@testable import Arista

// MARK: - Erreur factice pour les tests

enum DummyError: Error {
        case testError
}

// MARK: - Mock pour UserRepository

class MockUserRepository: UserRepositoryProtocol {
        var shouldFail: Bool
        var mockUser: User?
        
        // On ajoute un init pour configurer le mock
        init(shouldFail: Bool = false, mockUser: User? = nil) {
                self.shouldFail = shouldFail
                self.mockUser = mockUser
        }
        
        func getUser() async throws -> User? {
                if shouldFail { throw DummyError.testError }
                return mockUser
        }
}

// MARK: - Mock pour SleepRepository

class MockSleepRepository: SleepRepositoryProtocol {
        var shouldFail: Bool
        var mockSleepSessions: [Sleep]
        
        // On ajoute un init pour configurer le mock
        init(shouldFail: Bool = false, mockSleepSessions: [Sleep] = []) {
                self.shouldFail = shouldFail
                self.mockSleepSessions = mockSleepSessions
        }
        
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
