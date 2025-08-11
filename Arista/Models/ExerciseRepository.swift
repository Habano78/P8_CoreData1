//
//  ExerciseRepository.swift
//  Arista
//
//  Created by Perez William on 29/07/2025.
//

import Foundation
import CoreData

struct ExerciseRepository {
        //MARK: Propriété
        let viewContext: NSManagedObjectContext
        
        //MARK: Init
        init(
                viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
        ) {
                self.viewContext = viewContext
        }
        
        //MARK: Actions
        
        //Recuperer la liste de tous les exercices
        func getExercises() async throws -> [Exercise] {
                let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(
                        keyPath: \Exercise.startDate,
                        ascending: false
                )]
                return try await viewContext.perform {
                        try self.viewContext.fetch(request)
                }
        }
        
        //Ajouter des exercices
        func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) async throws {
                let newExercise = Exercise(context: viewContext)
                newExercise.category = category
                newExercise.duration = Int64(
                        duration
                )
                newExercise.intensity = Int64(intensity)
                newExercise.startDate = startDate
                
                try await viewContext.perform {
                        try self.viewContext.save()
                }
        }
        
        // Supprimer un exercice spécifique.
        func deleteExercise(exercise: Exercise) async throws {
                viewContext.delete(exercise)
                
                try await viewContext.perform {
                        try self.viewContext.save()
                }
        }
}
