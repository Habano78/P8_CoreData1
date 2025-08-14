//
//  ViewModelTests.swift
//  AristaTests
//
//  Created by Perez William on 14/08/2025.
//
//
import Testing
import CoreData
@testable import Arista


@MainActor
struct ViewModelTests {
        
        func makeTestContext() -> NSManagedObjectContext {
                return PersistenceController(
                        inMemory: true,
                        bundle: Bundle(for: TestBundleClass.self)
                ).viewContext
        }
        
        //MARK: tests UserDataViewModel
        @Test("UserDataViewModel récupère l'utilisateur")
        func testUserDataViewModel_FetchesUser_Succeeds() async {
                let context = makeTestContext()
                let fakeUser = User(context: context)
                fakeUser.firstName = "John"
                fakeUser.lastName = "Appleseed"
                
                let mockService = MockUserRepository(mockUser: fakeUser)
                let viewModel = UserDataViewModel(service: mockService)
                await viewModel.fetchUserData()
                
                #expect(viewModel.firstName == "John")
                #expect(viewModel.lastName == "Appleseed")
        }
        
        @Test("UserDataViewModel gère une erreur lors de la récupération")
        func testUserDataViewModel_FetchesUser_Fails() async {
                let mockService = MockUserRepository(shouldFail: true)
                let viewModel = UserDataViewModel(service: mockService)
                
                await viewModel.fetchUserData()
                
                #expect(viewModel.firstName.isEmpty)
                #expect(viewModel.lastName.isEmpty)
        }
        
        // MARK: SleepHistoryViewModel Tests
        
        @Test("SleepHistoryViewModel récupère bien les sessions de sommeil")
        func testSleepHistoryViewModel_FetchesSleep_Succeeds() async {
                let context = makeTestContext()
                let fakeSleep = Sleep(context: context)
                fakeSleep.duration = 480
                
                let mockService = MockSleepRepository(mockSleepSessions: [fakeSleep])
                let viewModel = SleepHistoryViewModel(service: mockService)
                
                await viewModel.fetchSleepSessions()
                
                #expect(viewModel.sleepSessions.count == 1)
                #expect(viewModel.sleepSessions.first?.duration == 480)
        }
        
        @Test("SleepHistoryViewModel gère un échec de récupération")
        func testSleepHistoryViewModel_FetchesSleep_Fails() async {
                let mockService = MockSleepRepository(shouldFail: true)
                let viewModel = SleepHistoryViewModel(service: mockService)
                
                await viewModel.fetchSleepSessions()
                
                #expect(viewModel.sleepSessions.isEmpty)
        }
        // MARK: - ExerciseListViewModel Tests
        
        @Test("ExerciseListViewModel récupère bien les exercices")
        func testExerciseListViewModel_FetchesExercises_Succeeds() async {
                let context = makeTestContext()
                let fakeExercise = Exercise(context: context)
                fakeExercise.category = "Running"
                
                let mockService = MockExerciseRepository(exercises: [fakeExercise])
                let viewModel = ExerciseListViewModel(context: context, service: mockService)
                
                await viewModel.fetchExercises()
                
                #expect(viewModel.exercises.count == 1)
                #expect(viewModel.exercises.first?.category == "Running")
        }
        
        @Test("ExerciseListViewModel gère un échec lors de la récupération")
        func testExerciseListViewModel_FetchesExercises_Fails() async {
                let mockService = MockExerciseRepository(shouldFail: true)
                let context = makeTestContext()
                let viewModel = ExerciseListViewModel(context: context, service: mockService)
                
                await viewModel.fetchExercises()
                
                #expect(viewModel.exercises.isEmpty)
        }
        
        @Test("ExerciseListViewModel supprime un exercice avec succès")
        func testExerciseListViewModel_Delete_Succeeds() async {
                let context = makeTestContext()
                let fakeExercise = Exercise(context: context)
                let mockService = MockExerciseRepository()
                let viewModel = ExerciseListViewModel(context: context, service: mockService)
                viewModel.exercises = [fakeExercise]
                
                await viewModel.delete(at: IndexSet(integer: 0))
                
                #expect(viewModel.exercises.isEmpty)
                #expect(mockService.deleteExerciseCallCount == 1)
        }
        
        @Test("ExerciseListViewModel gère un échec lors de la suppression")
        func testExerciseListViewModel_Delete_Fails() async {
                let context = makeTestContext()
                let fakeExercise = Exercise(context: context)
                let mockService = MockExerciseRepository(shouldFail: true)
                let viewModel = ExerciseListViewModel(context: context, service: mockService)
                viewModel.exercises = [fakeExercise]
                
                await viewModel.delete(at: IndexSet(integer: 0))
                
                // Après échec, fetchExercises est ré-appelé => on s’attend à ce que exercises reste vide
                #expect(viewModel.exercises.isEmpty)
        }
        
        // MARK: - AddExerciseViewModel Tests
        
        @Test("AddExerciseViewModel ajoute un exercice avec succès")
        func testAddExerciseViewModel_Succeeds() async {
                let context = makeTestContext()
                let mockService = MockExerciseRepository()
                let viewModel = AddExerciseViewModel(context: context, service: mockService)
                
                let success = await viewModel.addExercise()
                
                #expect(success == true)
                #expect(mockService.addExerciseCallCount == 1)
        }
        
        @Test("AddExerciseViewModel gère un échec d'ajout")
        func testAddExerciseViewModel_Fails() async {
                let context = makeTestContext()
                let mockService = MockExerciseRepository(shouldFail: true)
                let viewModel = AddExerciseViewModel(context: context, service: mockService)
                
                let success = await viewModel.addExercise()
                
                #expect(success == false)
        }
        
}
