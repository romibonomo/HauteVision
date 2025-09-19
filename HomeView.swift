import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey.welcomeToHauteVision.localized())
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            if let user = viewModel.currentUser {
                Text("\(LocalizedStringKey.hello.localized()) \(user.name)!")
                    .font(.headline)
                    .padding()
            }
            
            Spacer()
            
            Button(action: {
                try? viewModel.signOut()
            }) {
                Text(LocalizedStringKey.signOut.localized())
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 200)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.bottom, 50)
        }
        .navigationTitle(LocalizedStringKey.home.localized())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
            .environmentObject(LocalizationManager.shared)
    }
} 
