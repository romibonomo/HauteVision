import SwiftUI
import FirebaseAuth

struct GlaucomaDataEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GlaucomaViewModel
    let selectedEye: EyeType
    let existingMeasurement: GlaucomaMeasurement? // For editing existing measurements
    @EnvironmentObject var localizationManager: LocalizationManager
    
    private var currentLanguage: Language {
        localizationManager.currentLanguage
    }
    
    @State private var eyeSelection: EyeType
    @State private var date = Date()
    @State private var iop = ""
    @State private var iopTime = Date()
    @State private var meanDefect = ""
    @State private var patternStandardDeviation = ""
    @State private var rnflOverall = ""
    @State private var rnflSuperior = ""
    @State private var rnflInferior = ""
    @State private var macularGCC = ""
    @State private var hasVisualFieldChange = false
    @State private var hasRNFLChange = false
    @State private var hasGlaucomaFamilyHistory = false
    @State private var hasLasikSurgery = false
    @State private var newEyeDrops = false
    @State private var eyeDropsDetails = ""
    @State private var notes = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingEditWarning = false
    
    // Info tooltip state (single overlay)
    @State private var activeTooltip: TooltipType? = nil
    enum TooltipType { case iop, md, psd, rnfl, gcc }
    
    @State private var showingDatePicker = false
    
    // Computed property to determine if we're editing
    private var isEditing: Bool {
        return existingMeasurement != nil
    }
    
    // Initializer for new measurements
    init(viewModel: GlaucomaViewModel, selectedEye: EyeType) {
        self.viewModel = viewModel
        self.selectedEye = selectedEye
        self.existingMeasurement = nil
        self.eyeSelection = selectedEye // Initialize the new state variable
    }
    
    // Initializer for editing existing measurements
    init(viewModel: GlaucomaViewModel, selectedEye: EyeType, existingMeasurement: GlaucomaMeasurement) {
        self.viewModel = viewModel
        self.selectedEye = selectedEye
        self.existingMeasurement = existingMeasurement
        self.eyeSelection = selectedEye // Initialize the new state variable
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white
                .frame(height: 120)
                .ignoresSafeArea(edges: .top)
                .allowsHitTesting(false)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Text(LocalizedStringKey.glaucoma.localized())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                    DataEntryEyeToggleView(selectedEye: $eyeSelection)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    HStack(spacing: 10) {
                        Spacer()
                        Button(action: { showingDatePicker = true }) {
                            HStack(spacing: 8) {
                                Text(dateFormatted)
                                    .foregroundColor(.primary)
                                    .font(.headline)
                                Text(timeFormatted)
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                Image(systemName: "calendar")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                    .padding(.top, 8)
                    .sheet(isPresented: $showingDatePicker) {
                        VStack {
                        DatePicker(LocalizedStringKey.selectDateTime.localized(), selection: $date, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                            .padding()
                        Button(LocalizedStringKey.done.localized()) { showingDatePicker = false }
                            .padding()
                        }
                        .presentationDetents([.medium, .large])
                    }
                    measurementsCard
                    riskFactorsCard
                    medicationCard
                    notesCard
                    (
                        Text("*")
                            .bold()
                            .foregroundColor(.red)
                        + Text(" \(LocalizedStringKey.requiredField.localized())")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    )
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .padding(.top, 2)
                    
                    // Save button moved inside ScrollView
                    saveButton
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                }
                .padding(.top)
                .padding(.horizontal, 16)
            }
            
            if let tooltip = activeTooltip {
                TooltipOverlay(type: tooltip) {
                    activeTooltip = nil
                }
            }
        }
        .navigationTitle(isEditing ? LocalizedStringKey.editMeasurement.localized() : LocalizedStringKey.addMeasurement.localized())
        .navigationBarTitleDisplayMode(.inline)
        .alert(LocalizedStringKey.error.localized(), isPresented: $showingError) {
            Button(LocalizedStringKey.ok.localized(), role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .alert(LocalizedStringKey.editMeasurementWarning.localized(), isPresented: $showingEditWarning) {
            Button(LocalizedStringKey.cancel.localized(), role: .cancel) { }
            Button(LocalizedStringKey.continueAction.localized(), role: .destructive) {
                saveMeasurement()
            }
        } message: {
            Text(LocalizedStringKey.editMeasurementMessage.localized())
        }
        .id(currentLanguage)
        .onAppear {
            if let existingMeasurement = existingMeasurement {
                // Prefill the form with existing data
                date = existingMeasurement.date
                iop = String(format: "%.1f", existingMeasurement.iop)
                iopTime = existingMeasurement.iopTime
                meanDefect = String(format: "%.1f", existingMeasurement.meanDefect)
                patternStandardDeviation = String(format: "%.1f", existingMeasurement.patternStandardDeviation)
                rnflOverall = String(existingMeasurement.rnflOverall)
                rnflSuperior = String(existingMeasurement.rnflSuperior)
                rnflInferior = String(existingMeasurement.rnflInferior)
                macularGCC = String(existingMeasurement.macularGCC)
                hasVisualFieldChange = existingMeasurement.hasVisualFieldChange
                hasRNFLChange = existingMeasurement.hasRNFLChange
                hasGlaucomaFamilyHistory = existingMeasurement.hasGlaucomaFamilyHistory
                hasLasikSurgery = existingMeasurement.hasLasikSurgery
                newEyeDrops = existingMeasurement.newEyeDrops
                eyeDropsDetails = existingMeasurement.eyeDropsDetails ?? ""
                notes = existingMeasurement.notes ?? ""
            }
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(LocalizedStringKey.cancel.localized()) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(isEditing ? LocalizedStringKey.updateMeasurement.localized() : LocalizedStringKey.saveMeasurement.localized()) { 
                    if isEditing {
                        showingEditWarning = true
                    } else {
                        saveMeasurement()
                    }
                }
            }
        }
    }

    private var measurementsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(LocalizedStringKey.measurements.localized())
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.bottom, 12)
            
            MeasurementRowModern(
                label: LocalizedStringKey.iop.localized(),
                value: $iop,
                placeholder: LocalizedStringKey.iopPlaceholder.localized(),
                unit: LocalizedStringKey.mmHg.localized(),
                isNumber: true,
                description: LocalizedStringKey.iopDescription.localized(),
                infoAction: { activeTooltip = .iop },
                isRequired: true
            )
            MeasurementRowModern(
                label: LocalizedStringKey.md.localized(),
                value: $meanDefect,
                placeholder: LocalizedStringKey.mdPlaceholder.localized(),
                unit: LocalizedStringKey.db.localized(),
                isNumber: true,
                description: LocalizedStringKey.mdDescription.localized(),
                infoAction: { activeTooltip = .md },
                isRequired: false
            )
            MeasurementRowModern(
                label: LocalizedStringKey.psd.localized(),
                value: $patternStandardDeviation,
                placeholder: LocalizedStringKey.psdPlaceholder.localized(),
                unit: LocalizedStringKey.db.localized(),
                isNumber: true,
                description: LocalizedStringKey.psdDescription.localized(),
                infoAction: { activeTooltip = .psd },
                isRequired: false
            )
            MeasurementRowModern(
                label: LocalizedStringKey.rnfl.localized(),
                value: $rnflOverall,
                placeholder: LocalizedStringKey.rnflPlaceholder.localized(),
                unit: LocalizedStringKey.micrometers.localized(),
                isNumber: true,
                description: LocalizedStringKey.rnflDescription.localized(),
                infoAction: { activeTooltip = .rnfl },
                isRequired: true
            )
            MeasurementRowModern(
                label: LocalizedStringKey.rnflSuperotemporal.localized(),
                value: $rnflSuperior,
                placeholder: LocalizedStringKey.rnflSuperiorPlaceholder.localized(),
                unit: LocalizedStringKey.micrometers.localized(),
                isNumber: true,
                description: LocalizedStringKey.superiorQuadrantThickness.localized(),
                infoAction: { activeTooltip = .rnfl },
                isRequired: true
            )
            MeasurementRowModern(
                label: LocalizedStringKey.rnflInferotemporal.localized(),
                value: $rnflInferior,
                placeholder: LocalizedStringKey.rnflInferiorPlaceholder.localized(),
                unit: LocalizedStringKey.micrometers.localized(),
                isNumber: true,
                description: LocalizedStringKey.inferiorQuadrantThickness.localized(),
                infoAction: { activeTooltip = .rnfl },
                isRequired: true
            )
            MeasurementRowModern(
                label: LocalizedStringKey.macularGcc.localized(),
                value: $macularGCC,
                placeholder: LocalizedStringKey.gccPlaceholder.localized(),
                unit: LocalizedStringKey.micrometers.localized(),
                isNumber: true,
                description: LocalizedStringKey.gccDescription.localized(),
                infoAction: { activeTooltip = .gcc },
                isRequired: true,
                showDivider: false
            )
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    private var riskFactorsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(LocalizedStringKey.riskIndicators.localized())
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.bottom, 12)
            
            VStack(spacing: 12) {
                // Visual Field Change
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(LocalizedStringKey.visualFieldChange.localized())
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        Spacer()
                        HStack(spacing: 8) {
                            Button(action: { hasVisualFieldChange = true }) {
                                Text(LocalizedStringKey.yes.localized())
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(hasVisualFieldChange ? .white : .accentColor)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 2)
                                    .background(hasVisualFieldChange ? Color.accentColor : Color(.systemGray6))
                                    .cornerRadius(14)
                            }
                            Button(action: { hasVisualFieldChange = false }) {
                                Text(LocalizedStringKey.no.localized())
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(!hasVisualFieldChange ? .white : .accentColor)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 2)
                                    .background(!hasVisualFieldChange ? Color.accentColor : Color(.systemGray6))
                                    .cornerRadius(14)
                            }
                        }
                    }
                }
                Divider()
                
                // RNFL Change
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(LocalizedStringKey.rnflChange.localized())
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        Spacer()
                        HStack(spacing: 8) {
                            Button(action: { hasRNFLChange = true }) {
                                Text(LocalizedStringKey.yes.localized())
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(hasRNFLChange ? .white : .accentColor)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 2)
                                    .background(hasRNFLChange ? Color.accentColor : Color(.systemGray6))
                                    .cornerRadius(14)
                            }
                            Button(action: { hasRNFLChange = false }) {
                                Text(LocalizedStringKey.no.localized())
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(!hasRNFLChange ? .white : .accentColor)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 2)
                                    .background(!hasRNFLChange ? Color.accentColor : Color(.systemGray6))
                                    .cornerRadius(14)
                            }
                        }
                    }
                }
                Divider()
                
                // Family History
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(LocalizedStringKey.familyHistory.localized())
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        Spacer()
                        HStack(spacing: 8) {
                            Button(action: { hasGlaucomaFamilyHistory = true }) {
                                Text(LocalizedStringKey.yes.localized())
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(hasGlaucomaFamilyHistory ? .white : .accentColor)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 2)
                                    .background(hasGlaucomaFamilyHistory ? Color.accentColor : Color(.systemGray6))
                                    .cornerRadius(14)
                            }
                            Button(action: { hasGlaucomaFamilyHistory = false }) {
                                Text(LocalizedStringKey.no.localized())
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(!hasGlaucomaFamilyHistory ? .white : .accentColor)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 2)
                                    .background(!hasGlaucomaFamilyHistory ? Color.accentColor : Color(.systemGray6))
                                    .cornerRadius(14)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    private var medicationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedStringKey.medicationProcedures.localized())
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.bottom, 12)
            
            VStack(spacing: 12) {
                // LASIK Surgery
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(LocalizedStringKey.lasikSurgery.localized())
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        Spacer()
                        Toggle("", isOn: $hasLasikSurgery)
                            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    }
                }
                Divider()

                // New Eye Drops
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(LocalizedStringKey.newEyeDrops.localized())
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        Spacer()
                        Toggle("", isOn: $newEyeDrops)
                            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    }
                }
                
                if newEyeDrops {
                    Divider()
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(LocalizedStringKey.eyeDropsDetails.localized())
                                .font(.headline)
                                .foregroundColor(.accentColor)
                            Text("*").foregroundColor(.red)
                        }
                        TextField(LocalizedStringKey.eyeDropsPlaceholder.localized(), text: $eyeDropsDetails)
                    }
                }
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(LocalizedStringKey.notes.localized())
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.bottom, 12)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $notes)
                    .frame(height: 80)
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
                if notes.isEmpty {
                    Text(LocalizedStringKey.optionalNotes.localized())
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                        .allowsHitTesting(false)
                }
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 4)
    }
    
    private var saveButton: some View {
        VStack {
            Button(action: {
                if isEditing {
                    showingEditWarning = true
                } else {
                    saveMeasurement()
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                    Text(isEditing ? LocalizedStringKey.updateMeasurement.localized() : LocalizedStringKey.saveMeasurement.localized())
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(isValid ? Color.accentColor : Color(.systemGray5))
                .cornerRadius(16)
                .shadow(color: isValid ? Color.accentColor.opacity(0.2) : Color.clear, radius: 8, x: 0, y: 4)
            }
            .disabled(!isValid)
            .padding([.horizontal, .bottom], 16)
        }
    }

    @ViewBuilder
    private func MeasurementRowModern(
        label: String,
        value: Binding<String>,
        placeholder: String,
        unit: String,
        isNumber: Bool,
        description: String,
        infoAction: @escaping () -> Void,
        isRequired: Bool,
        showDivider: Bool = true
    ) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 8) {
                (
                    Text(label)
                        .foregroundColor(.accentColor)
                    + (isRequired ? Text(" *").foregroundColor(.red) : Text(""))
                )
                .font(.headline)
                .layoutPriority(1)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                Spacer(minLength: 8)
                TextField(placeholder, text: value)
                    .keyboardType(isNumber ? .decimalPad : .default)
                    .multilineTextAlignment(.trailing)
                    .font(.subheadline)
                    .frame(minWidth: 70, maxWidth: 120)
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            HStack(spacing: 4) {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
                Button(action: infoAction) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 10)
        if showDivider {
            Divider()
        }
    }

    // MARK: - Tooltip Overlay
    @ViewBuilder
    private func TooltipOverlay(type: TooltipType, onDismiss: @escaping () -> Void) -> some View {
        ZStack {
            Color.white.opacity(0.9)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Text(tooltipTitle(for: type))
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        Spacer()
                        Button(action: onDismiss) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.accentColor.opacity(0.8))
                        }
                        .padding()
                    }
                    TooltipTextView(for: type)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.1), radius: 8)
                .padding(.horizontal, 16)
                Spacer()
            }
        }
    }

    // MARK: - Tooltip Texts
    @ViewBuilder
    private func TooltipTextView(for type: TooltipType) -> some View {
        switch type {
        case .iop:
            VStack(alignment: .leading, spacing: 0) {
                Text(LocalizedStringKey.intraocularPressureTooltip.localized())
                    .font(.callout)
                    .foregroundColor(.primary)
                    .lineSpacing(-2)
                Text(LocalizedStringKey.normalRangeIop.localized())
                    .font(.caption)
                    .foregroundColor(Color.green)
                    .padding(.top, 12)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        case .md:
            VStack(alignment: .leading, spacing: 0) {
                Text(LocalizedStringKey.mdTooltip.localized())
                    .font(.callout)
                    .foregroundColor(.primary)
                    .lineSpacing(-2)
                Text(LocalizedStringKey.normalRangeMd.localized())
                    .font(.caption)
                    .foregroundColor(Color.primary)
                    .padding(.top, 12)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        case .psd:
            VStack(alignment: .leading, spacing: 0) {
                Text(LocalizedStringKey.psdTooltip.localized())
                    .font(.callout)
                    .foregroundColor(.primary)
                    .lineSpacing(-2)
                Text(LocalizedStringKey.normalRangePsd.localized())
                    .font(.caption)
                    .foregroundColor(Color.green)
                    .padding(.top, 12)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        case .rnfl:
            VStack(alignment: .leading, spacing: 0) {
                Text(LocalizedStringKey.rnflTooltip.localized())
                    .font(.callout)
                    .foregroundColor(.primary)
                    .lineSpacing(-2)
                Text(LocalizedStringKey.normalRangeRnfl.localized())
                    .font(.caption)
                    .foregroundColor(Color.green)
                    .padding(.top, 12)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        case .gcc:
            VStack(alignment: .leading, spacing: 0) {
                Text(LocalizedStringKey.gccTooltip.localized())
                    .font(.callout)
                    .foregroundColor(.primary)
                    .lineSpacing(-2)
                Text(LocalizedStringKey.normalRangeGcc.localized())
                    .font(.caption)
                    .foregroundColor(Color.green)
                    .padding(.top, 12)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    private func tooltipTitle(for type: TooltipType) -> String {
        switch type {
        case .iop: return LocalizedStringKey.intraocularPressure.localized()
        case .md: return LocalizedStringKey.meanDefect.localized()
        case .psd: return LocalizedStringKey.patternStandardDeviation.localized()
        case .rnfl: return LocalizedStringKey.retinalNerveFiberLayer.localized()
        case .gcc: return LocalizedStringKey.macularGcc.localized()
        }
    }
    
    private var isValid: Bool {
        guard let iopValue = Double(iop),
              let rnflValue = Int(rnflOverall),
              let rnflSupValue = Int(rnflSuperior),
              let rnflInfValue = Int(rnflInferior),
              let gccValue = Int(macularGCC) else {
            return false
        }
        
        return iopValue > 0 && rnflValue > 0 && rnflSupValue > 0 && rnflInfValue > 0 && gccValue > 0
    }
    
    private func saveMeasurement() {
        guard let iopValue = Double(iop),
              let rnflValue = Int(rnflOverall),
              let rnflSupValue = Int(rnflSuperior),
              let rnflInfValue = Int(rnflInferior),
              let gccValue = Int(macularGCC) else {
            errorMessage = LocalizedStringKey.enterValidNumbers.localized()
            showingError = true
            return
        }
        
        if isEditing {
            // Update existing measurement
            guard let existingMeasurement = existingMeasurement else { return }
            
            let updatedMeasurement = GlaucomaMeasurement(
                id: existingMeasurement.id,
                userId: existingMeasurement.userId,
                date: date,
                eye: eyeSelection,
                hasGlaucomaFamilyHistory: hasGlaucomaFamilyHistory,
                hasLasikSurgery: hasLasikSurgery,
                iop: iopValue,
                iopTime: iopTime,
                meanDefect: Double(meanDefect) ?? 0,
                patternStandardDeviation: Double(patternStandardDeviation) ?? 0,
                rnflOverall: rnflValue,
                rnflSuperior: rnflSupValue,
                rnflInferior: rnflInfValue,
                macularGCC: gccValue,
                hasVisualFieldChange: hasVisualFieldChange,
                hasRNFLChange: hasRNFLChange,
                newEyeDrops: newEyeDrops,
                eyeDropsDetails: eyeDropsDetails.isEmpty ? nil : eyeDropsDetails,
                notes: notes.isEmpty ? nil : notes,
                edited: true
            )
            
            Task {
                do {
                    // First delete the old measurement
                    try await viewModel.deleteMeasurement(existingMeasurement)
                    // Then add the updated measurement
                    try await viewModel.addMeasurement(updatedMeasurement)
                    // Force immediate UI refresh by directly updating the measurements arrays
                    await MainActor.run {
                        // Trigger a UI refresh by temporarily clearing and re-adding the measurements
                        let currentOD = viewModel.measurementsOD
                        let currentOS = viewModel.measurementsOS
                        viewModel.measurementsOD = []
                        viewModel.measurementsOS = []
                        DispatchQueue.main.async {
                            viewModel.measurementsOD = currentOD
                            viewModel.measurementsOS = currentOS
                        }
                    }
                    await MainActor.run {
                        dismiss()
                    }
                } catch {
                    await MainActor.run {
                        errorMessage = error.localizedDescription
                        showingError = true
                    }
                }
            }
        } else {
            // Create new measurement
            let measurement = GlaucomaMeasurement(
                userId: Auth.auth().currentUser?.uid ?? "",
                date: date,
                eye: eyeSelection,
                hasGlaucomaFamilyHistory: hasGlaucomaFamilyHistory,
                hasLasikSurgery: hasLasikSurgery,
                iop: iopValue,
                iopTime: iopTime,
                meanDefect: Double(meanDefect) ?? 0,
                patternStandardDeviation: Double(patternStandardDeviation) ?? 0,
                rnflOverall: rnflValue,
                rnflSuperior: rnflSupValue,
                rnflInferior: rnflInfValue,
                macularGCC: gccValue,
                hasVisualFieldChange: hasVisualFieldChange,
                hasRNFLChange: hasRNFLChange,
                newEyeDrops: newEyeDrops,
                eyeDropsDetails: eyeDropsDetails.isEmpty ? nil : eyeDropsDetails,
                notes: notes.isEmpty ? nil : notes,
                edited: nil
            )
            
            Task {
                do {
                    try await viewModel.addMeasurement(measurement)
                    // Force UI refresh by updating the published properties
                    await MainActor.run {
                        // Trigger a UI refresh by temporarily clearing and re-adding the measurements
                        let currentOD = viewModel.measurementsOD
                        let currentOS = viewModel.measurementsOS
                        viewModel.measurementsOD = []
                        viewModel.measurementsOS = []
                        DispatchQueue.main.async {
                            viewModel.measurementsOD = currentOD
                            viewModel.measurementsOS = currentOS
                        }
                    }
                    await MainActor.run {
                        dismiss()
                    }
                } catch {
                    await MainActor.run {
                        errorMessage = error.localizedDescription
                        showingError = true
                    }
                }
            }
        }
    }

    private var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: currentLanguage == .french ? "fr_FR" : "en_US")
        return formatter.string(from: date)
    }
    
    private var timeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: currentLanguage == .french ? "fr_FR" : "en_US")
        return formatter.string(from: date)
    }
}

struct GlaucomaDataEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GlaucomaDataEntryView(
                viewModel: GlaucomaViewModel(),
                selectedEye: .OD
            )
        }
    }
} 
