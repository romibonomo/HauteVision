import Foundation
import FirebaseFirestore

// Fuchs' Measurement Model
struct FuchsMeasurement: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let date: Date
    let eye: EyeType
    let ecd: Double // Endothelial Cell Density
    let pachymetry: Int
    let score: Int // Severity score (0-4)
    let vfuchsQuestionnaire: Double // VFuchs Questionnaire score
    let notes: String?
    let edited: Bool? // Track if this entry has been edited, optional for backward compatibility
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case date
        case eye
        case ecd
        case pachymetry
        case score
        case vfuchsQuestionnaire
        case notes
        case edited
    }
    
    // Computed property to handle the optional edited field
    var isEdited: Bool {
        return edited ?? false
    }
    
    init(id: String? = nil,
         userId: String,
         date: Date = Date(),
         eye: EyeType,
         ecd: Double,
         pachymetry: Int,
         score: Int,
         vfuchsQuestionnaire: Double,
         notes: String? = nil,
         edited: Bool? = nil) {
        self.id = id
        self.userId = userId
        self.date = date
        self.eye = eye
        self.ecd = ecd
        self.pachymetry = pachymetry
        self.score = score
        self.vfuchsQuestionnaire = vfuchsQuestionnaire
        self.notes = notes
        self.edited = edited
    }
}

// Transplant Measurement Model
struct TransplantMeasurement: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let date: Date
    let eye: EyeType
    let ecd: Double
    let pachymetry: Int
    let iop: Double
    let isRegraft: Bool
    let steroidRegimen: String?
    let medicationName: String?
    let notes: String?
    let edited: Bool? // Track if this entry has been edited, optional for backward compatibility
    
    var timeElapsed: String {
        let components = Calendar.current.dateComponents([.year, .month], from: date, to: Date())
        if let years = components.year, years > 0 {
            return "\(years)y"
        } else if let months = components.month, months > 0 {
            return "\(months)m"
        } else {
            return "< 1m"
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    // Computed property to handle the optional edited field
    var isEdited: Bool {
        return edited ?? false
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case userId
        case date
        case eye
        case ecd
        case pachymetry
        case iop
        case isRegraft
        case steroidRegimen
        case medicationName
        case notes
        case edited
    }
    
    init(id: String? = nil,
         userId: String,
         date: Date = Date(),
         eye: EyeType,
         ecd: Double,
         pachymetry: Int,
         iop: Double,
         isRegraft: Bool = false,
         steroidRegimen: String? = nil,
         medicationName: String? = nil,
         notes: String? = nil,
         edited: Bool? = nil) {
        self.id = id
        self.userId = userId
        self.date = date
        self.eye = eye
        self.ecd = ecd
        self.pachymetry = pachymetry
        self.iop = iop
        self.isRegraft = isRegraft
        self.steroidRegimen = steroidRegimen
        self.medicationName = medicationName
        self.notes = notes
        self.edited = edited
    }
} 
