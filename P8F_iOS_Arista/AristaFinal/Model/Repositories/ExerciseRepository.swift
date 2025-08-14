//
//  ExerciseRepository.swift
//  Arista
//
//  Created by Perez William on 29/07/2025.
//
import Foundation
import CoreData
import SwiftUI

//MARK: Contrat
struct ExerciseRepository: ExerciseRepositoryProtocol {
        
        let viewContext: NSManagedObjectContext
        
        init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
                self.viewContext = viewContext
        }
        
        /// Récupère tous les exercices
        func getExercises() async throws -> [Exercise] {
                let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Exercise.startDate, ascending: false)]
                return try await viewContext.perform {
                        try self.viewContext.fetch(request)
                }
        }
        
        /// Ajoute un exercice de manière asynchrone.
        func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) async throws {
                
                try await viewContext.perform { /// la modification et la sauvegarde se font toutes sur le bon thread, en toute sécurité.
                        let newExercise = Exercise(context: self.viewContext)
                        newExercise.category = category
                        newExercise.duration = Int64(duration)
                        newExercise.intensity = Int64(intensity)
                        newExercise.startDate = startDate
                        
                        // La sauvegarde se fait dans le même bloc sécurisé
                        try self.viewContext.save()
                }
        }
        
        /// Supprime un exercice de manière asynchrone.
        func deleteExercise(exercise: Exercise) async throws {
                await viewContext.perform {
                        self.viewContext.delete(exercise)
                }
                try await viewContext.perform {
                        try self.viewContext.save()
                }
        }
}
