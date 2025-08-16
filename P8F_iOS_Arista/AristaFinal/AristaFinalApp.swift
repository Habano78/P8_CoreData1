import SwiftUI

@main
struct AristaApp: App {
        let persistenceController = PersistenceController.shared
        
        // On prépare nos dépendances ici
        let exerciseRepository: ExerciseRepositoryProtocol
        let userRepository: UserRepositoryProtocol
        let sleepRepository: SleepRepositoryProtocol
        
        init() {
                // On instancie le controller et les repositories une seule fois
                let persistence = PersistenceController.shared
                self.exerciseRepository = ExerciseRepository(persistenceController: persistence)
                self.userRepository = UserRepository(persistenceController: persistence)
                self.sleepRepository = SleepRepository(persistenceController: persistence)
        }
        
        var body: some Scene {
                WindowGroup {
                        TabView {
                                // On injecte les repositories dans les ViewModels
                                UserDataView(viewModel: UserDataViewModel(service: userRepository))
                                        .tabItem { Label("Utilisateur", systemImage: "person") }
                                
                                ExerciseListView(viewModel: ExerciseListViewModel(service: exerciseRepository))
                                        .tabItem { Label("Exercices", systemImage: "flame") }
                                
                                SleepHistoryView(viewModel: SleepHistoryViewModel(service: sleepRepository))
                                        .tabItem { Label("Sommeil", systemImage: "moon") }
                        }
                        // L'environnement reste utile pour les @FetchRequest ou les previews
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
        }
}
