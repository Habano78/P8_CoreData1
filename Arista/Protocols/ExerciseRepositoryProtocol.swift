//
//  ExerciseRepositoryProtocol.swift
//  Arista
//
//  Created by Perez William on 12/08/2025.
//

import Foundation

protocol ExerciseRepositoryProtocol {
    /// Récupère tous les exercices, triés par date.
    func getExercises() async throws -> [Exercise]
    
    /// Ajoute un nouvel exercice.
    func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) async throws
    
    /// Supprime un exercice spécifique.
    func deleteExercise(exercise: Exercise) async throws
}
