import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("Haute Vision")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // Conditions Section
                    VStack(spacing: 15) {
                        Text("Eye Conditions")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        NavigationLink(destination: CornealHealthView()) {
                            ContainerView(
                                title: "Corneal Health",
                                systemImage: "eye.circle.fill"
                            )
                        }
                        
                        NavigationLink(destination: GlaucomaView()) {
                            ContainerView(
                                title: "Glaucoma",
                                systemImage: "eye.fill"
                            )
                        }
                        
                        NavigationLink(destination: RetinalInjectionsView()) {
                            ContainerView(
                                title: "Retinal Injections",
                                systemImage: "cross.case.fill"
                            )
                        }
                    }
                    .padding(.vertical)
                    
                    // About Us Section
                    VStack(spacing: 15) {
                        Text("About Us")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        NavigationLink(destination: Text("About Us Content")) {
                            ContainerView(
                                title: "About Us",
                                systemImage: "info.circle.fill"
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color(.systemGray6))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 
