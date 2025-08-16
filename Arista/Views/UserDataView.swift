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
                .onAppear {
                        Task {
                                await viewModel.fetchUserData()
                        }
                }
        }
}
