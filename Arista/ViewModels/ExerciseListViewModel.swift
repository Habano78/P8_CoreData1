//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
import Foundation
import CoreData

@MainActor
class ExerciseListViewModel: ObservableObject {
        
        // MARK: Propriétés
        @Published var exercises = [Exercise]()
        var viewContext: NSManagedObjectContext
        private let exerciseRepository: ExerciseRepository
        
        // MARK: Init
        init(context: NSManagedObjectContext) {
                self.viewContext = context
                self.exerciseRepository = ExerciseRepository(viewContext: context)
        }
        
        // MARK: Actions
        
        /// Récupère la liste des exercices depuis le repository de manière asynchrone.
        func fetchExercises() async {
                do {
                        self.exercises = try await exerciseRepository.getExercises()
                } catch {
                        print("Failed to fetch exercises: \(error)")
                }
        }
        
        /// Demande au repository de supprimer un exercice de manière asynchrone.
        func deleteExercise(exercise: Exercise) async {
                do {
                        try await exerciseRepository.deleteExercise(exercise: exercise)
                        /// Après la suppression, on rafraîchit la liste pour mettre à jour l'UI.
                        await fetchExercises()
                } catch {
                        print("Failed to delete exercise: \(error)")
                }
        }
}
