//
//  ExerciseRepositoryProtocol.swift
//  Arista
//
//  Created by Perez William on 12/08/2025.
//

import Foundation

protocol ExerciseRepositoryProtocol {
    func getExercises() async throws -> [Exercise]
    func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) async throws
    func deleteExercise(exercise: Exercise) async throws
}
