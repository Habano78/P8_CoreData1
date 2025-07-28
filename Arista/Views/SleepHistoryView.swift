//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct SleepHistoryView: View {
        @ObservedObject var viewModel: SleepHistoryViewModel
        
        var body: some View {
                // Utilisation de NavigationStack comme bonne pratique
                NavigationStack {
                        List(viewModel.sleepSessions) { session in
                                HStack {
                                        Image(systemName: "moon.zzz.fill")
                                                .foregroundColor(.blue)
                                                .font(.title)
                                                .padding()
                                        VStack(alignment: .leading) {
                                                // Utilise les nouvelles propriétés de notre objet CoreData
                                                Text("Début : \(session.heureDebut ?? Date(), formatter: itemFormatter)")
                                                Text("Fin : \(session.heureFin ?? Date(), formatter: itemFormatter)")
                                                
                                                // Calcule et affiche la durée
                                                if let start = session.heureDebut, let end = session.heureFin {
                                                        let durationInHours = (end.timeIntervalSince(start) / 3600)
                                                        Text(String(format: "Durée : %.1f heures", durationInHours))
                                                }
                                        }
                                }
                        }
                        .navigationTitle("Historique de Sommeil")
                }
        }
}

// Ajout d'un DateFormatter to ensure the dates and times are displayed in a clean, human-readable format.
private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
}()


#Preview {
        SleepHistoryView(viewModel: SleepHistoryViewModel(context: PersistenceController.preview.container.viewContext))
}
