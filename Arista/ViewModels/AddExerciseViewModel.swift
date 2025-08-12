//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

@MainActor
class AddExerciseViewModel: ObservableObject {
        
        //MARK: Properties
        @Published var type: String = "Running"
        @Published var date: Date = Date()
        @Published var duration: Double = 30.0
        @Published var intensity: Double = 5.0
        
        let types = ["Running", "Natation", "Football", "Marche", "Cyclisme"]
        
        private let exerciseRepository: ExerciseRepositoryProtocol
        
        //MARK: Init
        init(context: NSManagedObjectContext, service: ExerciseRepositoryProtocol? = nil) {
                self.exerciseRepository = service ?? ExerciseRepository(viewContext: context)
        }
        
        //MARK: Actions
        func addExercise() async -> Bool {
                do {
                        try await exerciseRepository.addExercise(
                                category: self.type,
                                duration: Int(self.duration),
                                intensity: Int(self.intensity),
                                startDate: self.date
                        )
                        return true
                } catch {
                        print("Failed to add exercise: \(error)")
                        return false
                }
        }
}
