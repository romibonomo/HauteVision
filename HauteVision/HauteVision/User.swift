import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let email: String
    let dateOfBirth: Date?
    let profileImageUrl: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: name) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
    
    // Custom coding keys to handle date formatting
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case dateOfBirth
        case profileImageUrl
    }
    
    // Custom decoder to handle optional date
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        dateOfBirth = try container.decodeIfPresent(Date.self, forKey: .dateOfBirth)
        profileImageUrl = try container.decode(String.self, forKey: .profileImageUrl)
    }
    
    // Custom initializer for creating a user
    init(id: String?, email: String, name: String, dateOfBirth: Date? = nil, profileImageUrl: String = "") {
        self.id = id
        self.name = name
        self.email = email
        self.dateOfBirth = dateOfBirth
        self.profileImageUrl = profileImageUrl
    }
} 