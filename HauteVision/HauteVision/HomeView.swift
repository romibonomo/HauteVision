import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Welcome to HauteVision")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            if let user = viewModel.currentUser {
                Text("Hello, \(user.name)!")
                    .font(.headline)
                    .padding()
                
                if let dateOfBirth = user.dateOfBirth {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    Text("Date of Birth: \(formatter.string(from: dateOfBirth))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.signOut()
            }) {
                Text("Sign Out")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 200)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.bottom, 50)
        }
        .navigationTitle("Home")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
    }
} 