//
//  ExerciseRepository.swift
//  Arista
//
//  Created by Perez William on 29/07/2025.
//

import Foundation
import CoreData

struct ExerciseRepository {
        // Le "bureau de travail" de CoreData
        let viewContext: NSManagedObjectContext
        
        // L'initialiseur permet de recevoir le contexte depuis l'extérieur
        init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
                self.viewContext = viewContext
        }
        
        /// Récupère tous les exercices, triés par date (le plus récent en premier).
        func getExercises() throws -> [Exercise] {
                let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Exercise.startDate, ascending: false)]
                return try viewContext.fetch(request)
        }
        
        /// Crée et sauvegarde un nouvel exercice.
        func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) throws {
                // Crée un nouvel objet Exercise sur notre "brouillon"
                let newExercise = Exercise(context: viewContext)
                
                // Assigne les valeurs reçues aux attributs de l'objet
                newExercise.category = category
                newExercise.duration = Int64(duration) /// CoreData utilise Int64 pour les entiers
                newExercise.intensity = Int64(intensity)
                newExercise.startDate = startDate
                
                try viewContext.save()
        }
        
        /// Supprime un exercice spécifique.
        func deleteExercise(exercise: Exercise) throws {
                viewContext.delete(exercise)
                
                try viewContext.save()
        }
}
