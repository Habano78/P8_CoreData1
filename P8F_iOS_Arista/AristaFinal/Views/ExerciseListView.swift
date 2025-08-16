import SwiftUI

struct ExerciseListView: View {
        // Le ViewModel est maintenant injecté, donc @ObservedObject est correct
        @ObservedObject var viewModel: ExerciseListViewModel
        
        // Une variable d'état pour contrôler l'affichage de la feuille d'ajout
        @State private var showingAddExerciseView = false
        
        var body: some View {
                NavigationStack {
                        List {
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
                                .onDelete(perform: deleteItems)
                        }
                        .navigationTitle("Exercices")
                        .navigationBarItems(trailing: Button(action: {
                                showingAddExerciseView = true
                        }) {
                                Image(systemName: "plus")
                        })
                        // CORRIGÉ : C'est ici que se trouvaient les erreurs.
                        // On crée le AddExerciseViewModel en lui passant un nouveau repository.
                        .sheet(isPresented: $showingAddExerciseView) {
                                AddExerciseView(
                                        viewModel: AddExerciseViewModel(service: ExerciseRepository())
                                )
                        }
                        // On s'assure que l'appel async est dans un Task
                        .onAppear {
                                Task {
                                        await viewModel.fetchExercises()
                                }
                        }
                        // Optionnel : un .onChange pour rafraîchir la liste après un ajout.
                        .onChange(of: showingAddExerciseView) { oldState, newState in
                                // Si la vue n'est plus présentée (on vient de la fermer)
                                if !newState {
                                        Task {
                                                await viewModel.fetchExercises()
                                        }
                                }
                        }
                }
        }
        
        private func deleteItems(offsets: IndexSet) {
                // On s'assure que l'appel async est dans un Task
                Task {
                        await viewModel.delete(at: offsets)
                }
        }
        
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

// MARK: - Vue auxiliaire

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
