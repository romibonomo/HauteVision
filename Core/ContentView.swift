//
//  SwiftUIView.swift
//  HauteVision
//
//  Created by romi bonomo on 2025-02-09.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.userSession == nil {
                    LoginView()
                } else {
                    MainTabView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
