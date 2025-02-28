import SwiftUI

struct GlaucomaView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Image
                Image("glaucoma_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.top)
                
                // Content Containers
                VStack(spacing: 15) {
                    NavigationLink(destination: Text("Glaucoma Information")) {
                        ContainerView(
                            title: "What is Glaucoma?",
                            systemImage: "info.circle",
                            description: "Understanding glaucoma and its effects"
                        )
                    }
                    
                    NavigationLink(destination: Text("Treatment Options")) {
                        ContainerView(
                            title: "Treatment Options",
                            systemImage: "cross.case",
                            description: "Available treatments and procedures"
                        )
                    }
                    
                    NavigationLink(destination: Text("Risk Factors")) {
                        ContainerView(
                            title: "Risk Factors",
                            systemImage: "exclamationmark.triangle",
                            description: "Identify and understand risk factors"
                        )
                    }
                    
                    NavigationLink(destination: Text("Prevention Tips")) {
                        ContainerView(
                            title: "Prevention",
                            systemImage: "heart.text.square",
                            description: "Tips for maintaining eye health"
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGray6))
    }
}

struct GlaucomaView_Previews: PreviewProvider {
    static var previews: some View {
        GlaucomaView()
    }
} 
