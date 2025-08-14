//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//
import SwiftUI

struct SleepHistoryView: View {
        //MARK: Propriétés
        @ObservedObject var viewModel: SleepHistoryViewModel
        
        //MARK: Body
        var body: some View {
                NavigationStack {
                        List(viewModel.sleepSessions) { session in
                                HStack {
                                        /// Affiche l'indicateur de qualité du sommeil.
                                        QualityIndicator(quality: Int(session.quality))
                                                .padding()
                                        
                                        VStack(alignment: .leading) {
                                                Text("Début : \(session.startDate?.formatted() ?? "Date inconnue")")
                                                Text("Durée : \(session.duration / 60) heures")
                                        }
                                }
                        }
                        .navigationTitle("Historique de Sommeil")
                        .onAppear {
                                Task {
                                        await viewModel.fetchSleepSessions()
                                }
                        }
                }
        }
}

// MARK: Vue auxiliaire
/// Un cercle de couleur pour afficher la qualité du sommeil.
struct QualityIndicator: View {
        let quality: Int
        
        var body: some View {
                ZStack {
                        Circle()
                                .stroke(qualityColor(quality), lineWidth: 5)
                                .frame(width: 30, height: 30)
                        Text("\(quality)")
                                .foregroundColor(qualityColor(quality))
                }
        }
        
        /// Retourne une couleur en fonction de la note de qualité.
        private func qualityColor(_ quality: Int) -> Color {
                switch quality {
                case 8...10:
                        return .green
                case 4...7:
                        return .yellow
                default:
                        return .red
                }
        }
}
