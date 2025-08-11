//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct UserDataView: View {
        @ObservedObject var viewModel: UserDataViewModel
        
        var body: some View {
                VStack(alignment: .leading) {
                        Spacer()
                        Text("Hello")
                                .font(.largeTitle)
                        Text("\(viewModel.firstName) \(viewModel.lastName)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding()
                                .scaleEffect(1.2)
                        Spacer()
                }
                .edgesIgnoringSafeArea(.all)
                // Ce modificateur est appelé une seule fois, lorsque la vue apparaît à l'écran.
                .onAppear {
                        // On crée une "Task" pour exécuter du code asynchrone.
                        Task {
                                // On "attend" que la fonction asynchrone du ViewModel soit terminée.
                                await viewModel.fetchUserData()
                        }
                }
        }
}

#Preview {
        UserDataView(viewModel: UserDataViewModel(context: PersistenceController.preview.container.viewContext))
}
