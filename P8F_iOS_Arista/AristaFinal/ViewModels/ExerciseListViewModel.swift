import Foundation
import CoreData
import SwiftUI

@MainActor
class ExerciseListViewModel: ObservableObject {
        
        //MARK: Properties
        @Published var exercises = [Exercise]()
        private let exerciseRepository: ExerciseRepositoryProtocol
        
        //MARK: Init
        init(service: ExerciseRepositoryProtocol)
        {
                self.exerciseRepository = service
        }
        
        func fetchExercises() async {
                do {
                        self.exercises = try await exerciseRepository.getExercises()
                } catch {
                        print("Failed to fetch exercises: \(error)")
                }
        }
        
        func delete(at offsets: IndexSet) async {
                let exercisesToDelete: [Exercise] = offsets.compactMap { index in
                        guard index >= 0 && index < exercises.count else { return nil }
                        return exercises[index]
                }
                
                guard !exercisesToDelete.isEmpty else { return }
                
                withAnimation {
                        exercises.removeAll { exercisesToDelete.contains($0) }
                }
                
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
