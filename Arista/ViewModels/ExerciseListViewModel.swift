//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class ExerciseListViewModel: ObservableObject {
        /// Publie la liste des exercices à la vue.
        @Published var exercises = [Exercise]()
        
        /// contexte CoreData, nécessaire pour passer à la vue d'ajout.
        var viewContext: NSManagedObjectContext
        
        /// repository qui gère les opérations sur les exercices.
        private let exerciseRepository: ExerciseRepository
        
        // MARK: - Init
        init(context: NSManagedObjectContext) {
                self.viewContext = context
                self.exerciseRepository = ExerciseRepository(viewContext: context)
                fetchExercises()
        }
        // MARK: - Methods
        
        /// Récupère la liste des exercices depuis le repository.
        func fetchExercises() {
                do {
                        exercises = try exerciseRepository.getExercises()
                } catch {
                        print("Failed to fetch exercises: \(error)")
                }
        }
        
        /// Demande au repository de supprimer un exercice.
        func deleteExercise(exercise: Exercise) {
                do {
                        try exerciseRepository.deleteExercise(exercise: exercise)
                        // Après la suppression, on rafraîchit la liste
                        fetchExercises()
                } catch {
                        print("Failed to delete exercise: \(error)")
                }
        }
}
