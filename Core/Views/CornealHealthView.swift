import SwiftUI

struct CornealHealthView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Image
                Image("corneal_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.top)
                
                // Content Containers
                VStack(spacing: 15) {
                    NavigationLink(destination: Text("Corneal Health Information")) {
                        ContainerView(
                            title: "About Corneal Health",
                            systemImage: "eye",
                            description: ""
                        )
                    }
                    
                    NavigationLink(destination: Text("Common Conditions")) {
                        ContainerView(
                            title: "Common Conditions",
                            systemImage: "list.bullet",
                            description: ""
                        )
                    }
                    
                    NavigationLink(destination: Text("Treatment Options")) {
                        ContainerView(
                            title: "Treatments",
                            systemImage: "cross.case",
                            description: ""
                        )
                    }
                    
                    NavigationLink(destination: Text("Care Tips")) {
                        ContainerView(
                            title: "Care Tips",
                            systemImage: "heart.text.square",
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

struct CornealHealthView_Previews: PreviewProvider {
    static var previews: some View {
        CornealHealthView()
    }
} 
