import SwiftUI

struct ContainerView: View {
    let title: String
    let systemImage: String
    let description: String
    
    init(title: String, systemImage: String, description: String = "") {
        self.title = title
        self.systemImage = systemImage
        self.description = description
    }
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                if !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
} 