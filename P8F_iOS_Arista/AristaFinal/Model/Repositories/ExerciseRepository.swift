import Foundation
import CoreData
import SwiftUI

struct ExerciseRepository: ExerciseRepositoryProtocol {
        
        private let persistenceController: PersistenceController
        private var viewContext: NSManagedObjectContext { persistenceController.viewContext }
        
        init(persistenceController: PersistenceController = .shared) {
                self.persistenceController = persistenceController
        }
        
        /// Récupère tous les exercices
        func getExercises() async throws -> [Exercise] {
                let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Exercise.startDate, ascending: false)]
                return try await viewContext.perform {
                        try self.viewContext.fetch(request)
                }
        }
        
        /// Ajoute un exercice sur un thread d'arrière-plan.
        func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) async throws {
                try await persistenceController.performBackgroundTask { context in
                        let newExercise = Exercise(context: context)
                        newExercise.category = category
                        newExercise.duration = Int64(duration)
                        newExercise.intensity = Int64(intensity)
                        newExercise.startDate = startDate
                }
        }
        
        /// Supprime un exercice sur un thread d'arrière-plan.
        func deleteExercise(exercise: Exercise) async throws {
                try await persistenceController.performBackgroundTask { context in
                        if let exerciseToDelete = context.object(with: exercise.objectID) as? Exercise {
                                context.delete(exerciseToDelete)
                        }
                }
        }
}
