//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
import Foundation
import CoreData
import SwiftUI

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
        // Dans ExerciseListViewModel.swift
        
        func delete(at offsets: IndexSet) {
                // 1. On identifie les objets à supprimer
                let exercisesToDelete = offsets.map { self.exercises[$0] }
                
                // 2. On lance l'animation en supprimant les objets de la liste publiée
                withAnimation {
                        exercises.remove(atOffsets: offsets)
                }
                
                // 3. On lance une tâche de fond pour supprimer définitivement de CoreData
                Task {
                        for exercise in exercisesToDelete {
                                do {
                                        try await exerciseRepository.deleteExercise(exercise: exercise)
                                } catch {
                                        print("Failed to delete exercise from repository: \(error)")
                                        // En cas d'échec, on pourrait recharger les données pour garder la cohérence
                                        await fetchExercises()
                                }
                        }
                }
        }
}
