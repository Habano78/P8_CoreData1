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
        
        //MARK: Properties
        @Published var exercises = [Exercise]()
        var viewContext: NSManagedObjectContext
        private let exerciseRepository: ExerciseRepositoryProtocol
        
        //MARK: Init
        init(context: NSManagedObjectContext, service: ExerciseRepositoryProtocol? = nil) {
                self.viewContext = context
                self.exerciseRepository = service ?? ExerciseRepository(viewContext: context)
        }
        
        //MARK: Actions
        
        func fetchExercises() async {
                do {
                        self.exercises = try await exerciseRepository.getExercises()
                } catch {
                        print("Failed to fetch exercises: \(error)")
                }
        }
        
        func delete(at offsets: IndexSet) {
                let exercisesToDelete = offsets.map { self.exercises[$0] }
                
                withAnimation {
                        exercises.remove(atOffsets: offsets)
                }
                
                Task {
                        for exercise in exercisesToDelete {
                                do {
                                        try await exerciseRepository.deleteExercise(exercise: exercise)
                                } catch {
                                        print("Failed to delete exercise: \(error)")
                                        await fetchExercises()
                                }
                        }
                }
        }
}
