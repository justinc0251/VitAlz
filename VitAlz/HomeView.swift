//
//  HomeView.swift
//  VitAlz
//
//  Created by Jonathan Wu on 2/17/24.
//

import SwiftUI
import Combine
import FirebaseAnalytics
import FirebaseAnalyticsSwift


struct HomeView: View {
    @StateObject var viewModel = AuthenticationViewModel()
    var body: some View {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            // Ur highest score
            // Reminders you have this to do at 8 pm
            Text(greeting())
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            
            WelcomeView()
                .tabItem{
                    Label("List", systemImage: "square.and.pencil")
                }

            ResourceView()
                .tabItem{
                    Label("Resources", systemImage: "doc.richtext")
                }
            GameView()
                .tabItem{
                    Label("Game", systemImage: "gamecontroller")
                }
            UserProfileView().environmentObject(viewModel)
                .tabItem{
                    Label("Account", systemImage: "person")
                }
        }.onAppear {
            Task {
                await viewModel.fetchUserData()
            }
        }
    }
    private func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour >= 0 && hour < 12 {
            return "Good morning, \(viewModel.fullName)!"
        } else if hour >= 12 && hour < 18 {
            return "Good afternoon, \(viewModel.fullName)!"
        } else {
            return "Good evening, \(viewModel.fullName)!"
        }
    }

    
}



struct VitAlzView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HomeView()
    }
  }
}
