//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
import SwiftUI

struct AddExerciseView: View {
        
        @Environment(\.dismiss) var dismiss
        
        @StateObject var viewModel: AddExerciseViewModel
        
        var body: some View {
                NavigationStack {
                        Form {
                                Picker("Catégorie", selection: $viewModel.type) {
                                        ForEach(viewModel.types, id: \.self) { type in
                                                Text(type)
                                        }
                                }
                                /// Sélecteur de date et d'heure
                                DatePicker("Date", selection: $viewModel.date)
                                
                                /// Stepper pour ajuster la durée
                                Stepper("Durée : \(Int(viewModel.duration)) minutes", value: $viewModel.duration, in: 5...240, step: 5)
                                
                                /// Slider pour choisir l'intensité
                                VStack(alignment: .leading) {
                                        Text("Intensité : \(Int(viewModel.intensity))")
                                        Slider(value: $viewModel.intensity, in: 0...10, step: 1)
                                }
                        }
                        .navigationTitle("Nouvel Exercice")
                        /// Boutons dans la barre de navigation pour annuler ou sauvegarder
                        .navigationBarItems(
                                leading: Button("Annuler") {
                                        dismiss()
                                },
                                trailing: Button("Sauvegarder") {
                                        Task {
                                                if await viewModel.addExercise() {
                                                        /// Si c'est un succès, on ferme la vue
                                                        dismiss()
                                                }
                                        }
                                }
                        )
                }
        }
}
