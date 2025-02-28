import SwiftUI

struct RetinalInjectionsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Image
                Image("retinal_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.top)
                
                // Content Containers
                VStack(spacing: 15) {
                    NavigationLink(destination: Text("About Retinal Injections")) {
                        ContainerView(
                            title: "What are Retinal Injections?",
                            systemImage: "eye",
                            description: ""
                        )
                    }
                    
                    NavigationLink(destination: Text("Procedure Information")) {
                        ContainerView(
                            title: "The Procedure",
                            systemImage: "syringe",
                            description: ""
                        )
                    }
                    
                    NavigationLink(destination: Text("Recovery Information")) {
                        ContainerView(
                            title: "Recovery",
                            systemImage: "bandage",
                            description: ""
                        )
                    }
                    
                    NavigationLink(destination: Text("FAQs")) {
                        ContainerView(
                            title: "Frequently Asked Questions",
                            systemImage: "questionmark.circle",
                            description: ""
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

struct RetinalInjectionsView_Previews: PreviewProvider {
    static var previews: some View {
        RetinalInjectionsView()
    }
} 
