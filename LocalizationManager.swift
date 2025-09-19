//
//  LocalizationManager.swift
//  HauteVision
//
//  Created by AI Assistant on 2025-01-27.
//

import SwiftUI
import Foundation

// MARK: - Language Enum
enum Language: String, CaseIterable {
    case english = "en"
    case french = "fr"
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .french:
            return "Français"
        }
    }
    
    var flag: String {
        switch self {
        case .english:
            return "🇺🇸"
        case .french:
            return "🇫🇷"
        }
    }
}

// MARK: - Localization Manager
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
            // Post notification for language change
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    private init() {
        // Load saved language or default to English
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        self.currentLanguage = Language(rawValue: savedLanguage) ?? .english
    }
    
    func setLanguage(_ language: Language) {
        currentLanguage = language
    }
    
    func toggleLanguage() {
        currentLanguage = currentLanguage == .english ? .french : .english
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

// MARK: - Localized String Keys
struct LocalizedStringKey {
    // MARK: - Common
    static let home = "home"
    static let profile = "profile"
    static let about = "about"
    static let settings = "settings"
    static let language = "language"
    static let english = "english"
    static let french = "french"
    static let save = "save"
    static let cancel = "cancel"
    static let edit = "edit"
    static let delete = "delete"
    static let confirm = "confirm"
    static let ok = "ok"
    static let error = "error"
    static let success = "success"
    
    // MARK: - Profile
    static let accountSettings = "account_settings"
    static let changePassword = "change_password"
    static let signOut = "sign_out"
    static let deleteAccount = "delete_account"
    static let resetOnboarding = "reset_onboarding"
    static let privacyPolicy = "privacy_policy"
    static let currentPassword = "current_password"
    static let newPassword = "new_password"
    static let confirmNewPassword = "confirm_new_password"
    static let passwordChanged = "password_changed"
    static let passwordChangedMessage = "password_changed_message"
    static let deleteAccountConfirmation = "delete_account_confirmation"
    static let deleteAccountMessage = "delete_account_message"
    
    // MARK: - About Us
    static let aboutUs = "about_us"
    static let visionaryApproach = "visionary_approach"
    static let ourMission = "our_mission"
    static let ourVision = "our_vision"
    static let ourCoreValues = "our_core_values"
    static let ourExpertise = "our_expertise"
    static let contactUs = "contact_us"
    static let openingHours = "opening_hours"
    static let saturdayToSunday = "saturday_to_sunday"
    static let mondayToFriday = "monday_to_friday"
    static let closed = "closed"
    static let visitOurWebsite = "visit_our_website"
    static let trustYourVision = "trust_your_vision"
    
    // MARK: - Values
    static let innovation = "innovation"
    static let integrity = "integrity"
    static let excellence = "excellence"
    static let collaboration = "collaboration"
    static let compassion = "compassion"
    
    // MARK: - Home
    static let welcomeToHauteVision = "welcome_to_haute_vision"
    static let hello = "hello"
    
    // MARK: - My Health
    static let myHealth = "my_health"
    static let eyeConditions = "eye_conditions"
    static let cornealHealth = "corneal_health"
    static let glaucoma = "glaucoma"
    static let retinalInjections = "retinal_injections"
    static let dryEye = "dry_eye"
    static let fuchsDystrophy = "fuchs_dystrophy"
    static let cornealTransplant = "corneal_transplant"
    static let keratoconus = "keratoconus"
    static let comingSoon = "coming_soon"
    static let underDevelopment = "under_development"
    
    // MARK: - Privacy Policy
    static let privacyPolicyTitle = "privacy_policy_title"
    static let lastUpdated = "last_updated"
    static let welcomeToHauteVisionApp = "welcome_to_haute_vision_app"
    static let privacyPolicyIntro = "privacy_policy_intro"
    static let informationWeCollect = "information_we_collect"
    static let informationWeCollectDesc = "information_we_collect_desc"
    static let personalInformationWeCollect = "personal_information_we_collect"
    static let automaticallyCollectedInformation = "automatically_collected_information"
    static let automaticallyCollectedInformationDesc = "automatically_collected_information_desc"
    static let howWeUseYourInformation = "how_we_use_your_information"
    static let howWeUseYourInformationDesc = "how_we_use_your_information_desc"
    static let sharingYourInformation = "sharing_your_information"
    static let sharingYourInformationDesc = "sharing_your_information_desc"
    static let dataSecurity = "data_security"
    static let dataSecurityDesc = "data_security_desc"
    static let yourRights = "your_rights"
    static let yourRightsDesc = "your_rights_desc"
    static let cookiesAndTracking = "cookies_and_tracking"
    static let cookiesAndTrackingDesc = "cookies_and_tracking_desc"
    static let thirdPartyLinks = "third_party_links"
    static let thirdPartyLinksDesc = "third_party_links_desc"
    static let contactUsPrivacy = "contact_us_privacy"
    static let contactUsPrivacyDesc = "contact_us_privacy_desc"
    static let changesToPrivacyPolicy = "changes_to_privacy_policy"
    static let changesToPrivacyPolicyDesc = "changes_to_privacy_policy_desc"
    static let consentToPrivacyPolicy = "consent_to_privacy_policy"
    static let thankYouForTrusting = "thank_you_for_trusting"
    
    // MARK: - Edit Profile
    static let editProfile = "edit_profile"
    static let fullName = "full_name"
    static let emailAddress = "email_address"
    static let enterYourName = "enter_your_name"
    static let change = "change"
    static let profileUpdatedSuccessfully = "profile_updated_successfully"
    static let changeEmail = "change_email"
    static let currentEmail = "current_email"
    static let newEmail = "new_email"
    static let sendVerificationEmail = "send_verification_email"
    static let verificationEmailSent = "verification_email_sent"
    static let verificationEmailSentMessage = "verification_email_sent_message"
    static let updatePassword = "update_password"
    static let passwordUpdatedSuccessfully = "password_updated_successfully"
    
    // MARK: - Common UI Elements
    static let time = "time"
    
    // MARK: - Dry Eye
    static let aboutDryEye = "about_dry_eye"
    static let trackDryEyeMeasurements = "track_dry_eye_measurements"
    static let followUsInstagram = "follow_us_instagram"
    static let followUs = "follow_us"
    static let addMeasurement = "add_measurement"
    static let measurementsOverTime = "measurements_over_time"
    static let osdiQuestionnaire = "osdi_questionnaire"
    static let symptomScore = "symptom_score"
    static let osmolarity = "osmolarity"
    static let tearFilmOsmolarity = "tear_film_osmolarity"
    static let meibography = "meibography"
    static let glandLossPercentage = "gland_loss_percentage"
    static let tearMeniscusHeight = "tear_meniscus_height"
    static let tmhMeasurement = "tmh_measurement"
    static let measurementHistory = "measurement_history"
    static let noMeasurements = "no_measurements"
    static let addFirstMeasurement = "add_first_measurement"
    static let startTracking = "start_tracking"
    static let noData = "no_data"
    static let addFirstMeasurementToStart = "add_first_measurement_to_start"
    static let edited = "edited"
    static let osdiScore = "osdi_score"
    static let score = "score"
    static let mosmL = "mosm_l"
    static let percent = "percent"
    static let ipl = "ipl"
    static let rf = "rf"
    static let mm = "mm"
    static let mmp9Positive = "mmp9_positive"
    static let aboutDryEyeSyndrome = "about_dry_eye_syndrome"
    static let dryEyeSyndromeDescription = "dry_eye_syndrome_description"
    static let keyMeasurements = "key_measurements"
    static let dryEyeQuestionnaireDescription = "dry_eye_questionnaire_description"
    static let osmolarityDescription = "osmolarity_description"
    static let meibographyDescription = "meibography_description"
    static let tmhDescription = "tmh_description"
    static let mmp9StatusDescription = "mmp9_status_description"
    static let treatmentOptions = "treatment_options"
    static let artificialTears = "artificial_tears"
    static let artificialTearsDescription = "artificial_tears_description"
    static let warmCompresses = "warm_compresses"
    static let warmCompressesDescription = "warm_compresses_description"
    static let iplRfTreatments = "ipl_rf_treatments"
    static let iplRfTreatmentsDescription = "ipl_rf_treatments_description"
    static let prescriptionMedications = "prescription_medications"
    static let prescriptionMedicationsDescription = "prescription_medications_description"
    static let whenToSeekHelp = "when_to_seek_help"
    static let whenToSeekHelpDescription = "when_to_seek_help_description"
    static let diseaseInformation = "disease_information"
    static let visionMeasurements = "vision_measurements"
    static let ocularSurfaceDiseaseIndex = "ocular_surface_disease_index"
    static let osmolarityExample = "osmolarity_example"
    static let meibographyExample = "meibography_example"
    static let tmhExample = "tmh_example"
    static let followUpReminder = "follow_up_reminder"
    static let iplTreatment = "ipl_treatment"
    static let iplDescription = "ipl_description"
    static let nextIplTreatment = "next_ipl_treatment"
    static let setDate = "set_date"
    static let clearDate = "clear_date"
    static let radioFrequency = "radio_frequency"
    static let rfDescription = "rf_description"
    static let nextRfTreatment = "next_rf_treatment"
    static let nextAppointments = "next_appointments"
    static let nextTreatmentReminder = "next_treatment_reminder"
    static let today = "today"
    static let tomorrow = "tomorrow"
    static let days = "days"
    static let notes = "notes"
    static let optionalNotes = "optional_notes"
    static let mmp9Marker = "mmp9_marker"
    static let inflammationMarker = "inflammation_marker"
    static let updateMeasurement = "update_measurement"
    static let saveMeasurement = "save_measurement"
    static let yes = "yes"
    static let no = "no"
    static let note = "note"
    static let optionalNote = "optional_note"
    static let osdiDescription = "osdi_description"
    static let normal = "normal"
    static let mild = "mild"
    static let moderate = "moderate"
    static let severe = "severe"
    static let elevated = "elevated"
    static let high = "high"
    static let low = "low"
    static let veryLow = "very_low"
    static let critical = "critical"
    static let normalRange = "normal_range"
    static let normalRangeOsmolarity = "normal_range_osmolarity"
    static let normalRangeMeibography = "normal_range_meibography"
    static let moderateRange = "moderate_range"
    static let severeRange = "severe_range"
    static let normalRangeTmh = "normal_range_tmh"
    static let mmp9Description = "mmp9_description"
    static let iplDescription2 = "ipl_description_2"
    static let rfDescription2 = "rf_description_2"
    static let rightEye = "right_eye"
    static let leftEye = "left_eye"
    static let noneOfTime = "none_of_time"
    static let someOfTime = "some_of_time"
    static let halfOfTime = "half_of_time"
    static let mostOfTime = "most_of_time"
    static let allOfTime = "all_of_time"
    static let dryEyeAssessment = "dry_eye_assessment"
    static let osdiInstructions1 = "osdi_instructions_1"
    static let osdiInstructions2 = "osdi_instructions_2"
    static let eyeSymptoms = "eye_symptoms"
    static let symptomQuestionPrompt = "symptom_question_prompt"
    static let dailyActivities = "daily_activities"
    static let functionQuestionPrompt = "function_question_prompt"
    static let environmentalFactors = "environmental_factors"
    static let environmentalQuestionPrompt = "environmental_question_prompt"
    static let saveAnswers = "save_answers"
    static let incompleteQuestionnaire = "incomplete_questionnaire"
    static let answerAllQuestions = "answer_all_questions"
    static let osdiScoreCalculation = "osdi_score_calculation"
    static let howCalculated = "how_calculated"
    static let formula = "formula"
    static let sumOfScores = "sum_of_scores"
    static let questionsAnswered = "questions_answered"
    static let responsePointScale = "response_point_scale"
    static let severityClassification = "severity_classification"
    static let requiredField = "required_field"
    static let editMeasurement = "edit_measurement"
    static let editMeasurementWarning = "edit_measurement_warning"
    static let done = "done"
    static let `continue` = "continue"
    
    // MARK: - OSDI Questionnaire Questions
    static let eyesSensitiveLight = "eyes_sensitive_light"
    static let eyesFeelGritty = "eyes_feel_gritty"
    static let painfulSoreEyes = "painful_sore_eyes"
    static let blurredVision = "blurred_vision"
    static let poorVision = "poor_vision"
    static let reading = "reading"
    static let drivingNight = "driving_night"
    static let computerAtm = "computer_atm"
    static let watchingTv = "watching_tv"
    static let windyConditions = "windy_conditions"
    static let lowHumidity = "low_humidity"
    static let airConditioned = "air_conditioned"
    
    // MARK: - Fuchs' Dystrophy
    static let aboutFuchsDystrophy = "about_fuchs_dystrophy"
    static let fuchsDystrophyDescription = "fuchs_dystrophy_description"
    static let trackCornealHealth = "track_corneal_health"
    static let emptyStateFuchsMeasurement = "empty_state_fuchs_measurement"
    static let ecdTooltipDescription = "ecd_tooltip_description"
    static let ecdTooltipNormalRange = "ecd_tooltip_normal_range"
    static let pachymetryTooltipDescription = "pachymetry_tooltip_description"
    static let pachymetryTooltipNormalRange = "pachymetry_tooltip_normal_range"
    static let scoreTooltipDescription = "score_tooltip_description"
    static let scoreTooltipRanges = "score_tooltip_ranges"
    static let vfuchsTooltipDescription = "vfuchs_tooltip_description"
    static let vfuchsTooltipNote = "vfuchs_tooltip_note"
    static let ecdPlaceholder = "ecd_placeholder"
    static let pachymetryPlaceholder = "pachymetry_placeholder"
    static let endothelialCellDensity = "endothelial_cell_density"
    static let cornealThickness = "corneal_thickness"
    static let severityScore = "severity_score"
    static let vFuchsQuestionnaire = "v_fuchs_questionnaire"
    static let visualFunctionCornealHealth = "visual_function_corneal_health"
    static let cellsPerMm2 = "cells_per_mm2"
    static let micrometers = "micrometers"
    static let scale = "scale"
    static let normalRangeEcd = "normal_range_ecd"
    static let normalRangePachymetry = "normal_range_pachymetry"
    static let normalRangeScore = "normal_range_score"
    static let ecdDescription = "ecd_description"
    static let pachymetryDescription = "pachymetry_description"
    static let scoreDescription = "score_description"
    static let vFuchsDescription = "v_fuchs_description"
    static let monitoring = "monitoring"
    static let monitoringDescription = "monitoring_description"
    static let editMeasurementMessage = "edit_measurement_message"
    static let visionAssessment = "vision_assessment"
    static let visualFunctionCornealHealthStatus = "visual_function_corneal_health_status"
    static let pleaseCompleteEvaluation = "please_complete_evaluation"
    static let considerOnlyVisionDifficulties = "consider_only_vision_difficulties"
    static let ifYouWearGlasses = "if_you_wear_glasses"
    static let frequencyAssessment = "frequency_assessment"
    static let howOftenExperience = "how_often_experience"
    static let difficultyAssessment = "difficulty_assessment"
    static let howMuchDifficulty = "how_much_difficulty"
    static let never = "never"
    static let rarely = "rarely"
    static let sometimes = "sometimes"
    static let mostOfTheTime = "most_of_the_time"
    static let allOfTheTime = "all_of_the_time"
    static let noDifficulty = "no_difficulty"
    static let aLittle = "a_little"
    static let moderateDifficulty = "moderate_difficulty"
    static let aLot = "a_lot"
    static let extremeDifficulty = "extreme_difficulty"
    static let totalScore = "total_score"
    static let frequency = "frequency"
    static let difficulty = "difficulty"
    static let source = "source"
    static let copyright = "copyright"
    static let mc8801 = "mc8801"
    
    // MARK: - Fuchs' Dystrophy Questionnaire Questions
    static let fuchsQ1 = "fuchs_q1"
    static let fuchsQ2 = "fuchs_q2"
    static let fuchsQ3 = "fuchs_q3"
    static let fuchsQ4 = "fuchs_q4"
    static let fuchsQ5 = "fuchs_q5"
    static let fuchsQ6 = "fuchs_q6"
    static let fuchsQ7 = "fuchs_q7"
    static let fuchsQ8 = "fuchs_q8"
    static let fuchsQ9 = "fuchs_q9"
    static let fuchsQ10 = "fuchs_q10"
    static let fuchsQ11 = "fuchs_q11"
    static let fuchsQ12 = "fuchs_q12"
    static let fuchsQ13 = "fuchs_q13"
    static let fuchsQ14 = "fuchs_q14"
    static let fuchsQ15 = "fuchs_q15"
    
    // MARK: - Corneal Transplant
    static let aboutCornealTransplant = "about_corneal_transplant"
    static let cornealTransplantDescription = "corneal_transplant_description"
    static let trackCornealTransplantMeasurements = "track_corneal_transplant_measurements"
    static let specularMicroscopy = "specular_microscopy"
    static let intraocularPressure = "intraocular_pressure"
    static let iop = "iop"
    static let noMedicationRecorded = "no_medication_recorded"
    static let noRegimenRecorded = "no_regimen_recorded"
    static let addFirstMeasurementToTrack = "add_first_measurement_to_track"
    static let regraft = "regraft"
    static let secondTransplant = "second_transplant"
    static let medicationRegimen = "medication_regimen"
    static let noRegimen = "no_regimen"
    static let medication = "medication"
    static let steroidRegimen = "steroid_regimen"
    static let cornealTransplantInfo = "corneal_transplant_info"
    static let cornealTransplantSurgicalProcedure = "corneal_transplant_surgical_procedure"
    static let iopDescription = "iop_description"
    static let medicationManagement = "medication_management"
    static let steroidDrops = "steroid_drops"
    static let steroidDropsDescription = "steroid_drops_description"
    static let antibioticDrops = "antibiotic_drops"
    static let antibioticDropsDescription = "antibiotic_drops_description"
    static let otherMedications = "other_medications"
    static let otherMedicationsDescription = "other_medications_description"
    static let warningSigns = "warning_signs"
    static let warningSignsDescription = "warning_signs_description"
    static let monitoringSchedule = "monitoring_schedule"
    static let monitoringScheduleDescription = "monitoring_schedule_description"
    static let addMeasurementTitle = "add_measurement_title"
    static let update = "update"
    static let continueAction = "continue"
    static let measurements = "measurements"
    static let iopPlaceholder = "iop_placeholder"
    static let ecdDescriptionShort = "ecd_description_short"
    static let pachymetryDescriptionShort = "pachymetry_description_short"
    static let iopDescriptionShort = "iop_description_short"
    static let medicationsProcedures = "medications_procedures"
    static let addMedication = "add_medication"
    static let medicationType = "medication_type"
    static let medicationName = "medication_name"
    static let setReminder = "set_reminder"
    static let startDate = "start_date"
    static let pills = "pills"
    static let drops = "drops"
    static let injection = "injection"
    static let everyDay = "every_day"
    static let monitoringGuidelines = "monitoring_guidelines"
    static let firstThreeMonths = "first_three_months"
    static let everyFourSixMonths = "every_four_six_months"
    static let mayChangeFrequency = "may_change_frequency"
    static let repeatAction = "repeat"
    static let customFrequency = "custom_frequency"
    static let setReminderTitle = "set_reminder_title"
    static let medicationReminder = "medication_reminder"
    static let timeToTakeMedication = "time_to_take_medication"
    static let ecdTooltip = "ecd_tooltip"
    static let pachymetryTooltip = "pachymetry_tooltip"
    static let iopTooltip = "iop_tooltip"
    static let regraftTooltip = "regraft_tooltip"
    static let ecdNormalRange = "ecd_normal_range"
    static let pachymetryNormalRange = "pachymetry_normal_range"
    static let iopNormalRange = "iop_normal_range"
    static let validEcdError = "valid_ecd_error"
    static let validPachymetryError = "valid_pachymetry_error"
    static let validIopError = "valid_iop_error"
    static let fillRequiredFields = "fill_required_fields"
    static let enterValidNumbers = "enter_valid_numbers"
    static let enterMedicationName = "enter_medication_name"
    static let enterCustomFrequency = "enter_custom_frequency"
    static let enterCustomReminderFrequency = "enter_custom_reminder_frequency"
    static let endothelialCellDensityTooltip = "endothelial_cell_density_tooltip"
    static let cornealThicknessTooltip = "corneal_thickness_tooltip"
    static let intraocularPressureTooltip = "intraocular_pressure_tooltip"
    static let regraftTooltipDescription = "regraft_tooltip_description"
    
    // MARK: - Units
    static let mmHg = "mmhg"
    
    // MARK: - Medication Regimen
    static let daily = "daily"
    static let weekly = "weekly"
    static let monthly = "monthly"
    static let twiceDaily = "twice_daily"
    static let threeTimesDaily = "three_times_daily"
    static let everyOtherDay = "every_other_day"
    static let asNeeded = "as_needed"
    
    // MARK: - Keratoconus
    static let aboutKeratoconus = "about_keratoconus"
    static let keratoconusDescription = "keratoconus_description"
    static let trackCornealMeasurements = "track_corneal_measurements"
    static let k2Values = "k2_values"
    static let kMaxValues = "k_max_values"
    static let thinnestPachymetry = "thinnest_pachymetry"
    static let epithelialThickness = "epithelial_thickness"
    static let thickestSpot = "thickest_spot"
    static let thinnestSpot = "thinnest_spot"
    static let thickestEpithelialSpot = "thickest_epithelial_spot"
    static let thinnestEpithelialSpot = "thinnest_epithelial_spot"
    static let keratoconusRiskScore = "keratoconus_risk_score"
    static let lowRisk = "low_risk"
    static let highRisk = "high_risk"
    static let crosslinkingPerformed = "crosslinking_performed"
    static let k2Tooltip = "k2_tooltip"
    static let kMaxTooltip = "k_max_tooltip"
    static let epithelialTooltip = "epithelial_tooltip"
    static let riskScoreTooltip = "risk_score_tooltip"
    static let normalRangeK2 = "normal_range_k2"
    static let normalRangeKMax = "normal_range_k_max"
    static let normalRangePachymetryKeratoconus = "normal_range_pachymetry_keratoconus"
    static let normalRangeEpithelial = "normal_range_epithelial"
    static let riskScoreRange = "risk_score_range"
    static let steepestCornealCurvature = "steepest_corneal_curvature"
    static let maximumCornealCurvature = "maximum_corneal_curvature"
    static let thinnestPointCornea = "thinnest_point_cornea"
    static let cornealEpitheliumThickness = "corneal_epithelium_thickness"
    static let compositeScore = "composite_score"
    static let cylindricalIncrease = "cylindrical_increase"
    static let visionLoss = "vision_loss"
    static let crossLinking = "cross_linking"
    static let deleteMeasurement = "delete_measurement"
    static let deleteMeasurementConfirmation = "delete_measurement_confirmation"
    static let deleteConfirmation = "delete_confirmation"
    static let deleteConfirmationMessage = "delete_confirmation_message"
    static let k2Placeholder = "k2_placeholder"
    static let kMaxPlaceholder = "k_max_placeholder"
    static let epithelialPlaceholder = "epithelial_placeholder"
    static let thickestEpithelialPlaceholder = "thickest_epithelial_placeholder"
    static let thinnestEpithelialPlaceholder = "thinnest_epithelial_placeholder"
    static let riskIndicators = "risk_indicators"
    static let procedures = "procedures"
    static let crossLinkingPerformed = "cross_linking_performed"
    static let notesPlaceholder = "notes_placeholder"
    static let selectDateTime = "select_date_time"
    static let keratoconusInfo = "keratoconus_info"
    static let keratoconusSurgicalProcedure = "keratoconus_surgical_procedure"
    static let crossLinkingCxl = "cross_linking_cxl"
    static let crossLinkingDescription = "cross_linking_description"
    static let specialtyContactLenses = "specialty_contact_lenses"
    static let specialtyLensesDescription = "specialty_lenses_description"
    static let intacs = "intacs"
    static let intacsDescription = "intacs_description"
    static let keratoconusInformation = "keratoconus_information"
    static let diopters = "diopters"
    static let normalThickness = "normal_thickness"
    static let normalValues = "normal_values"
    static let higherValues = "higher_values"
    static let importantForTracking = "important_for_tracking"
    static let thinningMayIndicate = "thinning_may_indicate"
    static let thinningInAreas = "thinning_in_areas"
    static let compositeScoreDescription = "composite_score_description"
    static let higherScores = "higher_scores"
    static let procedureStrengthens = "procedure_strengthens"
    static let customDesignedLenses = "custom_designed_lenses"
    static let smallCornealInserts = "small_corneal_inserts"
    static let contactDoctor = "contact_doctor"
    static let rapidChanges = "rapid_changes"
    static let increasedSensitivity = "increased_sensitivity"
    static let difficultyWithLenses = "difficulty_with_lenses"
    static let mayIndicateProgression = "may_indicate_progression"
    static let increaseInAstigmatism = "increase_in_astigmatism"
    static let patientReportedDecreaseInVision = "patient_reported_decrease_in_vision"
    static let cornealEpitheliumThickestPoint = "corneal_epithelium_thickest_point"
    static let cornealEpitheliumThinnestPoint = "corneal_epithelium_thinnest_point"
    static let subjectiveVisionLoss = "subjective_vision_loss"
    
    // MARK: - Glaucoma
    static let aboutGlaucoma = "about_glaucoma"
    static let glaucomaDescription = "glaucoma_description"
    static let retinalNerveFiberLayer = "retinal_nerve_fiber_layer"
    static let rnfl = "rnfl"
    static let rnflSuperior = "rnfl_superior"
    static let rnflInferior = "rnfl_inferior"
    static let macularGcc = "macular_gcc"
    static let meanDefect = "mean_defect"
    static let md = "md"
    static let patternStandardDeviation = "pattern_standard_deviation"
    static let psd = "psd"
    static let visualFieldChange = "visual_field_change"
    static let rnflChange = "rnfl_change"
    static let familyHistory = "family_history"
    static let lasikSurgery = "lasik_surgery"
    static let newEyeDrops = "new_eye_drops"
    static let eyeDropsDetails = "eye_drops_details"
    static let medicationProcedures = "medication_procedures"
    static let glaucomaInformation = "glaucoma_information"
    static let visualFieldParameters = "visual_field_parameters"
    static let octMeasurements = "oct_measurements"
    static let riskFactors = "risk_factors"
    static let mdTooltip = "md_tooltip"
    static let psdTooltip = "psd_tooltip"
    static let rnflTooltip = "rnfl_tooltip"
    static let gccTooltip = "gcc_tooltip"
    static let normalRangeIop = "normal_range_iop"
    static let normalRangeMd = "normal_range_md"
    static let normalRangePsd = "normal_range_psd"
    static let normalRangeRnfl = "normal_range_rnfl"
    static let normalRangeGcc = "normal_range_gcc"
    static let mdDescription = "md_description"
    static let psdDescription = "psd_description"
    static let rnflDescription = "rnfl_description"
    static let gccDescription = "gcc_description"
    static let visualFieldChangeDescription = "visual_field_change_description"
    static let rnflChangeDescription = "rnfl_change_description"
    static let familyHistoryDescription = "family_history_description"
    static let lasikSurgeryDescription = "lasik_surgery_description"
    static let newEyeDropsDescription = "new_eye_drops_description"
    static let eyeDropsDetailsDescription = "eye_drops_details_description"
    static let mdPlaceholder = "md_placeholder"
    static let psdPlaceholder = "psd_placeholder"
    static let rnflPlaceholder = "rnfl_placeholder"
    static let rnflSuperiorPlaceholder = "rnfl_superior_placeholder"
    static let rnflInferiorPlaceholder = "rnfl_inferior_placeholder"
    static let gccPlaceholder = "gcc_placeholder"
    static let eyeDropsPlaceholder = "eye_drops_placeholder"
    static let rnflSuperotemporal = "rnfl_superotemporal"
    static let rnflInferotemporal = "rnfl_inferotemporal"
    static let superiorQuadrantThickness = "superior_quadrant_thickness"
    static let inferiorQuadrantThickness = "inferior_quadrant_thickness"
    static let macularGanglionCellComplex = "macular_ganglion_cell_complex"
    static let ganglionCellComplexThickness = "ganglion_cell_complex_thickness"
    static let averageSensitivityLoss = "average_sensitivity_loss"
    static let irregularityVisualFieldLoss = "irregularity_visual_field_loss"
    static let thicknessNerveFibers = "thickness_nerve_fibers"
    static let thicknessGanglionCells = "thickness_ganglion_cells"
    static let elevatedIopRiskFactor = "elevated_iop_risk_factor"
    static let progressivelyNegativeValues = "progressively_negative_values"
    static let increasingPsdProgression = "increasing_psd_progression"
    static let rnflThinningProgression = "rnfl_thinning_progression"
    static let gccThinningEarlyDamage = "gcc_thinning_early_damage"
    static let familyHistoryIncreasesRisk = "family_history_increases_risk"
    static let lasikAffectsIopMeasurements = "lasik_affects_iop_measurements"
    static let contactDoctorImmediately = "contact_doctor_immediately"
    static let visionChangesEyePain = "vision_changes_eye_pain"
    static let severeHeadachesHalos = "severe_headaches_halos"
    static let acuteGlaucomaEpisode = "acute_glaucoma_episode"
    static let db = "db"
    
    // MARK: - Retinal Injections
    static let aboutRetinaInjections = "about_retina_injections"
    static let retinaInjectionsDescription = "retina_injections_description"
    static let trackRetinaInjectionTreatments = "track_retina_injection_treatments"
    static let injectionCalendar = "injection_calendar"
    static let centralRetinalThickness = "central_retinal_thickness"
    static let crtMeasurement = "crt_measurement"
    static let visualAcuity = "visual_acuity"
    static let visionMeasurement = "vision_measurement"
    static let upcomingFollowUp = "upcoming_follow_up"
    static let injectionDetails = "injection_details"
    static let noInjectionDetailsFound = "no_injection_details_found"
    static let noRecordedInjectionsForDate = "no_recorded_injections_for_date"
    static let injectionTime = "injection_time"
    static let nextAppointment = "next_appointment"
    static let notSet = "not_set"
    static let newInjection = "new_injection"
    static let retinaInjectionInfo = "retina_injection_info"
    static let retinaInjectionsUsedToTreat = "retina_injections_used_to_treat"
    static let keyMeasurementsRetina = "key_measurements_retina"
    static let centralRetinaThicknessCrt = "central_retina_thickness_crt"
    static let thicknessCentralRetina = "thickness_central_retina"
    static let higherValuesMayIndicate = "higher_values_may_indicate"
    static let visionVisualAcuity = "vision_visual_acuity"
    static let tracksVisionChanges = "tracks_vision_changes"
    static let injectionTimeline = "injection_timeline"
    static let datesMedicationsInjection = "dates_medications_injection"
    static let newInjectionIndicates = "new_injection_indicates"
    static let whenNewMedication = "when_new_medication"
    static let followUpReminders = "follow_up_reminders"
    static let helpsRememberAppointments = "helps_remember_appointments"
    static let treatmentGoals = "treatment_goals"
    static let reduceRetinalSwelling = "reduce_retinal_swelling"
    static let maintainImproveVision = "maintain_improve_vision"
    static let preventFurtherVisionLoss = "prevent_further_vision_loss"
    static let minimizeTreatmentBurden = "minimize_treatment_burden"
    static let whenToSeekHelpRetina = "when_to_seek_help_retina"
    static let contactDoctorSuddenVision = "contact_doctor_sudden_vision"
    static let suddenVisionLoss = "sudden_vision_loss"
    static let increasedFloaters = "increased_floaters"
    static let flashesOfLight = "flashes_of_light"
    static let eyePain = "eye_pain"
    static let retinaInjection = "retina_injection"
    static let editInjection = "edit_injection"
    static let addInjection = "add_injection"
    static let injectionDetailsTitle = "injection_details_title"
    static let newMedicationQuestion = "new_medication_question"
    static let firstTimeUsingMedication = "first_time_using_medication"
    static let injectionMedication = "injection_medication"
    static let visionMeasurementsTitle = "vision_measurements_title"
    static let bestCorrectedVision = "best_corrected_vision"
    static let visualAcuityDescription = "visual_acuity_description"
    static let centralRetinalThicknessTitle = "central_retinal_thickness_title"
    static let crtMeasurementDescription = "crt_measurement_description"
    static let followUpReminderTitle = "follow_up_reminder_title"
    static let clear = "clear"
    static let set = "set"
    static let nextAppointmentColon = "next_appointment_colon"
    static let followUpAppointment = "follow_up_appointment"
    static let notesTitle = "notes_title"
    static let optionalNotesRetina = "optional_notes_retina"
    static let editInjectionWarning = "edit_injection_warning"
    static let modifyExistingInjection = "modify_existing_injection"
    static let actionCannotBeUndone = "action_cannot_be_undone"
    static let doYouWantToContinue = "do_you_want_to_continue"
    static let medicationTooltip = "medication_tooltip"
    static let medicationUsedForInjection = "medication_used_for_injection"
    static let commonMedicationsInclude = "common_medications_include"
    static let avastinLucentisEylea = "avastin_lucentis_eylea"
    static let newMedicationsShouldBeTracked = "new_medications_should_be_tracked"
    static let bestVisionAchievable = "best_vision_achievable"
    static let measuredInSnellenNotation = "measured_in_snellen_notation"
    static let lowerNumbersIndicateBetter = "lower_numbers_indicate_better"
    static let thicknessCentralRetinaTooltip = "thickness_central_retina_tooltip"
    static let highCrtValuesMayIndicate = "high_crt_values_may_indicate"
    static let swellingFluidAccumulation = "swelling_fluid_accumulation"
    static let normalRangeCrt = "normal_range_crt"
    static let setReminderNextAppointment = "set_reminder_next_appointment"
    static let stayOnTrackTreatment = "stay_on_track_treatment"
    static let regularMonitoringEssential = "regular_monitoring_essential"
    static let optimalOutcomes = "optimal_outcomes"
    static let pleaseEnterValidCrt = "please_enter_valid_crt"
    static let mustBeLoggedInAdd = "must_be_logged_in_add"
    static let mustBeLoggedInView = "must_be_logged_in_view"
    static let mustBeLoggedInDelete = "must_be_logged_in_delete"
    static let invalidMeasurementId = "invalid_measurement_id"
    static let failedToFetchMeasurements = "failed_to_fetch_measurements"
    static let failedToAddMeasurement = "failed_to_add_measurement"
    static let failedToDeleteMeasurement = "failed_to_delete_measurement"
    
    // MARK: - Date and Time
    static let reminderDate = "reminder_date"
}

// MARK: - Localized Strings
struct LocalizedStrings {
    private static let strings: [Language: [String: String]] = [
        .english: [
            // Common
            "home": "Home",
            "profile": "Profile",
            "about": "About",
            "settings": "Settings",
            "language": "Language",
            "english": "English",
            "french": "Français",
            "save": "Save",
            "cancel": "Cancel",
            "edit": "Edit",
            "delete": "Delete",
            "confirm": "Confirm",
            "ok": "OK",
            "error": "Error",
            "success": "Success",
            
            // Profile
            "account_settings": "Account Settings",
            "change_password": "Change Password",
            "sign_out": "Sign Out",
            "delete_account": "Delete Account",
            "reset_onboarding": "Reset Onboarding",
            "privacy_policy": "Privacy Policy",
            "current_password": "Current Password",
            "new_password": "New Password",
            "confirm_new_password": "Confirm New Password",
            "password_changed": "Password Changed",
            "password_changed_message": "Your password has been successfully changed.",
            "delete_account_confirmation": "Delete Account",
            "delete_account_message": "Are you sure you want to delete your account? This action cannot be undone.",
            
            // About Us
            "about_us": "About Us",
            "visionary_approach": "A visionary approach to care",
            "our_mission": "Our Mission",
            "our_vision": "Our Vision",
            "our_core_values": "Our Core Values",
            "our_expertise": "Our Expertise",
            "contact_us": "Contact Us",
            "opening_hours": "Opening Hours",
            "saturday_to_sunday": "Saturday to Sunday",
            "monday_to_friday": "Monday to Friday",
            "closed": "Closed",
            "visit_our_website": "Visit our website",
            "trust_your_vision": "Trust your vision to a higher level of care.",
            
            // Values
            "innovation": "Innovation",
            "integrity": "Integrity",
            "excellence": "Excellence",
            "collaboration": "Collaboration",
            "compassion": "Compassion",
            
            // Home
            "welcome_to_haute_vision": "Welcome to Haute Vision!",
            "hello": "Hello",
            
            // My Health
            "my_health": "My Health",
            "eye_conditions": "Eye Conditions",
            "corneal_health": "Corneal Health",
            "glaucoma": "Glaucoma",
            "retinal_injections": "Retinal Injections",
            "dry_eye": "Dry Eye",
            "fuchs_dystrophy": "Fuchs' Dystrophy",
            "corneal_transplant": "Corneal Transplant",
            "keratoconus": "Keratoconus",
            "coming_soon": "Coming Soon",
            "under_development": "This feature is under development and will be available in a future update.",
            "on_site_parking": "On-site parking available (1 hour free)",
            
            // Privacy Policy
            "privacy_policy_title": "Privacy Policy",
            "last_updated": "Last updated: 2025-03-03",
            "welcome_to_haute_vision_app": "Welcome to the Haute Vision Ophthalmology Clinic iOS App",
            "privacy_policy_intro": "Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our website www.hautevision.com. Please read this policy carefully. If you do not agree with the terms of this Privacy Policy, please do not access the site or proceed with the iOS App.",
            "information_we_collect": "Information We Collect",
            "information_we_collect_desc": "We may collect personal information that you provide directly to us when you: fill out a contact form, communicate with us via email or other means, or participate in certain activities on our website.",
            "personal_information_we_collect": "The personal information we collect may include: Full name; Email address; Phone number; Medical information relevant to your inquiry.",
            "automatically_collected_information": "Automatically Collected Information",
            "automatically_collected_information_desc": "When you visit our website, we may also collect certain information automatically, such as: IP address; Browser type; Pages visited and time spent on our site; Referring website.",
            "how_we_use_your_information": "How We Use Your Information",
            "how_we_use_your_information_desc": "We use the information we collect for various purposes, including to: schedule and confirm appointments; respond to your inquiries; improve our website and services; send you promotional materials, if you have opted in; and comply with legal obligations.",
            "sharing_your_information": "Sharing Your Information",
            "sharing_your_information_desc": "We do not sell or rent your personal information to third parties. However, we may share your information with service providers who help us operate our website and manage appointments, and with legal authorities if required by law.",
            "data_security": "Data Security",
            "data_security_desc": "We implement appropriate technical and organizational measures to protect your personal data from unauthorized access, disclosure, alteration, and destruction.",
            "your_rights": "Your Rights",
            "your_rights_desc": "You have the right to access, correct, and withdraw your personal data from our service. You may also request the deletion of your data, subject to legal requirements. If you wish to exercise any of these rights, please contact us at admin@hautevision.com.",
            "cookies_and_tracking": "Cookies and Tracking Technologies",
            "cookies_and_tracking_desc": "Our website may use cookies and similar tracking technologies to enhance your browsing experience. You can set your browser to refuse cookies or alert you when cookies are being sent.",
            "third_party_links": "Third-Party Links",
            "third_party_links_desc": "Our website may contain links to third-party websites. We are not responsible for the privacy practices of these websites.",
            "contact_us_privacy": "Contact Us",
            "contact_us_privacy_desc": "If you have any questions about this Privacy Policy, please contact us at:",
            "changes_to_privacy_policy": "Changes to This Privacy Policy",
            "changes_to_privacy_policy_desc": "We may update this Privacy Policy from time to time. The updated version will be indicated by an updated \"Last updated\" date and will be effective as soon as it is accessible.",
            "consent_to_privacy_policy": "By using our website, you consent to the terms of this Privacy Policy.",
            "thank_you_for_trusting": "Thank you for trusting Haute Vision Ophthalmology Clinic with your personal information",
            
            // Edit Profile
            "edit_profile": "Edit Profile",
            "full_name": "Full Name",
            "email_address": "Email Address",
            "enter_your_name": "Enter your name",
            "change": "Change",
            "profile_updated_successfully": "Your profile has been updated successfully.",
            "change_email": "Change Email",
            "new_email": "New Email",
            "send_verification_email": "Send Verification Email",
            "verification_email_sent": "Verification Email Sent",
            "verification_email_sent_message": "A verification email has been sent to {email}. Please check your email and follow the instructions to complete the email change.",
            "update_password": "Update Password",
            "password_updated_successfully": "Your password has been successfully changed.",
            
            // Common UI Elements
            "time": "Time",
            
            // Dry Eye
            "about_dry_eye": "About Dry Eye",
            "track_dry_eye_measurements": "Track your dry eye measurements to monitor symptoms and treatment effectiveness.",
            "follow_us_instagram": "@dryeyeinstitutemtl",
            "follow_us": "Follow us!",
            "add_measurement": "Add Measurement",
            "measurements_over_time": "Measurements Over Time",
            "osdi_questionnaire": "OSDI Questionnaire",
            "symptom_score": "Symptom Score",
            "osmolarity": "Osmolarity",
            "tear_film_osmolarity": "Tear Film Osmolarity",
            "meibography": "Meibography",
            "gland_loss_percentage": "Gland Loss Percentage",
            "tear_meniscus_height": "Tear Meniscus Height",
            "tmh_measurement": "TMH Measurement",
            "measurement_history": "Measurement History",
            "no_measurements": "No Measurements",
            "add_first_measurement": "Add your first measurement to track your progress",
            "start_tracking": "Start Tracking",
            "no_data": "No data",
            "add_first_measurement_to_start": "Add your first measurement to start tracking",
            "edited": "Edited",
            "osdi_score": "OSDI Score",
            "score": "score",
            "mosm_l": "mOsm/L",
            "percent": "%",
            "ipl": "IPL",
            "rf": "RF",
            "mm": "mm",
            "mmp9_positive": "MMP9 Positive",
            "about_dry_eye_syndrome": "About Dry Eye Syndrome",
            "dry_eye_syndrome_description": "Dry eye syndrome is a common condition that occurs when your tears aren't able to provide adequate lubrication for your eyes. It can be caused by either decreased tear production or increased tear evaporation.",
            "key_measurements": "Key Measurements",
            "dry_eye_questionnaire_description": "A standardized questionnaire that measures dry eye symptoms. Higher scores indicate more severe symptoms.",
            "osmolarity_description": "Measures the concentration of particles in tears. Elevated osmolarity indicates tear film instability.",
            "meibography_description": "Measures the percentage of meibomian glands that are lost or non-functional. Higher percentages indicate more severe gland dysfunction.",
            "tmh_description": "Measures the height of the tear film at the lower eyelid margin. Lower values may indicate reduced tear volume.",
            "mmp9_status_description": "A marker of inflammation in the tear film. Positive results indicate active inflammation requiring treatment.",
            "treatment_options": "Treatment Options",
            "artificial_tears": "Artificial Tears",
            "artificial_tears_description": "Lubricating eye drops that supplement natural tears. Available in various formulations for different severity levels.",
            "warm_compresses": "Warm Compresses",
            "warm_compresses_description": "Helps unclog meibomian glands and improve oil secretion. Recommended daily for maintenance.",
            "ipl_rf_treatments": "IPL/RF Treatments",
            "ipl_rf_treatments_description": "Advanced treatments that improve meibomian gland function and reduce inflammation. Typically performed in a series of sessions.",
            "prescription_medications": "Prescription Medications",
            "prescription_medications_description": "Anti-inflammatory drops or medications that can help reduce inflammation and improve tear production.",
            "when_to_seek_help": "When to Seek Help",
            "when_to_seek_help_description": "Contact your doctor if you experience persistent eye discomfort, vision changes, or if symptoms worsen despite treatment. Regular monitoring is important for managing dry eye effectively.",
            "disease_information": "Disease Information",
            "vision_measurements": "Vision Measurements",
            "ocular_surface_disease_index": "Ocular Surface Disease Index",
            "osmolarity_example": "e.g., 305",
            "meibography_example": "e.g., 25",
            "tmh_example": "e.g., 0.25",
            "follow_up_reminder": "Follow-up Reminder",
            "ipl_treatment": "IPL Treatment",
            "ipl_description": "Intense Pulsed Light treatment for meibomian gland dysfunction",
            "next_ipl_treatment": "Next IPL Treatment",
            "next_appointments": "Next Appointments",
            "next_treatment_reminder": "Next Treatment Reminder",
            "today": "Today",
            "tomorrow": "Tomorrow",
            "days": "days",
            "set_date": "Set Date",
            "clear_date": "Clear Date",
            "radio_frequency": "Radio Frequency",
            "rf_description": "Radio frequency treatment for meibomian gland dysfunction",
            "next_rf_treatment": "Next RF Treatment",
            "notes": "Notes",
            "mmp9_marker": "MMP9 Marker",
            "inflammation_marker": "Inflammation marker",
            "yes": "Yes",
            "no": "No",
            "note": "Note",
            "optional_note": "Optional note",
            "osdi_description": "The Ocular Surface Disease Index (OSDI) is a 12-item questionnaire designed to assess the severity of dry eye symptoms. It evaluates symptoms related to ocular discomfort, visual function, and environmental triggers.",
            "normal": "Normal",
            "mild": "Mild",
            "moderate": "Moderate",
            "severe": "Severe",
            "elevated": "Elevated",
            "high": "High",
            "low": "Low",
            "very_low": "Very Low",
            "critical": "Critical",
            "normal_range": "Normal range",
            "normal_range_osmolarity": "280-308 mOsm/L",
            "normal_range_meibography": "<25% gland loss",
            "moderate_range": "25-50% gland loss",
            "severe_range": ">50% gland loss",
            "normal_range_tmh": "0.2-0.5 mm",
            "mmp9_description": "MMP9 (Matrix Metalloproteinase-9) is a marker of inflammation in the tear film. Positive results indicate active inflammation that may require anti-inflammatory treatment.",
            "ipl_description_2": "Treatment typically involves 3-4 sessions spaced 2-4 weeks apart for optimal results.",
            "rf_description_2": "Treatment typically involves multiple sessions with maintenance treatments as needed.",
            "right_eye": "Right Eye",
            "left_eye": "Left Eye",
            "none_of_time": "None of the time",
            "some_of_time": "Some of the time",
            "half_of_time": "Half of the time",
            "most_of_time": "Most of the time",
            "all_of_time": "All of the time",
            "dry_eye_assessment": "Dry Eye Assessment",
            "osdi_instructions_1": "Please answer the following questions about your eyes during the past week.",
            "osdi_instructions_2": "For each question, select the response that best describes your experience.",
            "eye_symptoms": "Eye Symptoms",
            "symptom_question_prompt": "Have you experienced any of the following during the past week?",
            "daily_activities": "Daily Activities",
            "function_question_prompt": "Have problems with your eyes limited you in performing any of the following during the past week?",
            "environmental_factors": "Environmental Factors",
            "environmental_question_prompt": "Have your eyes felt uncomfortable in any of the following situations during the past week?",
            "save_answers": "Save Answers",
            "incomplete_questionnaire": "Incomplete Questionnaire",
            "answer_all_questions": "Please answer all questions before saving.",
            "osdi_score_calculation": "OSDI Score Calculation",
            "how_calculated": "How is the OSDI score calculated?",
            "formula": "Formula",
            "sum_of_scores": "Sum of scores",
            "questions_answered": "Questions answered",
            "response_point_scale": "Response Point Scale",
            "severity_classification": "Severity Classification",
            "required_field": "Required field",
            "edit_measurement": "Edit Measurement",
            "edit_measurement_warning": "Are you sure you want to edit this measurement? This action cannot be undone.",
            "done": "Done",
            "continue": "Continue",
            
            // OSDI Questionnaire Questions - English
            "eyes_sensitive_light": "Eyes that are sensitive to light?",
            "eyes_feel_gritty": "Eyes that feel gritty?",
            "painful_sore_eyes": "Painful or sore eyes?",
            "blurred_vision": "Blurred vision?",
            "poor_vision": "Poor vision?",
            "reading": "Reading?",
            "driving_night": "Driving at night?",
            "computer_atm": "Working with a computer or bank machine (ATM)?",
            "watching_tv": "Watching TV?",
            "windy_conditions": "Windy conditions?",
            "low_humidity": "Places or areas with low humidity (very dry)?",
            "air_conditioned": "Areas that are air conditioned?",
            
            // Fuchs' Dystrophy - English
            "about_fuchs_dystrophy": "About Fuchs' Dystrophy",
            "fuchs_dystrophy_description": "Fuchs' dystrophy is a progressive condition affecting the cornea's innermost layer (endothelium). This hereditary condition causes corneal swelling and vision changes.",
            "track_corneal_health": "Track your corneal health measurements to monitor disease progression and treatment effectiveness.",
            "empty_state_fuchs_measurement": "Start tracking your corneal health by adding your first measurement for {eye}",
            "ecd_tooltip_description": "Measures the number of endothelial cells per square millimeter. Lower values indicate more severe disease.",
            "ecd_tooltip_normal_range": "Normal range: 2000-3000 cells/mm².",
            "pachymetry_tooltip_description": "Measures corneal thickness in micrometers (μm). Increased thickness may indicate corneal swelling.",
            "pachymetry_tooltip_normal_range": "Normal range: 500-550 μm.",
            "score_tooltip_description": "Helps track disease progression and treatment effectiveness.",
            "score_tooltip_ranges": "Ranges from: 0 (no symptoms) to 6 (severe symptoms)",
            "vfuchs_tooltip_description": "A comprehensive questionnaire that measures Fuchs' dystrophy symptoms and visual function.",
            "vfuchs_tooltip_note": "Higher scores indicate more severe symptoms and may correlate with disease progression.",
            "ecd_placeholder": "e.g., 2500",
            "pachymetry_placeholder": "e.g., 525",
            "endothelial_cell_density": "Endothelial Cell Density",
            "corneal_thickness": "Corneal Thickness",
            "severity_score": "Severity Score",
            "v_fuchs_questionnaire": "V-Fuchs Questionnaire",
            "visual_function_corneal_health": "Visual Function and Corneal Health Status",
            "cells_per_mm2": "cells/mm²",
            "micrometers": "μm",
            "scale": "scale",
            "normal_range_ecd": "Normal: 2000-3000 cells/mm²",
            "normal_range_pachymetry": "Normal: 500-550 μm",
            "normal_range_score": "0-6 scale",
            "ecd_description": "Measures the number of endothelial cells per square millimeter. Lower values indicate more severe disease.",
            "pachymetry_description": "Measures corneal thickness in micrometers (μm). Increased thickness may indicate corneal swelling.",
            "score_description": "Helps track disease progression and treatment effectiveness.",
            "v_fuchs_description": "A comprehensive questionnaire that measures Fuchs' dystrophy symptoms and visual function.",
            "monitoring": "Monitoring",
            "monitoring_description": "Regular monitoring helps track disease progression and guide treatment decisions. Record measurements after each eye examination to maintain an accurate history.",
            "edit_measurement_message": "You are about to modify an existing measurement. This action cannot be undone. Do you want to continue?",
            "vision_assessment": "Vision Assessment",
            "visual_function_corneal_health_status": "Visual Function and Corneal Health Status",
            "please_complete_evaluation": "Please complete this evaluation to help understand how your vision affects your daily activities. When answering the following questions, consider only vision-related difficulties.",
            "consider_only_vision_difficulties": "If you wear glasses or contacts, answer as if wearing your best correction.",
            "if_you_wear_glasses": "If you wear glasses or contacts, answer as if wearing your best correction.",
            "frequency_assessment": "Frequency Assessment",
            "how_often_experience": "How often do you experience the following difficulties?",
            "difficulty_assessment": "Difficulty Assessment",
            "how_much_difficulty": "How much difficulty do you have with these activities?",
            "never": "Never",
            "rarely": "Rarely",
            "sometimes": "Sometimes",
            "most_of_the_time": "Most of the time",
            "all_of_the_time": "All of the time",
            "no_difficulty": "No difficulty",
            "a_little": "A little",
            "moderate_difficulty": "Moderate",
            "a_lot": "A lot",
            "extreme_difficulty": "Extreme difficulty",
            "total_score": "Total Score:",
            "frequency": "Frequency",
            "difficulty": "Difficulty",
            "source": "Source: Wacker K, Baratz KH, Bourne WM, Patel SV. Patient-Reported Visual Disability in Fuchs Endothelial Corneal Dystrophy Measured by the Visual Function and Corneal Health Status Instrument. Ophthalmology 2018;125(12):1854-1861.",
            "copyright": "© 2019 Mayo Foundation for Medical Education and Research",
            "mc8801": "MC8801-308",
            
            // Fuchs' Dystrophy Questionnaire Questions - English
            "fuchs_q1": "During the past month, my eyesight changed over the course of the day",
            "fuchs_q2": "During the past month, I have had blurred vision that is worst in the morning",
            "fuchs_q3": "During the past month, I have had trouble with focusing that is worst in the morning",
            "fuchs_q4": "At night, bright lights look like a starburst",
            "fuchs_q5": "At night, a bright circle (halo) appears to surround lights, such as street lights",
            "fuchs_q6": "Overall, fine details are becoming harder to see (i.e., leaves on trees)",
            "fuchs_q7": "During the past month, my vision interfered with my daily activities",
            "fuchs_q8": "Reading ordinary print on paper?",
            "fuchs_q9": "Reading text on a screen?",
            "fuchs_q10": "Doing work or hobbies that require you to see well up close?",
            "fuchs_q11": "Reading text on medicine bottles and package inserts?",
            "fuchs_q12": "Seeing the prices of items when shopping?",
            "fuchs_q13": "Seeing what is ahead of you when you enter from daylight into a shady area, such as entering into a parking ramp?",
            "fuchs_q14": "Seeing what is ahead of you when an oncoming car has headlights on at night?",
            "fuchs_q15": "Seeing what is ahead of you when the sun is low during sunrise or sunset?",
            
            // About Us Content
            "mission_text": "To deliver unparalleled ophthalmological care that combines technical precision with a compassionate, patient-centred philosophy.",
            "vision_text": "To set a new standard in eye health by becoming a leader in innovation, education, and personalized treatment for patients across Canada and beyond.",
            "expertise_text": "Our team of ophthalmologists and surgeons bring decades of experience, treating thousands of patients with precision and care. We offer a full range of treatments for dry eyes, corneal and retinal diseases, cataracts, glaucoma, and eyelid disorders.",
            "innovation_description": "We embrace cutting-edge advancements in ophthalmology, ensuring our patients benefit from the most effective and state-of-the-art treatments available.",
            "integrity_description": "Our practice is built on transparency and ethical care, fostering trust and confidence.",
            "excellence_description": "We are committed to delivering the highest standard of care, combining technical expertise with a compassionate, patient-centred approach.",
            "collaboration_description": "Through teamwork and interdisciplinary communication, we provide holistic care tailored to the unique needs of each patient.",
            "compassion_description": "We prioritize patient well-being by creating a supportive, welcoming environment that places comfort and understanding at the forefront of every experience.",
            
            // Corneal Transplant - English
            "about_corneal_transplant": "About Corneal Transplant",
            "corneal_transplant_description": "Track your corneal transplant measurements to monitor graft health, detect rejection, and ensure optimal outcomes.",
            "track_corneal_transplant_measurements": "Track your corneal transplant measurements to monitor graft health, detect rejection, and ensure optimal outcomes.",
            "specular_microscopy": "Specular Microscopy",
            "intraocular_pressure": "Intraocular Pressure",
            "iop": "IOP",
            "no_medication_recorded": "No medication recorded",
            "no_regimen_recorded": "No regimen recorded",
            "add_first_measurement_to_track": "Add your first measurement to track your progress",
            "regraft": "Regraft",
            "second_transplant": "Second transplant",
            "medication_regimen": "Medication Regimen",
            "no_regimen": "No regimen",
            "medication": "Medication",
            "steroid_regimen": "Steroid Regimen",
            "corneal_transplant_info": "About Corneal Transplant",
            "corneal_transplant_surgical_procedure": "A corneal transplant is a surgical procedure that replaces a damaged or diseased cornea with healthy donor tissue. Regular monitoring is crucial for detecting rejection and ensuring graft survival.",
            "iop_description": "Intraocular Pressure",
            "medication_management": "Medication Management",
            "steroid_drops": "Steroid Drops",
            "steroid_drops_description": "Anti-inflammatory medications that help prevent rejection and reduce inflammation. Dosage is typically tapered over time.",
            "antibiotic_drops": "Antibiotic Drops",
            "antibiotic_drops_description": "Prevent infection during the early post-operative period. Usually prescribed for a limited time.",
            "other_medications": "Other Medications",
            "other_medications_description": "Additional medications may be prescribed based on individual needs and risk factors.",
            "warning_signs": "Warning Signs",
            "warning_signs_description": "Contact your doctor immediately if you experience increased eye pain, redness, vision changes, or sensitivity to light, as these may indicate graft rejection or infection.",
            "monitoring_schedule": "Monitoring Schedule",
            "monitoring_schedule_description": "Regular follow-up appointments are essential after corneal transplant. The frequency of visits typically decreases over time, but lifelong monitoring is important for graft health.",
            "add_measurement_title": "Add Measurement",
            "update": "Update",
            "measurements": "Measurements",
            "iop_placeholder": "e.g., 16",
            "ecd_description_short": "Endothelial Cell Density",
            "pachymetry_description_short": "Corneal thickness",
            "iop_description_short": "Normal: 10-21 mmHg",
            "medications_procedures": "Medications & Procedures",
            "add_medication": "Add Medication",
            "medication_type": "Medication Type",
            "medication_name": "Medication Name",
            "set_reminder": "Set Reminder",
            "start_date": "Start Date",
            "pills": "Pills",
            "drops": "Drops",
            "injection": "Injection",
            "every_day": "Every day",
            "monitoring_guidelines": "Monitoring Guidelines",
            "first_three_months": "First 3 months, 6 months, 12 months, then yearly",
            "every_four_six_months": "Every 4–6 months",
            "may_change_frequency": "May change in frequency or type of drop",
            "repeat": "Repeat",
            "custom_frequency": "Custom frequency (e.g., every 3 days)",
            "set_reminder_title": "Set Reminder",
            "medication_reminder": "Medication Reminder",
            "time_to_take_medication": "It's time to take your medication: {medication}",
            "ecd_tooltip": "ECD",
            "pachymetry_tooltip": "Corneal Thickness",
            "iop_tooltip": "Intraocular Pressure",
            "regraft_tooltip": "Regraft",
            "ecd_normal_range": "Normal range: 2000-3000 cells/mm²",
            "pachymetry_normal_range": "Normal range: 500-550 μm",
            "iop_normal_range": "Normal range: 10-21 mmHg",
            "valid_ecd_error": "Please enter a valid ECD value between 100 and 4000 cells/mm²",
            "valid_pachymetry_error": "Please enter a valid pachymetry value between 300 and 700 μm",
            "valid_iop_error": "Please enter a valid IOP value between 5 and 50 mmHg",
            "enter_valid_numbers": "Please enter valid numbers for all measurements",
            "enter_medication_name": "Please enter medication name/notes",
            "enter_custom_frequency": "Please enter custom frequency",
            "enter_custom_reminder_frequency": "Please enter custom reminder frequency",
            "endothelial_cell_density_tooltip": "Number of endothelial cells per square millimeter. Critical for monitoring graft health.",
            "corneal_thickness_tooltip": "Corneal thickness in micrometers. Important for monitoring graft swelling.",
            "intraocular_pressure_tooltip": "Fluid pressure inside the eye. Elevated IOP can damage the graft and optic nerve.",
            "regraft_tooltip_description": "A second corneal transplant performed after a previous graft has failed or been rejected.",
            
            // Units
            "mmhg": "mmHg",
            
            // Medication Regimen
            "daily": "Daily",
            "weekly": "Weekly",
            "monthly": "Monthly",
            "twice_daily": "Twice Daily",
            "three_times_daily": "Three Times Daily",
            "every_other_day": "Every Other Day",
            "as_needed": "As Needed",
            
            // Keratoconus - English
            "about_keratoconus": "About Keratoconus",
            "keratoconus_description": "Track your corneal measurements to monitor keratoconus progression and treatment effectiveness.",
            "track_corneal_measurements": "Track your corneal measurements to monitor keratoconus progression and treatment effectiveness.",
            "k2_values": "K2 Values",
            "k_max_values": "K Max Values",
            "thinnest_pachymetry": "Thinnest Pachymetry",
            "epithelial_thickness": "Epithelial Thickness",
            "thickest_spot": "Thickest Spot",
            "thinnest_spot": "Thinnest Spot",
            "thickest_epithelial_spot": "Thickest Epithelial Spot",
            "thinnest_epithelial_spot": "Thinnest Epithelial Spot",
            "keratoconus_risk_score": "Keratoconus Risk Score",
            "low_risk": "Low Risk: 0-3",
            "high_risk": "High Risk: ≥4",
            "crosslinking_performed": "Crosslinking Performed",
            "k2_tooltip": "K2 measures the steepest corneal curvature. Normal values range from 41-46 diopters. Higher values may indicate more advanced keratoconus.",
            "k_max_tooltip": "K Max is the maximum corneal curvature. Important for tracking progression and determining treatment options.",
            "epithelial_tooltip": "Measures the thickest point of the corneal epithelium. Thinning in certain areas may indicate early keratoconus.",
            "risk_score_tooltip": "A composite score that helps assess the likelihood and severity of keratoconus. Higher scores indicate greater risk.",
            "normal_range_k2": "Normal range: 41-46 diopters.",
            "normal_range_k_max": "Normal range: 41-46 diopters.",
            "normal_range_pachymetry_keratoconus": "Normal thickness: 500-600 μm.",
            "normal_range_epithelial": "Normal range: 50-60 μm.",
            "risk_score_range": "0-10 scale",
            "steepest_corneal_curvature": "Steepest corneal curvature.",
            "maximum_corneal_curvature": "Maximum corneal curvature.",
            "thinnest_point_cornea": "Thinnest point of the cornea.",
            "corneal_epithelium_thickness": "Thickness of the corneal epithelium.",
            "corneal_epithelium_thickest_point": "Corneal epithelium thickest point",
            "corneal_epithelium_thinnest_point": "Corneal epithelium thinnest point",
            "composite_score": "Composite score assessing likelihood and severity of keratoconus.",
            "cylindrical_increase": "Cylindrical Increase ≥1D",
            "vision_loss": "Vision Loss",
            "subjective_vision_loss": "Subjective Vision Loss",
            "cross_linking": "Cross-linking",
            "delete_measurement": "Delete Measurement",
            "delete_measurement_confirmation": "Are you sure you want to delete this measurement? This action cannot be undone.",
            "delete_confirmation": "Delete Measurement",
            "delete_confirmation_message": "Are you sure you want to delete this measurement? This action cannot be undone.",
            "update_measurement": "Update",
            "save_measurement": "Save Measurement",
            "fill_required_fields": "Please fill in all required fields with valid values.",
            "k2_placeholder": "e.g., 49.0",
            "k_max_placeholder": "e.g., 52.5",
            "epithelial_placeholder": "e.g., 60",
            "thickest_epithelial_placeholder": "e.g., 60",
            "thinnest_epithelial_placeholder": "e.g., 40",
            "risk_indicators": "Risk Indicators",
            "procedures": "Procedures",
            "cross_linking_performed": "Cross-Linking Performed",
            "optional_notes": "Optional notes (e.g., symptoms, changes, etc.)",
            "notes_placeholder": "Optional notes (e.g., symptoms, changes, etc.)",
            "select_date_time": "Select Date & Time",
            "keratoconus_info": "About Keratoconus",
            "keratoconus_surgical_procedure": "Keratoconus is a progressive eye condition where the cornea thins and bulges into a cone-like shape, causing distorted vision. Early detection and monitoring are crucial for managing the condition effectively.",
            "cross_linking_cxl": "Cross-Linking (CXL)",
            "cross_linking_description": "A procedure that strengthens the cornea to slow or stop progression. Often recommended for progressive cases.",
            "specialty_contact_lenses": "Specialty Contact Lenses",
            "specialty_lenses_description": "Custom-designed lenses to improve vision and comfort. Options include scleral, hybrid, and specialty soft lenses.",
            "intacs": "Intacs",
            "intacs_description": "Small corneal inserts that help reshape the cornea and improve vision.",
            "keratoconus_information": "Keratoconus Information",
            "diopters": "D",
            "normal_thickness": "Normal thickness",
            "normal_values": "Normal values",
            "higher_values": "Higher values",
            "important_for_tracking": "Important for tracking",
            "thinning_may_indicate": "Thinning may indicate",
            "thinning_in_areas": "Thinning in certain areas",
            "composite_score_description": "A composite score that helps assess the likelihood and severity of keratoconus.",
            "higher_scores": "Higher scores indicate greater risk.",
            "procedure_strengthens": "A procedure that strengthens the cornea to slow or stop progression.",
            "custom_designed_lenses": "Custom-designed lenses to improve vision and comfort.",
            "small_corneal_inserts": "Small corneal inserts that help reshape the cornea and improve vision.",
            "contact_doctor": "Contact your doctor if you experience",
            "rapid_changes": "rapid changes in vision",
            "increased_sensitivity": "increased light sensitivity",
            "difficulty_with_lenses": "difficulty with contact lens wear",
            "may_indicate_progression": "as these may indicate progression.",
            "increase_in_astigmatism": "Increase in astigmatism",
            "patient_reported_decrease_in_vision": "Patient-reported decrease in vision",
            
            // Glaucoma - English
            "about_glaucoma": "About Glaucoma",
            "glaucoma_description": "Track your glaucoma measurements to monitor intraocular pressure, visual field changes, and other important parameters.",
            "retinal_nerve_fiber_layer": "Retinal Nerve Fiber Layer (RNFL)",
            "rnfl": "RNFL",
            "rnfl_superior": "RNFL Superior",
            "rnfl_inferior": "RNFL Inferior",
            "macular_gcc": "Macular GCC",
            "mean_defect": "Mean Defect (MD)",
            "md": "MD",
            "pattern_standard_deviation": "Pattern Standard Deviation (PSD)",
            "psd": "PSD",
            "visual_field_change": "Visual Field Change",
            "rnfl_change": "RNFL Change",
            "family_history": "Family History",
            "lasik_surgery": "LASIK Surgery",
            "new_eye_drops": "New Eye Drops",
            "eye_drops_details": "Eye Drops Details",
            "medication_procedures": "Medication & Procedures",
            "glaucoma_information": "Glaucoma Information",
            "visual_field_parameters": "Visual Field Parameters",
            "oct_measurements": "OCT Measurements",
            "risk_factors": "Risk Factors",
            "md_tooltip": "Measures the average sensitivity loss across the visual field. Progressively negative values may indicate worsening glaucoma.",
            "psd_tooltip": "Measures the irregularity of visual field loss. Increasing PSD may indicate glaucoma progression.",
            "rnfl_tooltip": "Measures the thickness of nerve fibers around the optic nerve. Thinning RNFL indicates glaucoma progression.",
            "gcc_tooltip": "Measures the thickness of ganglion cells in the macula. Thinning GCC may indicate early glaucoma damage.",
            "normal_range_iop": "Normal range: 10-21 mmHg.",
            "normal_range_md": "Normal range: -2 to +2 dB.",
            "normal_range_psd": "Normal range: 0-2 dB.",
            "normal_range_rnfl": "Normal range: 80-120 μm.",
            "normal_range_gcc": "Normal range: 70-100 μm.",
            "md_description": "Mean Defect",
            "psd_description": "Pattern Standard Deviation",
            "rnfl_description": "Retinal Nerve Fiber layer thickness",
            "gcc_description": "Macular ganglion cell complex thickness",
            "visual_field_change_description": "Visual field change detected",
            "rnfl_change_description": "RNFL change detected",
            "family_history_description": "Having a family history of glaucoma increases your risk.",
            "lasik_surgery_description": "Previous LASIK surgery can affect IOP measurements and is an important factor to track.",
            "new_eye_drops_description": "New eye drops prescribed",
            "eye_drops_details_description": "Details about prescribed eye drops",
            "md_placeholder": "e.g., -2.5",
            "psd_placeholder": "e.g., 1.8",
            "rnfl_placeholder": "e.g., 85",
            "rnfl_superior_placeholder": "e.g., 110",
            "rnfl_inferior_placeholder": "e.g., 120",
            "gcc_placeholder": "e.g., 85",
            "eye_drops_placeholder": "e.g., Latanoprost",
            "rnfl_superotemporal": "RNFL Superotemporal",
            "rnfl_inferotemporal": "RNFL Inferotemporal",
            "superior_quadrant_thickness": "Superior quadrant thickness",
            "inferior_quadrant_thickness": "Inferior quadrant thickness",
            "macular_ganglion_cell_complex": "Macular Ganglion Cell Complex (GCC)",
            "ganglion_cell_complex_thickness": "Macular ganglion cell complex thickness",
            "average_sensitivity_loss": "Measures the average sensitivity loss across the visual field. Progressively negative values may indicate worsening glaucoma.",
            "irregularity_visual_field_loss": "Measures the irregularity of visual field loss. Increasing PSD may indicate glaucoma progression.",
            "thickness_nerve_fibers": "Measures the thickness of nerve fibers around the optic nerve. Thinning RNFL indicates glaucoma progression. Superior and inferior quadrants are particularly important.",
            "thickness_ganglion_cells": "Measures the thickness of ganglion cells in the macula. Thinning GCC may indicate early glaucoma damage.",
            "elevated_iop_risk_factor": "Elevated IOP is a major risk factor for glaucoma.",
            "progressively_negative_values": "Progressively negative values may indicate worsening glaucoma.",
            "increasing_psd_progression": "Increasing PSD may indicate glaucoma progression.",
            "rnfl_thinning_progression": "Thinning RNFL indicates glaucoma progression.",
            "gcc_thinning_early_damage": "Thinning GCC may indicate early glaucoma damage.",
            "family_history_increases_risk": "Having a family history of glaucoma increases your risk.",
            "lasik_affects_iop_measurements": "Previous LASIK surgery can affect IOP measurements and is an important factor to track.",
            "contact_doctor_immediately": "Contact your doctor immediately if you experience",
            "vision_changes_eye_pain": "vision changes, eye pain, severe headaches, or halos around lights",
            "severe_headaches_halos": "severe headaches, or halos around lights",
            "acute_glaucoma_episode": "as these may indicate an acute glaucoma episode.",
            "db": "dB",
            
            // Retinal Injections - English
            "about_retina_injections": "About Retina Injections",
            "retina_injections_description": "Track your retina injection treatments, vision, and CRT to monitor your progress and treatment effectiveness.",
            "track_retina_injection_treatments": "Track your retina injection treatments, vision, and CRT to monitor your progress and treatment effectiveness.",
            "injection_calendar": "Injection Calendar",
            "central_retinal_thickness": "Central Retinal Thickness",
            "crt_measurement": "CRT measurement",
            "visual_acuity": "Visual Acuity (20/y)",
            "vision_measurement": "Vision measurement",
            "upcoming_follow_up": "Upcoming follow-up",
            "injection_details": "Injection Details",
            "no_injection_details_found": "No injection details found",
            "no_recorded_injections_for_date": "There are no recorded injections for this date.",
            "injection_time": "Injection Time",
            "next_appointment": "Next Appointment",
            "not_set": "Not set",
            "new_injection": "New Injection",
            "retina_injection_info": "Retina Injection Info",
            "retina_injections_used_to_treat": "Retina injections are used to treat several retinal diseases. They deliver medication directly to the back of the eye to reduce swelling, prevent vision loss, and improve outcomes.",
            "key_measurements_retina": "Key Measurements",
            "central_retina_thickness_crt": "Central Retina Thickness (CRT)",
            "thickness_central_retina": "Thickness of the central retina. Higher values may indicate swelling.",
            "higher_values_may_indicate": "Higher values may indicate swelling.",
            "vision_visual_acuity": "Vision (Visual Acuity)",
            "tracks_vision_changes": "Tracks vision changes over time.",
            "injection_timeline": "Injection Timeline",
            "dates_medications_injection": "Dates and medications for each injection.",
            "new_injection_indicates": "New Injection",
            "when_new_medication": "Indicates when a new medication starts.",
            "follow_up_reminders": "Follow-Up Reminders",
            "helps_remember_appointments": "Helps you remember upcoming appointments.",
            "treatment_goals": "Treatment Goals",
            "reduce_retinal_swelling": "• Reduce retinal swelling",
            "maintain_improve_vision": "• Maintain or improve vision",
            "prevent_further_vision_loss": "• Prevent further vision loss",
            "minimize_treatment_burden": "• Minimize treatment burden",
            "when_to_seek_help_retina": "When to Seek Help",
            "contact_doctor_sudden_vision": "Contact your doctor if you experience sudden vision loss, increased floaters, flashes of light, or eye pain.",
            "sudden_vision_loss": "sudden vision loss",
            "increased_floaters": "increased floaters",
            "flashes_of_light": "flashes of light",
            "eye_pain": "eye pain",
            "retina_injection": "Retina Injection",
            "edit_injection": "Edit Injection",
            "add_injection": "Add Injection",
            "injection_details_title": "Injection Details",
            "new_medication_question": "New Medication?",
            "first_time_using_medication": "First time using this medication?",
            "injection_medication": "Injection medication",
            "vision_measurements_title": "Vision & Measurements",
            "best_corrected_vision": "Best Corrected Vision",
            "visual_acuity_description": "Visual acuity",
            "central_retinal_thickness_title": "Central Retinal Thickness",
            "crt_measurement_description": "CRT measurement",
            "follow_up_reminder_title": "Follow-Up Reminder",
            "clear": "Clear",
            "set": "Set",
            "next_appointment_colon": "Next appointment:",
            "follow_up_appointment": "Follow-up appointment",
            "notes_title": "Notes",
            "optional_notes_retina": "Optional notes (e.g., symptoms, changes, etc.)",
            "edit_injection_warning": "Edit Injection",
            "modify_existing_injection": "You are about to modify an existing injection. This action cannot be undone. Do you want to continue?",
            "action_cannot_be_undone": "This action cannot be undone. Do you want to continue?",
            "do_you_want_to_continue": "Do you want to continue?",
            "medication_tooltip": "Medication",
            "medication_used_for_injection": "The medication used for the injection.",
            "common_medications_include": "Common medications include Avastin, Lucentis, and Eylea.",
            "avastin_lucentis_eylea": "Avastin, Lucentis, and Eylea.",
            "new_medications_should_be_tracked": "New medications should be tracked to monitor effectiveness.",
            "best_vision_achievable": "Best vision achievable with glasses or contact lenses. Measured in Snellen notation.",
            "measured_in_snellen_notation": "Measured in Snellen notation (e.g., 20/20).",
            "lower_numbers_indicate_better": "Lower numbers indicate better vision.",
            "thickness_central_retina_tooltip": "Central Retinal Thickness",
            "high_crt_values_may_indicate": "Thickness of the central retina. High CRT values may indicate swelling or fluid accumulation.",
            "swelling_fluid_accumulation": "swelling or fluid accumulation.",
            "normal_range_crt": "Normal range: 250-350 μm.",
            "set_reminder_next_appointment": "Set a reminder for your next follow-up appointment to stay on track with your treatment plan.",
            "stay_on_track_treatment": "to stay on track with your treatment plan.",
            "regular_monitoring_essential": "Regular monitoring is essential for optimal outcomes.",
            "optimal_outcomes": "optimal outcomes.",
            "please_enter_valid_crt": "Please enter a valid CRT value.",
            "must_be_logged_in_add": "You must be logged in to add measurements",
            "must_be_logged_in_view": "You must be logged in to view measurements",
            "must_be_logged_in_delete": "You must be logged in to delete measurements",
            "invalid_measurement_id": "Invalid measurement ID",
            "failed_to_fetch_measurements": "Failed to fetch measurements:",
            "failed_to_add_measurement": "Failed to add measurement:",
            "failed_to_delete_measurement": "Failed to delete measurement:",
            
            // Date and Time
            "reminder_date": "Reminder Date",
        ],
        .french: [
            // Common
            "home": "Accueil",
            "profile": "Profil",
            "about": "À propos",
            "settings": "Paramètres",
            "language": "Langue",
            "english": "English",
            "french": "Français",
            "save": "Enregistrer",
            "cancel": "Annuler",
            "edit": "Modifier",
            "delete": "Supprimer",
            "confirm": "Confirmer",
            "ok": "OK",
            "error": "Erreur",
            "success": "Succès",
            
            // Profile
            "account_settings": "Paramètres du compte",
            "change_password": "Changer le mot de passe",
            "sign_out": "Se déconnecter",
            "delete_account": "Supprimer le compte",
            "reset_onboarding": "Réinitialiser l'introduction",
            "privacy_policy": "Politique de confidentialité",
            "current_password": "Mot de passe actuel",
            "new_password": "Nouveau mot de passe",
            "confirm_new_password": "Confirmer le nouveau mot de passe",
            "password_changed": "Mot de passe modifié",
            "password_changed_message": "Votre mot de passe a été modifié avec succès.",
            "delete_account_confirmation": "Supprimer le compte",
            "delete_account_message": "Êtes-vous sûr de vouloir supprimer votre compte ? Cette action ne peut pas être annulée.",
            
            // About Us
            "about_us": "À propos de nous",
            "visionary_approach": "Une approche visionnaire des soins",
            "our_mission": "Notre mission",
            "our_vision": "Notre vision",
            "our_core_values": "Nos valeurs fondamentales",
            "our_expertise": "Notre expertise",
            "contact_us": "Nous contacter",
            "opening_hours": "Heures d'ouverture",
            "saturday_to_sunday": "Samedi au dimanche",
            "monday_to_friday": "Lundi au vendredi",
            "closed": "Fermé",
            "visit_our_website": "Visitez notre site web",
            "trust_your_vision": "Confiez votre vision à un niveau de soins supérieur.",
            
            // Values
            "innovation": "Innovation",
            "integrity": "Intégrité",
            "excellence": "Excellence",
            "collaboration": "Collaboration",
            "compassion": "Compassion",
            
            // Home
            "welcome_to_haute_vision": "Bienvenue chez Haute Vision !",
            "hello": "Bonjour",
            
            // My Health
            "my_health": "Ma Santé",
            "eye_conditions": "Affections Oculaires",
            "corneal_health": "Santé Cornéenne",
            "glaucoma": "Glaucome",
            "retinal_injections": "Injections Rétiniennes",
            "dry_eye": "Œil Sec",
            "fuchs_dystrophy": "Dystrophie de Fuchs",
            "corneal_transplant": "Greffe de Cornée",
            "keratoconus": "Kératocône",
            "coming_soon": "Bientôt Disponible",
            "under_development": "Cette fonctionnalité est en cours de développement et sera disponible dans une future mise à jour.",
            "on_site_parking": "Stationnement sur place disponible (1 heure gratuite)",
            
            // Privacy Policy
            "privacy_policy_title": "Politique de Confidentialité",
            "last_updated": "Dernière mise à jour : 2025-03-03",
            "welcome_to_haute_vision_app": "Bienvenue dans l'application iOS de la Clinique d'Ophtalmologie Haute Vision",
            "privacy_policy_intro": "Votre confidentialité est importante pour nous. Cette Politique de Confidentialité explique comment nous collectons, utilisons, divulguons et protégeons vos informations lorsque vous visitez notre site web www.hautevision.com. Veuillez lire cette politique attentivement. Si vous n'êtes pas d'accord avec les termes de cette Politique de Confidentialité, veuillez ne pas accéder au site ou procéder avec l'application iOS.",
            "information_we_collect": "Informations que Nous Collectons",
            "information_we_collect_desc": "Nous pouvons collecter des informations personnelles que vous nous fournissez directement lorsque vous : remplissez un formulaire de contact, communiquez avec nous par e-mail ou d'autres moyens, ou participez à certaines activités sur notre site web.",
            "personal_information_we_collect": "Les informations personnelles que nous collectons peuvent inclure : Nom complet ; Adresse e-mail ; Numéro de téléphone ; Informations médicales pertinentes à votre demande.",
            "automatically_collected_information": "Informations Collectées Automatiquement",
            "automatically_collected_information_desc": "Lorsque vous visitez notre site web, nous pouvons également collecter certaines informations automatiquement, telles que : Adresse IP ; Type de navigateur ; Pages visitées et temps passé sur notre site ; Site web de référence.",
            "how_we_use_your_information": "Comment Nous Utilisons Vos Informations",
            "how_we_use_your_information_desc": "Nous utilisons les informations que nous collectons à diverses fins, notamment pour : planifier et confirmer les rendez-vous ; répondre à vos demandes ; améliorer notre site web et nos services ; vous envoyer du matériel promotionnel, si vous avez opté pour cela ; et respecter les obligations légales.",
            "sharing_your_information": "Partage de Vos Informations",
            "sharing_your_information_desc": "Nous ne vendons ni ne louons vos informations personnelles à des tiers. Cependant, nous pouvons partager vos informations avec des prestataires de services qui nous aident à exploiter notre site web et à gérer les rendez-vous, et avec les autorités légales si la loi l'exige.",
            "data_security": "Sécurité des Données",
            "data_security_desc": "Nous mettons en œuvre des mesures techniques et organisationnelles appropriées pour protéger vos données personnelles contre l'accès non autorisé, la divulgation, l'altération et la destruction.",
            "your_rights": "Vos Droits",
            "your_rights_desc": "Vous avez le droit d'accéder, de corriger et de retirer vos données personnelles de notre service. Vous pouvez également demander la suppression de vos données, sous réserve des exigences légales. Si vous souhaitez exercer l'un de ces droits, veuillez nous contacter à admin@hautevision.com.",
            "cookies_and_tracking": "Cookies et Technologies de Suivi",
            "cookies_and_tracking_desc": "Notre site web peut utiliser des cookies et des technologies de suivi similaires pour améliorer votre expérience de navigation. Vous pouvez configurer votre navigateur pour refuser les cookies ou vous alerter lorsque des cookies sont envoyés.",
            "third_party_links": "Liens Tiers",
            "third_party_links_desc": "Notre site web peut contenir des liens vers des sites web tiers. Nous ne sommes pas responsables des pratiques de confidentialité de ces sites web.",
            "contact_us_privacy": "Nous Contacter",
            "contact_us_privacy_desc": "Si vous avez des questions concernant cette Politique de Confidentialité, veuillez nous contacter à :",
            "changes_to_privacy_policy": "Modifications de Cette Politique de Confidentialité",
            "changes_to_privacy_policy_desc": "Nous pouvons mettre à jour cette Politique de Confidentialité de temps à autre. La version mise à jour sera indiquée par une date \"Dernière mise à jour\" mise à jour et sera effective dès qu'elle sera accessible.",
            "consent_to_privacy_policy": "En utilisant notre site web, vous consentez aux termes de cette Politique de Confidentialité.",
            "thank_you_for_trusting": "Merci de faire confiance à la Clinique d'Ophtalmologie Haute Vision avec vos informations personnelles",
            
            // Edit Profile
            "edit_profile": "Modifier le Profil",
            "full_name": "Nom Complet",
            "email_address": "Adresse E-mail",
            "enter_your_name": "Entrez votre nom",
            "change": "Modifier",
            "profile_updated_successfully": "Votre profil a été mis à jour avec succès.",
            "change_email": "Changer l'E-mail",
            "new_email": "Nouvel E-mail",
            "send_verification_email": "Envoyer l'E-mail de Vérification",
            "verification_email_sent": "E-mail de Vérification Envoyé",
            "verification_email_sent_message": "Un e-mail de vérification a été envoyé à {email}. Veuillez vérifier votre e-mail et suivre les instructions pour terminer le changement d'e-mail.",
            "update_password": "Mettre à Jour le Mot de Passe",
            "password_updated_successfully": "Votre mot de passe a été modifié avec succès.",
            
            // Common UI Elements
            "time": "Heure",
            
            // Dry Eye
            "about_dry_eye": "À Propos de l'Œil Sec",
            "track_dry_eye_measurements": "Suivez vos mesures d'œil sec pour surveiller les symptômes et l'efficacité du traitement.",
            "follow_us_instagram": "@dryeyeinstitutemtl",
            "follow_us": "Suivez-nous!",
            "add_measurement": "Ajouter une Mesure",
            "measurements_over_time": "Mesures au Fil du Temps",
            "osdi_questionnaire": "Questionnaire OSDI",
            "symptom_score": "Score de Symptômes",
            "osmolarity": "Osmolarité",
            "tear_film_osmolarity": "Osmolarité du Film Lacrymal",
            "meibography": "Méibographie",
            "gland_loss_percentage": "Pourcentage de Perte de Glandes",
            "tear_meniscus_height": "Hauteur du Ménisque Lacrymal",
            "tmh_measurement": "Mesure TMH",
            "measurement_history": "Historique des Mesures",
            "no_measurements": "Aucune Mesure",
            "add_first_measurement": "Ajoutez votre première mesure pour suivre vos progrès",
            "start_tracking": "Commencer le Suivi",
            "no_data": "Aucune donnée",
            "add_first_measurement_to_start": "Ajoutez votre première mesure pour commencer le suivi",
            "edited": "Modifié",
            "osdi_score": "Score OSDI",
            "score": "score",
            "mosm_l": "mOsm/L",
            "percent": "%",
            "ipl": "IPL",
            "rf": "RF",
            "mm": "mm",
            "mmp9_positive": "MMP9 Positif",
            "about_dry_eye_syndrome": "À Propos du Syndrome de l'Œil Sec",
            "dry_eye_syndrome_description": "Le syndrome de l'œil sec est une affection courante qui survient lorsque vos larmes ne peuvent pas fournir une lubrification adéquate à vos yeux. Il peut être causé par une diminution de la production de larmes ou une évaporation accrue des larmes.",
            "key_measurements": "Mesures Clés",
            "dry_eye_questionnaire_description": "Un questionnaire standardisé qui mesure les symptômes de l'œil sec. Des scores plus élevés indiquent des symptômes plus graves.",
            "osmolarity_description": "Mesure la concentration de particules dans les larmes. Une osmolarité élevée indique une instabilité du film lacrymal.",
            "meibography_description": "Mesure le pourcentage de glandes de Meibomius qui sont perdues ou non fonctionnelles. Des pourcentages plus élevés indiquent une dysfonction plus grave des glandes.",
            "tmh_description": "Mesure la hauteur du film lacrymal au niveau de la marge de la paupière inférieure. Des valeurs plus faibles peuvent indiquer un volume de larmes réduit.",
            "mmp9_status_description": "Un marqueur d'inflammation dans le film lacrymal. Des résultats positifs indiquent une inflammation active nécessitant un traitement.",
            "treatment_options": "Options de Traitement",
            "artificial_tears": "Larmes Artificielles",
            "artificial_tears_description": "Gouttes oculaires lubrifiantes qui complètent les larmes naturelles. Disponibles en diverses formulations pour différents niveaux de gravité.",
            "warm_compresses": "Compresses Chaudes",
            "warm_compresses_description": "Aide à déboucher les glandes de Meibomius et améliore la sécrétion d'huile. Recommandé quotidiennement pour l'entretien.",
            "ipl_rf_treatments": "Traitements IPL/RF",
            "ipl_rf_treatments_description": "Traitements avancés qui améliorent la fonction des glandes de Meibomius et réduisent l'inflammation. Généralement effectués en série de séances.",
            "prescription_medications": "Médicaments sur Ordonnance",
            "prescription_medications_description": "Gouttes ou médicaments anti-inflammatoires qui peuvent aider à réduire l'inflammation et améliorer la production de larmes.",
            "when_to_seek_help": "Quand Demander de l'Aide",
            "when_to_seek_help_description": "Contactez votre médecin si vous ressentez un inconfort oculaire persistant, des changements de vision, ou si les symptômes s'aggravent malgré le traitement. Une surveillance régulière est importante pour gérer efficacement l'œil sec.",
            "disease_information": "Informations sur la Maladie",
            "vision_measurements": "Mesures de Vision",
            "ocular_surface_disease_index": "Indice de Maladie de la Surface Oculaire",
            "osmolarity_example": "ex., 305",
            "meibography_example": "ex., 25",
            "tmh_example": "ex., 0,25",
            "follow_up_reminder": "Rappel de Suivi",
            "ipl_treatment": "Traitement IPL",
            "ipl_description": "Traitement par lumière pulsée intense pour la dysfonction des glandes de Meibomius",
            "next_ipl_treatment": "Prochain Traitement IPL",
            "next_appointments": "Prochains Rendez-vous",
            "next_treatment_reminder": "Rappel de Traitement",
            "today": "Aujourd'hui",
            "tomorrow": "Demain",
            "days": "jours",
            "set_date": "Définir la Date",
            "clear_date": "Effacer la Date",
            "radio_frequency": "Fréquence Radio",
            "rf_description": "Traitement par fréquence radio pour la dysfonction des glandes de Meibomius",
            "next_rf_treatment": "Prochain Traitement RF",
            "notes": "Notes",
            "mmp9_marker": "Marqueur MMP9",
            "inflammation_marker": "Marqueur d'inflammation",
            "yes": "Oui",
            "no": "Non",
            "note": "Note",
            "optional_note": "Note optionnelle",
            "osdi_description": "L'Indice de Maladie de la Surface Oculaire (OSDI) est un questionnaire de 12 éléments conçu pour évaluer la gravité des symptômes de l'œil sec. Il évalue les symptômes liés à l'inconfort oculaire, à la fonction visuelle et aux déclencheurs environnementaux.",
            "normal": "Normal",
            "mild": "Faible",
            "moderate": "Modéré",
            "severe": "Sévère",
            "elevated": "Élevé",
            "high": "Élevé",
            "low": "Faible",
            "very_low": "Très Faible",
            "critical": "Critique",
            "normal_range": "Plage normale",
            "normal_range_osmolarity": "280-308 mOsm/L",
            "normal_range_meibography": "<25% de perte de glandes",
            "moderate_range": "25-50% de perte de glandes",
            "severe_range": ">50% de perte de glandes",
            "normal_range_tmh": "0,2-0,5 mm",
            "mmp9_description": "MMP9 (Matrix Metalloproteinase-9) est un marqueur d'inflammation dans le film lacrymal. Des résultats positifs indiquent une inflammation active qui peut nécessiter un traitement anti-inflammatoire.",
            "ipl_description_2": "Le traitement implique généralement 3-4 séances espacées de 2-4 semaines pour des résultats optimaux.",
            "rf_description_2": "Le traitement implique généralement plusieurs séances avec des traitements d'entretien selon les besoins.",
            "right_eye": "Œil Droit",
            "left_eye": "Œil Gauche",
            "none_of_time": "Jamais",
            "some_of_time": "Parfois",
            "half_of_time": "La moitié du temps",
            "most_of_time": "La plupart du temps",
            "all_of_time": "Tout le temps",
            "dry_eye_assessment": "Évaluation de l'Œil Sec",
            "osdi_instructions_1": "Veuillez répondre aux questions suivantes concernant vos yeux au cours de la semaine dernière.",
            "osdi_instructions_2": "Pour chaque question, sélectionnez la réponse qui décrit le mieux votre expérience.",
            "eye_symptoms": "Symptômes Oculaires",
            "symptom_question_prompt": "Avez-vous ressenti l'un des éléments suivants au cours de la semaine dernière ?",
            "daily_activities": "Activités Quotidiennes",
            "function_question_prompt": "Des problèmes avec vos yeux vous ont-ils limité dans l'exécution de l'une des activités suivantes au cours de la semaine dernière ?",
            "environmental_factors": "Facteurs Environnementaux",
            "environmental_question_prompt": "Vos yeux se sont-ils sentis inconfortables dans l'une des situations suivantes au cours de la semaine dernière ?",
            "save_answers": "Enregistrer les Réponses",
            "incomplete_questionnaire": "Questionnaire Incomplet",
            "answer_all_questions": "Veuillez répondre à toutes les questions avant d'enregistrer.",
            "osdi_score_calculation": "Calcul du Score OSDI",
            "how_calculated": "Comment le score OSDI est-il calculé ?",
            "formula": "Formule",
            "sum_of_scores": "Somme des scores",
            "questions_answered": "Questions répondues",
            "response_point_scale": "Échelle de Points de Réponse",
            "severity_classification": "Classification de Gravité",
            "required_field": "Champ requis",
            "edit_measurement": "Modifier la Mesure",
            "edit_measurement_warning": "Êtes-vous sûr de vouloir modifier cette mesure ? Cette action ne peut pas être annulée.",
            "done": "Terminé",
            "continue": "Continuer",
            
            // OSDI Questionnaire Questions - French
            "eyes_sensitive_light": "Des yeux sensibles à la lumière ?",
            "eyes_feel_gritty": "Des yeux qui semblent granuleux ?",
            "painful_sore_eyes": "Des yeux douloureux ou endoloris ?",
            "blurred_vision": "Une vision floue ?",
            "poor_vision": "Une mauvaise vision ?",
            "reading": "La lecture ?",
            "driving_night": "Conduire la nuit ?",
            "computer_atm": "Travailler avec un ordinateur ou un guichet automatique (GAB) ?",
            "watching_tv": "Regarder la télévision ?",
            "windy_conditions": "Des conditions venteuses ?",
            "low_humidity": "Des endroits ou des zones à faible humidité (très secs) ?",
            "air_conditioned": "Des zones climatisées ?",
            
            // Fuchs' Dystrophy - French
            "about_fuchs_dystrophy": "À Propos de la Dystrophie de Fuchs",
            "fuchs_dystrophy_description": "La dystrophie de Fuchs est une affection progressive qui affecte la couche la plus interne de la cornée (endothélium). Cette affection héréditaire provoque un gonflement cornéen et des changements de vision.",
            "track_corneal_health": "Suivez vos mesures de santé cornéenne pour surveiller la progression de la maladie et l'efficacité du traitement.",
            "empty_state_fuchs_measurement": "Commencez à suivre votre santé cornéenne en ajoutant votre première mesure pour {eye}",
            "ecd_tooltip_description": "Mesure le nombre de cellules endothéliales par millimètre carré. Des valeurs plus faibles indiquent une maladie plus grave.",
            "ecd_tooltip_normal_range": "Plage normale : 2000-3000 cellules/mm².",
            "pachymetry_tooltip_description": "Mesure l'épaisseur cornéenne en micromètres (μm). Une épaisseur accrue peut indiquer un gonflement cornéen.",
            "pachymetry_tooltip_normal_range": "Plage normale : 500-550 μm.",
            "score_tooltip_description": "Aide à suivre la progression de la maladie et l'efficacité du traitement.",
            "score_tooltip_ranges": "Va de : 0 (aucun symptôme) à 6 (symptômes graves)",
            "vfuchs_tooltip_description": "Un questionnaire complet qui mesure les symptômes de la dystrophie de Fuchs et la fonction visuelle.",
            "vfuchs_tooltip_note": "Des scores plus élevés indiquent des symptômes plus graves et peuvent être corrélés à la progression de la maladie.",
            "ecd_placeholder": "ex., 2500",
            "pachymetry_placeholder": "ex., 525",
            "endothelial_cell_density": "Densité Cellulaire Endothéliale",
            "corneal_thickness": "Épaisseur Cornéenne",
            "severity_score": "Score de Gravité",
            "v_fuchs_questionnaire": "Questionnaire V-Fuchs",
            "visual_function_corneal_health": "Fonction Visuelle et État de Santé Cornéenne",
            "cells_per_mm2": "cellules/mm²",
            "micrometers": "μm",
            "scale": "échelle",
            "normal_range_ecd": "Normal : 2000-3000 cellules/mm²",
            "normal_range_pachymetry": "Normal : 500-550 μm",
            "normal_range_score": "Échelle 0-6",
            "ecd_description": "Mesure le nombre de cellules endothéliales par millimètre carré. Des valeurs plus faibles indiquent une maladie plus grave.",
            "pachymetry_description": "Mesure l'épaisseur cornéenne en micromètres (μm). Une épaisseur accrue peut indiquer un gonflement cornéen.",
            "score_description": "Aide à suivre la progression de la maladie et l'efficacité du traitement.",
            "v_fuchs_description": "Un questionnaire complet qui mesure les symptômes de la dystrophie de Fuchs et la fonction visuelle.",
            "monitoring": "Surveillance",
            "monitoring_description": "Une surveillance régulière aide à suivre la progression de la maladie et à guider les décisions de traitement. Enregistrez les mesures après chaque examen oculaire pour maintenir un historique précis.",
            "edit_measurement_message": "Vous êtes sur le point de modifier une mesure existante. Cette action ne peut pas être annulée. Voulez-vous continuer ?",
            "vision_assessment": "Évaluation Visuelle",
            "visual_function_corneal_health_status": "Fonction Visuelle et État de Santé Cornéenne",
            "please_complete_evaluation": "Veuillez compléter cette évaluation pour aider à comprendre comment votre vision affecte vos activités quotidiennes. Lorsque vous répondez aux questions suivantes, considérez uniquement les difficultés liées à la vision.",
            "consider_only_vision_difficulties": "Si vous portez des lunettes ou des lentilles, répondez comme si vous portiez votre meilleure correction.",
            "if_you_wear_glasses": "Si vous portez des lunettes ou des lentilles, répondez comme si vous portiez votre meilleure correction.",
            "frequency_assessment": "Évaluation de la Fréquence",
            "how_often_experience": "À quelle fréquence ressentez-vous les difficultés suivantes ?",
            "difficulty_assessment": "Évaluation de la Difficulté",
            "how_much_difficulty": "Quelle difficulté avez-vous avec ces activités ?",
            "never": "Jamais",
            "rarely": "Rarement",
            "sometimes": "Parfois",
            "most_of_the_time": "La plupart du temps",
            "all_of_the_time": "Tout le temps",
            "no_difficulty": "Aucune difficulté",
            "a_little": "Un peu",
            "moderate_difficulty": "Modérée",
            "a_lot": "Beaucoup",
            "extreme_difficulty": "Difficulté extrême",
            "total_score": "Score Total :",
            "frequency": "Fréquence",
            "difficulty": "Difficulté",
            "source": "Source : Wacker K, Baratz KH, Bourne WM, Patel SV. Patient-Reported Visual Disability in Fuchs Endothelial Corneal Dystrophy Measured by the Visual Function and Corneal Health Status Instrument. Ophthalmology 2018;125(12):1854-1861.",
            "copyright": "© 2019 Mayo Foundation for Medical Education and Research",
            "mc8801": "MC8801-308",
            
            // Fuchs' Dystrophy Questionnaire Questions - French
            "fuchs_q1": "Au cours du mois dernier, ma vue a changé au cours de la journée",
            "fuchs_q2": "Au cours du mois dernier, j'ai eu une vision floue qui est pire le matin",
            "fuchs_q3": "Au cours du mois dernier, j'ai eu des difficultés de mise au point qui sont pires le matin",
            "fuchs_q4": "La nuit, les lumières vives ressemblent à une étoile",
            "fuchs_q5": "La nuit, un cercle lumineux (halo) apparaît autour des lumières, comme les lampadaires",
            "fuchs_q6": "En général, les détails fins deviennent plus difficiles à voir (par exemple, les feuilles sur les arbres)",
            "fuchs_q7": "Au cours du mois dernier, ma vision a interféré avec mes activités quotidiennes",
            "fuchs_q8": "Lire du texte ordinaire sur papier ?",
            "fuchs_q9": "Lire du texte sur un écran ?",
            "fuchs_q10": "Faire du travail ou des passe-temps qui nécessitent de bien voir de près ?",
            "fuchs_q11": "Lire le texte sur les bouteilles de médicaments et les notices ?",
            "fuchs_q12": "Voir les prix des articles lors des achats ?",
            "fuchs_q13": "Voir ce qui est devant vous lorsque vous passez de la lumière du jour à une zone ombragée, comme entrer dans un parking ?",
            "fuchs_q14": "Voir ce qui est devant vous lorsqu'une voiture qui arrive a ses phares allumés la nuit ?",
            "fuchs_q15": "Voir ce qui est devant vous lorsque le soleil est bas pendant le lever ou le coucher du soleil ?",
            
            // About Us Content
            "mission_text": "Offrir des soins ophtalmologiques inégalés qui allient précision technique et philosophie de soins compatissante centrée sur le patient.",
            "vision_text": "Établir une nouvelle norme en santé oculaire en devenant un leader en innovation, éducation et traitement personnalisé pour les patients à travers le Canada et au-delà.",
            "expertise_text": "Notre équipe d'ophtalmologistes et de chirurgiens apporte des décennies d'expérience, traitant des milliers de patients avec précision et soin. Nous offrons une gamme complète de traitements pour les yeux secs, les maladies cornéennes et rétiniennes, les cataractes, le glaucome et les troubles des paupières.",
            "innovation_description": "Nous adoptons les avancées de pointe en ophtalmologie, garantissant que nos patients bénéficient des traitements les plus efficaces et les plus modernes disponibles.",
            "integrity_description": "Notre pratique est construite sur la transparence et les soins éthiques, favorisant la confiance et l'assurance.",
            "excellence_description": "Nous nous engageons à offrir le plus haut standard de soins, combinant expertise technique et approche compatissante centrée sur le patient.",
            "collaboration_description": "Grâce au travail d'équipe et à la communication interdisciplinaire, nous fournissons des soins holistiques adaptés aux besoins uniques de chaque patient.",
            "compassion_description": "Nous privilégions le bien-être du patient en créant un environnement de soutien et accueillant qui place le confort et la compréhension au premier plan de chaque expérience.",
            
            // Corneal Transplant - French
            "about_corneal_transplant": "À Propos de la Greffe de Cornée",
            "corneal_transplant_description": "Suivez vos mesures de greffe de cornée pour surveiller la santé du greffon, détecter le rejet et assurer des résultats optimaux.",
            "track_corneal_transplant_measurements": "Suivez vos mesures de greffe de cornée pour surveiller la santé du greffon, détecter le rejet et assurer des résultats optimaux.",
            "specular_microscopy": "Microscopie Spéculaire",
            "intraocular_pressure": "Pression Intraoculaire",
            "iop": "PIO",
            "no_medication_recorded": "Aucun médicament enregistré",
            "no_regimen_recorded": "Aucun régime enregistré",
            "add_first_measurement_to_track": "Ajoutez votre première mesure pour suivre vos progrès",
            "regraft": "Regreffe",
            "second_transplant": "Deuxième greffe",
            "medication_regimen": "Régime Médicamenteux",
            "no_regimen": "Aucun régime",
            "medication": "Médicament",
            "steroid_regimen": "Régime de Stéroïdes",
            "corneal_transplant_info": "À Propos de la Greffe de Cornée",
            "corneal_transplant_surgical_procedure": "Une greffe de cornée est une procédure chirurgicale qui remplace une cornée endommagée ou malade par un tissu de donneur sain. Une surveillance régulière est cruciale pour détecter le rejet et assurer la survie du greffon.",
            "iop_description": "Pression Intraoculaire",
            "medication_management": "Gestion des Médicaments",
            "steroid_drops": "Gouttes de Stéroïdes",
            "steroid_drops_description": "Médicaments anti-inflammatoires qui aident à prévenir le rejet et à réduire l'inflammation. La posologie est généralement réduite progressivement.",
            "antibiotic_drops": "Gouttes d'Antibiotiques",
            "antibiotic_drops_description": "Préviennent l'infection pendant la période post-opératoire précoce. Généralement prescrites pour une durée limitée.",
            "other_medications": "Autres Médicaments",
            "other_medications_description": "Des médicaments supplémentaires peuvent être prescrits en fonction des besoins individuels et des facteurs de risque.",
            "warning_signs": "Signes d'Alerte",
            "warning_signs_description": "Contactez immédiatement votre médecin si vous ressentez une douleur oculaire accrue, une rougeur, des changements de vision ou une sensibilité à la lumière, car ceux-ci peuvent indiquer un rejet de greffon ou une infection.",
            "monitoring_schedule": "Calendrier de Surveillance",
            "monitoring_schedule_description": "Des rendez-vous de suivi réguliers sont essentiels après une greffe de cornée. La fréquence des visites diminue généralement avec le temps, mais une surveillance à vie est importante pour la santé du greffon.",
            "add_measurement_title": "Ajouter une Mesure",
            "update": "Mettre à Jour",
            "measurements": "Mesures",
            "iop_placeholder": "ex., 16",
            "ecd_description_short": "Densité Cellulaire Endothéliale",
            "pachymetry_description_short": "Épaisseur cornéenne",
            "iop_description_short": "Normal : 10-21 mmHg",
            "medications_procedures": "Médicaments et Procédures",
            "add_medication": "Ajouter un Médicament",
            "medication_type": "Type de Médicament",
            "medication_name": "Nom du Médicament",
            "set_reminder": "Définir un Rappel",
            "start_date": "Date de Début",
            "pills": "Comprimés",
            "drops": "Gouttes",
            "injection": "Injection",
            "every_day": "Tous les jours",
            "monitoring_guidelines": "Directives de Surveillance",
            "first_three_months": "Premiers 3 mois, 6 mois, 12 mois, puis annuellement",
            "every_four_six_months": "Tous les 4-6 mois",
            "may_change_frequency": "Peut changer en fréquence ou en type de goutte",
            "repeat": "Répéter",
            "custom_frequency": "Fréquence personnalisée (ex., tous les 3 jours)",
            "set_reminder_title": "Définir un Rappel",
            "medication_reminder": "Rappel de Médicament",
            "time_to_take_medication": "Il est temps de prendre votre médicament : {medication}",
            "ecd_tooltip": "DCE",
            "pachymetry_tooltip": "Épaisseur Cornéenne",
            "iop_tooltip": "Pression Intraoculaire",
            "regraft_tooltip": "Regreffe",
            "ecd_normal_range": "Plage normale : 2000-3000 cellules/mm²",
            "pachymetry_normal_range": "Plage normale : 500-550 μm",
            "iop_normal_range": "Plage normale : 10-21 mmHg",
            "valid_ecd_error": "Veuillez entrer une valeur DCE valide entre 100 et 4000 cellules/mm²",
            "valid_pachymetry_error": "Veuillez entrer une valeur de pachymétrie valide entre 300 et 700 μm",
            "valid_iop_error": "Veuillez entrer une valeur PIO valide entre 5 et 50 mmHg",
            "enter_medication_name": "Veuillez entrer le nom/notes du médicament",
            "enter_custom_frequency": "Veuillez entrer une fréquence personnalisée",
            "enter_custom_reminder_frequency": "Veuillez entrer une fréquence de rappel personnalisée",
            "endothelial_cell_density_tooltip": "Nombre de cellules endothéliales par millimètre carré. Critique pour surveiller la santé du greffon.",
            "corneal_thickness_tooltip": "Épaisseur cornéenne en micromètres. Important pour surveiller le gonflement du greffon.",
            "intraocular_pressure_tooltip": "Pression du fluide à l'intérieur de l'œil. Une PIO élevée peut endommager le greffon et le nerf optique.",
            "regraft_tooltip_description": "Une deuxième greffe de cornée effectuée après qu'un greffon précédent ait échoué ou été rejeté.",
            
            // Units
            "mmhg": "mmHg",
            
            // Medication Regimen
            "daily": "Quotidien",
            "weekly": "Hebdomadaire",
            "monthly": "Mensuel",
            "twice_daily": "Deux fois par jour",
            "three_times_daily": "Trois fois par jour",
            "every_other_day": "Un jour sur deux",
            "as_needed": "Au besoin",
            
            // Keratoconus - French
            "about_keratoconus": "À Propos du Kératocône",
            "keratoconus_description": "Suivez vos mesures cornéennes pour surveiller la progression du kératocône et l'efficacité du traitement.",
            "track_corneal_measurements": "Suivez vos mesures cornéennes pour surveiller la progression du kératocône et l'efficacité du traitement.",
            "k2_values": "Valeurs K2",
            "k_max_values": "Valeurs K Max",
            "thinnest_pachymetry": "Pachymétrie la Plus Fine",
            "epithelial_thickness": "Épaisseur Épithéliale",
            "thickest_spot": "Point le Plus Épais",
            "thinnest_spot": "Point le Plus Fin",
            "thickest_epithelial_spot": "Point Épithélial Épais",
            "thinnest_epithelial_spot": "Point Épithélial Fin",
            "keratoconus_risk_score": "Score de Risque",
            "low_risk": "Risque Faible : 0-3",
            "high_risk": "Risque Élevé : ≥4",
            "crosslinking_performed": "Réticulation Effectuée",
            "k2_tooltip": "K2 mesure la courbure cornéenne la plus raide. Des valeurs plus élevées peuvent indiquer un kératocône plus avancé.",
            "k_max_tooltip": "K Max est la courbure cornéenne maximale. Important pour suivre la progression et déterminer les options de traitement.",
            "epithelial_tooltip": "Mesure le point le plus épais de l'épithélium cornéen. L'amincissement dans certaines zones peut indiquer un kératocône précoce.",
            "risk_score_tooltip": "Un score composite qui aide à évaluer la probabilité et la gravité du kératocône. Des scores plus élevés indiquent un risque plus grand.",
            "normal_range_k2": "Plage normale : 41-46 dioptries.",
            "normal_range_k_max": "Plage normale : 41-46 dioptries.",
            "normal_range_pachymetry_keratoconus": "Épaisseur normale : 500-600 μm.",
            "normal_range_epithelial": "Plage normale : 50-60 μm.",
            "risk_score_range": "Échelle 0-10",
            "steepest_corneal_curvature": "Courbure cornéenne la plus raide.",
            "maximum_corneal_curvature": "Courbure cornéenne maximale.",
            "thinnest_point_cornea": "Point le plus fin de la cornée.",
            "corneal_epithelium_thickness": "Épaisseur de l'épithélium cornéen.",
            "corneal_epithelium_thickest_point": "Point le plus épais de l'épithélium cornéen",
            "corneal_epithelium_thinnest_point": "Point le plus fin de l'épithélium cornéen",
            "composite_score": "Score composite évaluant la probabilité et la gravité du kératocône.",
            "cylindrical_increase": "Augmentation ≥1D",
            "vision_loss": "Perte de Vision",
            "subjective_vision_loss": "Perte de Vision",
            "cross_linking": "Réticulation",
            "delete_measurement": "Supprimer la Mesure",
            "delete_measurement_confirmation": "Êtes-vous sûr de vouloir supprimer cette mesure ? Cette action ne peut pas être annulée.",
            "delete_confirmation": "Supprimer la Mesure",
            "delete_confirmation_message": "Êtes-vous sûr de vouloir supprimer cette mesure ? Cette action ne peut pas être annulée.",
            "update_measurement": "Mettre à Jour",
            "save_measurement": "Enregistrer la Mesure",
            "fill_required_fields": "Veuillez remplir tous les champs requis avec des valeurs valides.",
            "enter_valid_numbers": "Veuillez entrer des nombres valides pour toutes les mesures",
            "k2_placeholder": "ex., 49,0",
            "k_max_placeholder": "ex., 52,5",
            "epithelial_placeholder": "ex., 40",
            "thickest_epithelial_placeholder": "ex., 60",
            "thinnest_epithelial_placeholder": "ex., 40",
            "risk_indicators": "Indicateurs de Risque",
            "procedures": "Procédures",
            "cross_linking_performed": "Réticulation",
            "optional_notes": "Notes optionnelles (ex., symptômes, changements, etc.)",
            "notes_placeholder": "Notes optionnelles (ex., symptômes, changements, etc.)",
            "select_date_time": "Sélectionner Date et Heure",
            "keratoconus_info": "À Propos du Kératocône",
            "keratoconus_surgical_procedure": "Le kératocône est une affection oculaire progressive où la cornée s'amincit et se bombe en forme de cône, causant une vision déformée. La détection précoce et la surveillance sont cruciales pour gérer efficacement la condition.",
            "cross_linking_cxl": "Réticulation (CXL)",
            "cross_linking_description": "Une procédure qui renforce la cornée pour ralentir ou arrêter la progression. Souvent recommandée pour les cas progressifs.",
            "specialty_contact_lenses": "Lentilles de Contact Spécialisées",
            "specialty_lenses_description": "Lentilles sur mesure pour améliorer la vision et le confort. Les options incluent les lentilles sclérales, hybrides et souples spécialisées.",
            "intacs": "Intacs",
            "intacs_description": "Petits inserts cornéens qui aident à remodeler la cornée et améliorer la vision.",
            "keratoconus_information": "Informations sur le Kératocône",
            "diopters": "D",
            "normal_thickness": "Épaisseur normale",
            "normal_values": "Valeurs normales",
            "higher_values": "Valeurs plus élevées",
            "important_for_tracking": "Important pour le suivi",
            "thinning_may_indicate": "L'amincissement peut indiquer",
            "thinning_in_areas": "L'amincissement dans certaines zones",
            "composite_score_description": "Un score composite qui aide à évaluer la probabilité et la gravité du kératocône.",
            "higher_scores": "Des scores plus élevés indiquent un risque plus grand.",
            "procedure_strengthens": "Une procédure qui renforce la cornée pour ralentir ou arrêter la progression.",
            "custom_designed_lenses": "Lentilles sur mesure pour améliorer la vision et le confort.",
            "small_corneal_inserts": "Petits inserts cornéens qui aident à remodeler la cornée et améliorer la vision.",
            "contact_doctor": "Contactez votre médecin si vous ressentez",
            "rapid_changes": "des changements rapides de vision",
            "increased_sensitivity": "une sensibilité accrue à la lumière",
            "difficulty_with_lenses": "des difficultés avec le port de lentilles de contact",
            "may_indicate_progression": "car ceux-ci peuvent indiquer une progression.",
            "increase_in_astigmatism": "Augmentation de l'astigmatisme",
            "patient_reported_decrease_in_vision": "Diminution de la vision rapportée par le patient",
            
            // Glaucoma - French
            "about_glaucoma": "À Propos du Glaucome",
            "glaucoma_description": "Suivez vos mesures de glaucome pour surveiller la pression intraoculaire, les changements du champ visuel et d'autres paramètres importants.",
            "retinal_nerve_fiber_layer": "Couche de Fibres Nerveuses Rétiniennes (CFNR)",
            "rnfl": "CFNR",
            "rnfl_superior": "CFNR Supérieure",
            "rnfl_inferior": "CFNR Inférieure",
            "macular_gcc": "GCC Maculaire",
            "mean_defect": "Défaut Moyen (DM)",
            "md": "DM",
            "pattern_standard_deviation": "Déviation Standard du Modèle (DSM)",
            "psd": "DSM",
            "visual_field_change": "Changement du Champ Visuel",
            "rnfl_change": "Changement CFNR",
            "family_history": "Antécédents Familiaux",
            "lasik_surgery": "Chirurgie LASIK",
            "new_eye_drops": "Nouvelles Gouttes Oculaires",
            "eye_drops_details": "Détails des Gouttes Oculaires",
            "medication_procedures": "Médicaments et Procédures",
            "glaucoma_information": "Informations sur le Glaucome",
            "visual_field_parameters": "Paramètres du Champ Visuel",
            "oct_measurements": "Mesures OCT",
            "risk_factors": "Facteurs de Risque",
            "md_tooltip": "Mesure la perte moyenne de sensibilité à travers le champ visuel. Des valeurs progressivement négatives peuvent indiquer une aggravation du glaucome.",
            "psd_tooltip": "Mesure l'irrégularité de la perte du champ visuel. Une DSM croissante peut indiquer une progression du glaucome.",
            "rnfl_tooltip": "Mesure l'épaisseur des fibres nerveuses autour du nerf optique. L'amincissement de la CFNR indique une progression du glaucome.",
            "gcc_tooltip": "Mesure l'épaisseur des cellules ganglionnaires dans la macula. L'amincissement du GCC peut indiquer des dommages précoces du glaucome.",
            "normal_range_iop": "Plage normale : 10-21 mmHg.",
            "normal_range_md": "Plage normale : -2 à +2 dB.",
            "normal_range_psd": "Plage normale : 0-2 dB.",
            "normal_range_rnfl": "Plage normale : 80-120 μm.",
            "normal_range_gcc": "Plage normale : 70-100 μm.",
            "md_description": "Défaut Moyen",
            "psd_description": "Déviation Standard du Modèle",
            "rnfl_description": "Épaisseur de la couche de fibres nerveuses rétiniennes",
            "gcc_description": "Épaisseur du complexe de cellules ganglionnaires maculaires",
            "visual_field_change_description": "Changement du champ visuel détecté",
            "rnfl_change_description": "Changement CFNR détecté",
            "family_history_description": "Avoir des antécédents familiaux de glaucome augmente votre risque.",
            "lasik_surgery_description": "Une chirurgie LASIK précédente peut affecter les mesures de PIO et est un facteur important à suivre.",
            "new_eye_drops_description": "Nouvelles gouttes oculaires prescrites",
            "eye_drops_details_description": "Détails sur les gouttes oculaires prescrites",
            "md_placeholder": "ex., -2,5",
            "psd_placeholder": "ex., 1,8",
            "rnfl_placeholder": "ex., 85",
            "rnfl_superior_placeholder": "ex., 110",
            "rnfl_inferior_placeholder": "ex., 120",
            "gcc_placeholder": "ex., 85",
            "eye_drops_placeholder": "ex., Latanoprost",
            "rnfl_superotemporal": "CFNR Supéro-temporale",
            "rnfl_inferotemporal": "CFNR Inféro-temporale",
            "superior_quadrant_thickness": "Épaisseur du quadrant supérieur",
            "inferior_quadrant_thickness": "Épaisseur du quadrant inférieur",
            "macular_ganglion_cell_complex": "Complexe de Cellules Ganglionnaires Maculaires (CCGM)",
            "ganglion_cell_complex_thickness": "Épaisseur du complexe de cellules ganglionnaires maculaires",
            "average_sensitivity_loss": "Mesure la perte moyenne de sensibilité à travers le champ visuel. Des valeurs progressivement négatives peuvent indiquer une aggravation du glaucome.",
            "irregularity_visual_field_loss": "Mesure l'irrégularité de la perte du champ visuel. Une DSM croissante peut indiquer une progression du glaucome.",
            "thickness_nerve_fibers": "Mesure l'épaisseur des fibres nerveuses autour du nerf optique. L'amincissement de la CFNR indique une progression du glaucome. Les quadrants supérieur et inférieur sont particulièrement importants.",
            "thickness_ganglion_cells": "Mesure l'épaisseur des cellules ganglionnaires dans la macula. L'amincissement du GCC peut indiquer des dommages précoces du glaucome.",
            "elevated_iop_risk_factor": "Une PIO élevée est un facteur de risque majeur pour le glaucome.",
            "progressively_negative_values": "Des valeurs progressivement négatives peuvent indiquer une aggravation du glaucome.",
            "increasing_psd_progression": "Une DSM croissante peut indiquer une progression du glaucome.",
            "rnfl_thinning_progression": "L'amincissement de la CFNR indique une progression du glaucome.",
            "gcc_thinning_early_damage": "L'amincissement du GCC peut indiquer des dommages précoces du glaucome.",
            "family_history_increases_risk": "Avoir des antécédents familiaux de glaucome augmente votre risque.",
            "lasik_affects_iop_measurements": "Une chirurgie LASIK précédente peut affecter les mesures de PIO et est un facteur important à suivre.",
            "contact_doctor_immediately": "Contactez immédiatement votre médecin si vous ressentez",
            "vision_changes_eye_pain": "des changements de vision, des douleurs oculaires, des maux de tête sévères ou des halos autour des lumières",
            "severe_headaches_halos": "des maux de tête sévères ou des halos autour des lumières",
            "acute_glaucoma_episode": "car ceux-ci peuvent indiquer un épisode de glaucome aigu.",
            "db": "dB",
            
            // Retinal Injections - French
            "about_retina_injections": "À Propos des Injections Rétiniennes",
            "retina_injections_description": "Suivez vos traitements d'injection rétinienne, votre vision et votre CRT pour surveiller vos progrès et l'efficacité du traitement.",
            "track_retina_injection_treatments": "Suivez vos traitements d'injection rétinienne, votre vision et votre CRT pour surveiller vos progrès et l'efficacité du traitement.",
            "injection_calendar": "Calendrier des Injections",
            "central_retinal_thickness": "Épaisseur Rétinienne Centrale",
            "crt_measurement": "Mesure CRT",
            "visual_acuity": "Acuité Visuelle (20/y)",
            "vision_measurement": "Mesure de vision",
            "upcoming_follow_up": "Suivi à venir",
            "injection_details": "Détails de l'Injection",
            "no_injection_details_found": "Aucun détail d'injection trouvé",
            "no_recorded_injections_for_date": "Il n'y a pas d'injections enregistrées pour cette date.",
            "injection_time": "Heure de l'Injection",
            "next_appointment": "Prochain Rendez-vous",
            "not_set": "Non défini",
            "new_injection": "Nouvelle Injection",
            "retina_injection_info": "Info sur les Injections Rétiniennes",
            "retina_injections_used_to_treat": "Les injections rétiniennes sont utilisées pour traiter plusieurs maladies rétiniennes. Elles administrent des médicaments directement à l'arrière de l'œil pour réduire le gonflement, prévenir la perte de vision et améliorer les résultats.",
            "key_measurements_retina": "Mesures Clés",
            "central_retina_thickness_crt": "Épaisseur Rétinienne Centrale (CRT)",
            "thickness_central_retina": "Épaisseur de la rétine centrale. Des valeurs plus élevées peuvent indiquer un gonflement.",
            "higher_values_may_indicate": "Des valeurs plus élevées peuvent indiquer un gonflement.",
            "vision_visual_acuity": "Vision (Acuité Visuelle)",
            "tracks_vision_changes": "Suit les changements de vision au fil du temps.",
            "injection_timeline": "Chronologie des Injections",
            "dates_medications_injection": "Dates et médicaments pour chaque injection.",
            "new_injection_indicates": "Nouvelle Injection",
            "when_new_medication": "Indique quand un nouveau médicament commence.",
            "follow_up_reminders": "Rappels de Suivi",
            "helps_remember_appointments": "Vous aide à vous souvenir des rendez-vous à venir.",
            "treatment_goals": "Objectifs de Traitement",
            "reduce_retinal_swelling": "• Réduire le gonflement rétinien",
            "maintain_improve_vision": "• Maintenir ou améliorer la vision",
            "prevent_further_vision_loss": "• Prévenir une perte de vision supplémentaire",
            "minimize_treatment_burden": "• Minimiser la charge du traitement",
            "when_to_seek_help_retina": "Quand Demander de l'Aide",
            "contact_doctor_sudden_vision": "Contactez votre médecin si vous ressentez une perte de vision soudaine, une augmentation des corps flottants, des éclairs de lumière ou des douleurs oculaires.",
            "sudden_vision_loss": "perte de vision soudaine",
            "increased_floaters": "augmentation des corps flottants",
            "flashes_of_light": "éclairs de lumière",
            "eye_pain": "douleurs oculaires",
            "retina_injection": "Injection Rétinienne",
            "edit_injection": "Modifier l'Injection",
            "add_injection": "Ajouter une Injection",
            "injection_details_title": "Détails de l'Injection",
            "new_medication_question": "Nouveau Médicament ?",
            "first_time_using_medication": "Première fois que vous utilisez ce médicament ?",
            "injection_medication": "Médicament d'injection",
            "vision_measurements_title": "Vision et Mesures",
            "best_corrected_vision": "Meilleure Vision Corrigée",
            "visual_acuity_description": "Acuité visuelle",
            "central_retinal_thickness_title": "Épaisseur Rétinienne Centrale",
            "crt_measurement_description": "Mesure CRT",
            "follow_up_reminder_title": "Rappel de Suivi",
            "clear": "Effacer",
            "set": "Définir",
            "next_appointment_colon": "Prochain rendez-vous :",
            "follow_up_appointment": "Rendez-vous de suivi",
            "notes_title": "Notes",
            "optional_notes_retina": "Notes optionnelles (ex., symptômes, changements, etc.)",
            "edit_injection_warning": "Modifier l'Injection",
            "modify_existing_injection": "Vous êtes sur le point de modifier une injection existante. Cette action ne peut pas être annulée. Voulez-vous continuer ?",
            "action_cannot_be_undone": "Cette action ne peut pas être annulée. Voulez-vous continuer ?",
            "do_you_want_to_continue": "Voulez-vous continuer ?",
            "medication_tooltip": "Médicament",
            "medication_used_for_injection": "Le médicament utilisé pour l'injection.",
            "common_medications_include": "Les médicaments courants incluent Avastin, Lucentis et Eylea.",
            "avastin_lucentis_eylea": "Avastin, Lucentis et Eylea.",
            "new_medications_should_be_tracked": "Les nouveaux médicaments doivent être suivis pour surveiller l'efficacité.",
            "best_vision_achievable": "Meilleure vision réalisable avec des lunettes ou des lentilles de contact. Mesurée en notation Snellen (ex., 20/20).",
            "measured_in_snellen_notation": "Mesurée en notation Snellen.",
            "lower_numbers_indicate_better": "Les nombres plus bas indiquent une meilleure vision.",
            "thickness_central_retina_tooltip": "Épaisseur Rétinienne Centrale",
            "high_crt_values_may_indicate": "Épaisseur de la rétine centrale. Des valeurs CRT élevées peuvent indiquer un gonflement ou une accumulation de liquide.",
            "swelling_fluid_accumulation": "gonflement ou accumulation de liquide.",
            "normal_range_crt": "Plage normale : 250-350 μm.",
            "set_reminder_next_appointment": "Définir un rappel pour votre prochain rendez-vous de suivi pour rester sur la bonne voie avec votre plan de traitement.",
            "stay_on_track_treatment": "pour rester sur la bonne voie avec votre plan de traitement.",
            "regular_monitoring_essential": "Une surveillance régulière est essentielle pour des résultats optimaux.",
            "optimal_outcomes": "résultats optimaux.",
            "please_enter_valid_crt": "Veuillez entrer une valeur CRT valide.",
            "must_be_logged_in_add": "Vous devez être connecté pour ajouter des mesures",
            "must_be_logged_in_view": "Vous devez être connecté pour voir les mesures",
            "must_be_logged_in_delete": "Vous devez être connecté pour supprimer des mesures",
            "invalid_measurement_id": "ID de mesure invalide",
            "failed_to_fetch_measurements": "Échec de la récupération des mesures :",
            "failed_to_add_measurement": "Échec de l'ajout de la mesure :",
            "failed_to_delete_measurement": "Échec de la suppression de la mesure :",
            
            // Date and Time
            "reminder_date": "Date de Rappel",
        ]
    ]
    
    static func localizedString(for key: String, language: Language = LocalizationManager.shared.currentLanguage) -> String {
        return strings[language]?[key] ?? strings[.english]?[key] ?? key
    }
}

// MARK: - Localized Text View Modifier
struct LocalizedText: View {
    let key: String
    let language: Language
    
    init(_ key: String, language: Language? = nil) {
        self.key = key
        self.language = language ?? LocalizationManager.shared.currentLanguage
    }
    
    var body: some View {
        Text(LocalizedStrings.localizedString(for: key, language: language))
    }
}

// MARK: - Localized String Extension
extension String {
    func localized(language: Language? = nil) -> String {
        // Use the passed language or get it from the current LocalizationManager instance
        let currentLang = language ?? LocalizationManager.shared.currentLanguage
        return LocalizedStrings.localizedString(for: self, language: currentLang)
    }
    
    func localized() -> String {
        return LocalizedStrings.localizedString(for: self, language: LocalizationManager.shared.currentLanguage)
    }
}


