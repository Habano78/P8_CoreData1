//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class AddExerciseViewModel: ObservableObject {
        
        //MARK: Properties
        @Published var type: String = "Running"
        @Published var date: Date = Date()
        @Published var duration: Int = 30
        @Published var intensity: Double = 5.0
        
        // Options pour les menus déroulants(picker)
        let types = ["Running", "Natation", "Football", "Marche", "Cyclisme"]
        
        private let exerciseRepository: ExerciseRepository
        
        init(context: NSManagedObjectContext) {
                self.exerciseRepository = ExerciseRepository(viewContext: context)
        }
        
        //MARK: Methodes
        /// Appel au repo pour sauvegarder la saisie de l'utilisateur. Si l'ajout réussit, on retourne true.
        func addExercise() async -> Bool {
                do {
                        // On délègue le travail de création au repository.
                        try await exerciseRepository.addExercise(
                                category: type,
                                duration: duration,
                                intensity: Int(intensity),
                                startDate: date
                        )
                        return true
                } catch {
                        // Si une erreur se produit, on l'affiche et on retourne false.
                        print("Failed to add exercise: \(error)")
                        return false
                }
        }
}
