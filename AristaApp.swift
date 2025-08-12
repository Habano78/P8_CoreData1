//
//  AristaApp.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

@main
struct AristaApp: App {
        let persistenceController = PersistenceController.shared
        
        var body: some Scene {
                WindowGroup {
                        TabView {
                                // initialiseur sans paramètre
                                UserDataView(viewModel: UserDataViewModel())
                                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                        .tabItem {
                                                Label("Utilisateur", systemImage: "person")
                                        }
                                
                                // On passe toujours le contexte ici, car ExerciseListViewModel en a besoin
                                ExerciseListView(viewModel: ExerciseListViewModel(context: persistenceController.container.viewContext))
                                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                        .tabItem {
                                                Label("Exercices", systemImage: "flame")
                                        }
                                
                                // On utilise le nouvel initialiseur sans paramètre
                                SleepHistoryView(viewModel: SleepHistoryViewModel())
                                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                        .tabItem {
                                                Label("Sommeil", systemImage: "moon")
                                        }
                        }
                }
        }
}
