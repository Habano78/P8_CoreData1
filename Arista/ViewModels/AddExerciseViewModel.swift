//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

@MainActor
final class AddExerciseViewModel: ObservableObject {
        
        //MARK: Properties
        @Published var type: String = "Running"
        @Published var date: Date = Date()
        @Published var duration: Double = 30.0
        @Published var intensity: Double = 5.0
        
        let types = ["Running", "Natation", "Football", "Marche", "Cyclisme"]
        
        private let exerciseRepository: ExerciseRepositoryProtocol
        
        //MARK: Init
        init(service: ExerciseRepositoryProtocol)
        {
                self.exerciseRepository = service
        }
        
        //MARK: Action
        func addExercise() async -> Bool {
                do {
                        try await exerciseRepository.addExercise(
                                category: type,
                                duration: Int(duration),
                                intensity: Int(intensity),
                                startDate: date
                        )
                        return true
                } catch {
                        print("Failed to add exercise: \(error)")
                        return false
                }
        }
}
