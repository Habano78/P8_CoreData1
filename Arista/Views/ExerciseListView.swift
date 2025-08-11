//
//  ExerciseListView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct ExerciseListView: View {
        // Le ViewModel contient la logique et les données à afficher
        @ObservedObject var viewModel: ExerciseListViewModel
        // Une variable d'état pour contrôler l'affichage de la feuille d'ajout
        @State private var showingAddExerciseView = false
        
        var body: some View {
                NavigationStack {
                        List {
                                /// La boucle itère sur les vrais objets "Exercise" de CoreData
                                ForEach(viewModel.exercises) { exercise in
                                        HStack {
                                                Image(systemName: iconForCategory(exercise.category))
                                                
                                                VStack(alignment: .leading) {
                        
                                                        Text(exercise.category ?? "N/A")
                                                                .font(.headline)
                                                        Text("Durée: \(exercise.duration) min")
                                                                .font(.subheadline)
                                                        Text(exercise.startDate?.formatted() ?? "Date inconnue")
                                                                .font(.subheadline)
                                                }
                                                
                                                Spacer()
                                                IntensityIndicator(intensity: Int(exercise.intensity))
                                        }
                                }
                                /// Ajoute la fonctionnalité "glisserr pour supprimer"
                                .onDelete(perform: deleteItems)
                        }
                        .navigationTitle("Exercices")
                        /// Barre de navigation avec un bouton "+" pour ajouter un exercice
                        .navigationBarItems(trailing: Button(action: {
                                showingAddExerciseView = true
                        }) {
                                Image(systemName: "plus")
                        })
                        ///feuille qui apparaît pour ajouter un exercice
                        .sheet(isPresented: $showingAddExerciseView) {
                                AddExerciseView(viewModel: AddExerciseViewModel(context: viewModel.viewContext))
                        }
                        /// Charge les données quand la vue apparaît
                        .onAppear {
                                Task {
                                        await viewModel.fetchExercises()
                                }
                        }
                        /// Rafraîchit la liste quand la vue revient au premier plan
                        .onChange(of: showingAddExerciseView) {
                                if !showingAddExerciseView {
                                        Task {
                                                await viewModel.fetchExercises()
                                        }
                                }
                        }
                }
        }
        
        /// Gère la suppression des exercices de manière asynchrone
        private func deleteItems(offsets: IndexSet) {
                withAnimation {
                        Task {
                                for index in offsets {
                                        let exerciseToDelete = viewModel.exercises[index]
                                        await viewModel.deleteExercise(exercise: exerciseToDelete)
                                }
                        }
                }
        }
        
        /// Traduit le nom de la catégorie en un nom d'icône SF Symbols
        private func iconForCategory(_ category: String?) -> String {
                switch category {
                case "Football":
                        return "sportscourt"
                case "Natation":
                        return "waveform.path.ecg"
                case "Running":
                        return "figure.run"
                case "Marche":
                        return "figure.walk"
                case "Cyclisme":
                        return "bicycle"
                default:
                        return "questionmark"
                }
        }
}

// MARK: - Vues auxiliaires

/// Un simple cercle de couleur pour représenter l'intensité
struct IntensityIndicator: View {
        var intensity: Int
        
        var body: some View {
                Circle()
                        .fill(colorForIntensity(intensity))
                        .frame(width: 10, height: 10)
        }
        
        private func colorForIntensity(_ intensity: Int) -> Color {
                switch intensity {
                case 0...3:
                        return .green
                case 4...6:
                        return .yellow
                case 7...10:
                        return .red
                default:
                        return .gray
                }
        }
}
