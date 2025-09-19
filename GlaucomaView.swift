import SwiftUI

struct GlaucomaView: View {
    @StateObject private var viewModel = GlaucomaViewModel()
    @State private var showingAddMeasurement = false
    @State private var selectedEye: EyeType = .OD
    @State private var showingInfo = false
    @State private var selectedDataPointIndex: Int? = nil
    @EnvironmentObject var localizationManager: LocalizationManager
    
    private var currentLanguage: Language {
        localizationManager.currentLanguage
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Disease Info Card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(LocalizedStringKey.aboutGlaucoma.localized())
                        .font(.headline)
                    Spacer()
                    Button {
                        showingInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                    }
                }
                
                Text(LocalizedStringKey.glaucomaDescription.localized())
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Eye Selection
            VStack(alignment: .leading, spacing: 4) {
                EyeToggleView(selectedEye: $selectedEye)
                    .padding(.horizontal)
            }
            
            // Add Measurement button when there's data
            if !viewModel.getMeasurements(for: selectedEye).isEmpty {
                Button(action: { showingAddMeasurement = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        Text(LocalizedStringKey.addMeasurement.localized())
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.accentColor)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(Color.accentColor.opacity(0.12))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            // Measurements Over Time title - only show when there's data
            if !viewModel.getMeasurements(for: selectedEye).isEmpty {
                Text(LocalizedStringKey.measurementsOverTime.localized())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 12)
            }
            
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                Spacer()
            } else if let error = viewModel.errorMessage {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                .padding()
                Spacer()
            } else {
                // Visualization and measurement history
                ScrollView {
                    VStack(spacing: 24) {
                        // Only show graphs if there's data
                        if !viewModel.getMeasurements(for: selectedEye).isEmpty {
                            // IOP Graph Card
                            let iopData = viewModel.getSortedMeasurements(for: selectedEye).map { ($0.date, $0.iop, false) }
                            createGraphCard(
                                title: LocalizedStringKey.intraocularPressure.localized(),
                                data: iopData,
                                valueLabel: { String(format: "%.1f", $0) },
                                color: .blue,
                                normalRange: GlaucomaViewModel.normalIOPRange,
                                unit: LocalizedStringKey.mmHg.localized(),
                                infoText: LocalizedStringKey.iopTooltip.localized()
                            )

                            // RNFL Graph Card
                            let rnflData = viewModel.getSortedMeasurements(for: selectedEye).map { ($0.date, Double($0.rnflOverall), false) }
                            createGraphCard(
                                title: LocalizedStringKey.retinalNerveFiberLayer.localized(),
                                data: rnflData,
                                valueLabel: { String(format: "%d", Int($0)) },
                                color: .green,
                                normalRange: GlaucomaViewModel.normalRNFLRange,
                                unit: LocalizedStringKey.micrometers.localized(),
                                infoText: LocalizedStringKey.rnflTooltip.localized()
                            )

                            // RNFL Superior Graph Card
                            let rnflSupData = viewModel.getSortedMeasurements(for: selectedEye).map { ($0.date, Double($0.rnflSuperior), false) }
                            createGraphCard(
                                title: LocalizedStringKey.rnflSuperior.localized(),
                                data: rnflSupData,
                                valueLabel: { String(format: "%d", Int($0)) },
                                color: .mint,
                                normalRange: GlaucomaViewModel.normalRNFLRange,
                                unit: LocalizedStringKey.micrometers.localized(),
                                infoText: LocalizedStringKey.superiorQuadrantThickness.localized()
                            )

                            // RNFL Inferior Graph Card
                            let rnflInfData = viewModel.getSortedMeasurements(for: selectedEye).map { ($0.date, Double($0.rnflInferior), false) }
                            createGraphCard(
                                title: LocalizedStringKey.rnflInferior.localized(),
                                data: rnflInfData,
                                valueLabel: { String(format: "%d", Int($0)) },
                                color: .indigo,
                                normalRange: GlaucomaViewModel.normalRNFLRange,
                                unit: LocalizedStringKey.micrometers.localized(),
                                infoText: LocalizedStringKey.inferiorQuadrantThickness.localized()
                            )
                            
                            // Macular GCC Graph Card
                            let gccData = viewModel.getSortedMeasurements(for: selectedEye).map { ($0.date, Double($0.macularGCC), false) }
                            createGraphCard(
                                title: LocalizedStringKey.macularGcc.localized(),
                                data: gccData,
                                valueLabel: { String(format: "%d", Int($0)) },
                                color: .teal,
                                normalRange: 70...100,
                                unit: LocalizedStringKey.micrometers.localized(),
                                infoText: LocalizedStringKey.gccTooltip.localized()
                            )

                            // Mean Defect (MD) Graph Card
                            let mdData = viewModel.getSortedMeasurements(for: selectedEye).map { ($0.date, $0.meanDefect, false) }
                            createGraphCard(
                                title: LocalizedStringKey.meanDefect.localized(),
                                data: mdData,
                                valueLabel: { String(format: "%.2f", $0) },
                                color: .orange,
                                normalRange: -2...2,
                                unit: LocalizedStringKey.db.localized(),
                                infoText: LocalizedStringKey.mdTooltip.localized()
                            )

                            // Pattern Standard Deviation (PSD) Graph Card
                            let psdData = viewModel.getSortedMeasurements(for: selectedEye).map { ($0.date, $0.patternStandardDeviation, false) }
                            createGraphCard(
                                title: LocalizedStringKey.patternStandardDeviation.localized(),
                                data: psdData,
                                valueLabel: { String(format: "%.2f", $0) },
                                color: .purple,
                                normalRange: 0...2,
                                unit: LocalizedStringKey.db.localized(),
                                infoText: LocalizedStringKey.psdTooltip.localized()
                            )
                        }

                        // Measurement history section
                        VStack(alignment: .leading, spacing: 12) {
                            // Only show Measurement History title when there's data
                            if !viewModel.getMeasurements(for: selectedEye).isEmpty {
                                Text(LocalizedStringKey.measurementHistory.localized())
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.accentColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                            }
                            if viewModel.getMeasurements(for: selectedEye).isEmpty {
                                VStack {
                                    Spacer()
                                    VStack(spacing: 16) {
                                        VStack(spacing: 12) {
                                            Image("Glaucoma_icon")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(.gray.opacity(0.5))
                                            
                                            Text(LocalizedStringKey.noMeasurements.localized())
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.accentColor.opacity(0.7))
                                            
                                            Text(LocalizedStringKey.addFirstMeasurement.localized())
                                                .font(.subheadline)
                                                .foregroundColor(Color.accentColor.opacity(0.6))
                                                .multilineTextAlignment(.center)
                                        }
                                        // Start Tracking button
                                        Button(action: { showingAddMeasurement = true }) {
                                            HStack(spacing: 10) {
                                                Image(systemName: "plus.circle.fill")
                                                    .font(.title2)
                                                    .fontWeight(.semibold)
                                                Text(LocalizedStringKey.startTracking.localized())
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                            }
                                            .foregroundColor(.white)
                                            .padding(.vertical, 16)
                                            .padding(.horizontal, 24)
                                            .frame(maxWidth: 320)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.8)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .cornerRadius(16)
                                            .shadow(color: Color.accentColor.opacity(0.25), radius: 8, x: 0, y: 4)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    Spacer()
                                }
                            } else {
                                ForEach(viewModel.getMeasurements(for: selectedEye)) { measurement in
                                    GlaucomaMeasurementRow(measurement: measurement, viewModel: viewModel)
                                        .padding(.horizontal)
                                        .padding(.vertical, 4)
                                }
                                // Add Measurement button at end of history
                                HStack {
                                    Spacer()
                                    Button(action: { showingAddMeasurement = true }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.caption)
                                            Text(LocalizedStringKey.addMeasurement.localized())
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                        }
                                        .foregroundColor(.accentColor)
                                    }
                                    Spacer()
                                }
                                .padding(.top, 16)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .navigationTitle(LocalizedStringKey.glaucoma.localized())
        .sheet(isPresented: $showingAddMeasurement) {
            NavigationStack {
                GlaucomaDataEntryView(viewModel: viewModel, selectedEye: selectedEye)
            }
        }
        .sheet(isPresented: $showingInfo) {
            NavigationStack {
                GlaucomaInfoView()
            }
        }
        .task {
            await viewModel.fetchMeasurements()
        }
        .refreshable {
            await viewModel.fetchMeasurements()
        }
        .id(currentLanguage)
    }
    
    private func createGraphCard(
        title: String,
        data: [(Date, Double, Bool)],
        valueLabel: @escaping (Double) -> String,
        color: Color,
        normalRange: ClosedRange<Double>,
        unit: String,
        infoText: String? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.medium)
                }
                Spacer()
                
                let sortedData = data.sorted(by: { $0.0 < $1.0 })
                let displayIndex = selectedDataPointIndex ?? (sortedData.count - 1)
                if sortedData.indices.contains(displayIndex) {
                    let displayValue = sortedData[displayIndex].1
                    let displayDate = sortedData[displayIndex].0
                    VStack(alignment: .trailing, spacing: 2) {
                        HStack(spacing: 4) {
                            Text(valueLabel(displayValue))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(color)
                            Text(unit)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top, 4)
                        }
                        Text(formatDateFull(displayDate))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)

            // Chart content or empty state
            if data.isEmpty {
                // Empty state with message
                VStack(spacing: 16) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    VStack(spacing: 8) {
                        Text(LocalizedStringKey.noData.localized())
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text(LocalizedStringKey.addFirstMeasurementToStart.localized())
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: { showingAddMeasurement = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                                .font(.caption)
                            Text(LocalizedStringKey.addMeasurement.localized())
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.accentColor.opacity(0.6))
                        .cornerRadius(8)
                        .shadow(color: color.opacity(0.2), radius: 2, x: 0, y: 1)
                    }
                }
                .frame(height: 220)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                HStack(spacing: 0) {
                    // Y-axis labels
                    VStack(alignment: .trailing, spacing: 0) {
                        let values = data.map { $0.1 }
                        let minValue = values.min() ?? 0
                        let maxValue = values.max() ?? 1
                        let midValue = (maxValue + minValue) / 2
                        // Top value
                        Text(valueLabel(maxValue))
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(height: 15)
                            .frame(maxWidth: 40, alignment: .trailing)
                            .padding(.trailing, 2)
                        Spacer()
                        // Middle value
                        Text(valueLabel(midValue))
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(height: 20)
                            .frame(maxWidth: 40, alignment: .trailing)
                            .padding(.trailing, 2)
                        Spacer()
                        // Bottom value
                        Text(valueLabel(minValue))
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(height: 20)
                            .frame(maxWidth: 40, alignment: .trailing)
                            .padding(.trailing, 2)
                    }
                    .frame(width: 40)
                    .padding(.top, 15)
                    .padding(.bottom, 30)

                    // Chart
                    InlineChartContentView(
                        data: data.sorted(by: { $0.0 < $1.0 }),
                        color: color,
                        selectedIndex: selectedDataPointIndex,
                        onSelectIndex: { index in
                            withAnimation(.easeInOut(duration: 0.25)) {
                                selectedDataPointIndex = index
                            }
                        },
                        forceShowAllPoints: false,
                        currentLanguage: currentLanguage
                    )
                    .frame(height: 220)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 16)
                }
            }
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .onAppear {
            selectedDataPointIndex = nil
        }
    }
    
    private func formatDateFull(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: currentLanguage == .french ? "fr_FR" : "en_US")
        return formatter.string(from: date)
    }
    
    // Helper function to get measurement type name for empty state
    private func getMeasurementTypeName(_ title: String) -> String {
        if title.contains("IOP") || title.contains("Intraocular Pressure") {
            return "intraocular pressure"
        } else if title.contains("RNFL") || title.contains("Retinal Nerve Fiber Layer") {
            return "RNFL"
        } else if title.contains("GCC") || title.contains("Ganglion Cell") {
            return "GCC"
        } else if title.contains("Mean Defect") || title.contains("MD") {
            return "mean defect"
        } else if title.contains("Pattern Standard Deviation") || title.contains("PSD") {
            return "pattern standard deviation"
        } else {
            return title.lowercased()
        }
    }
}

// Single measurement row component
struct GlaucomaMeasurementRow: View {
    let measurement: GlaucomaMeasurement
    @ObservedObject var viewModel: GlaucomaViewModel
    @State private var showingEditSheet = false
    @State private var showingDeleteConfirmation = false
    @State private var isDeleting = false
    @EnvironmentObject var localizationManager: LocalizationManager
    
    private var currentLanguage: Language {
        localizationManager.currentLanguage
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date and IOP Header with Edit Button
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(formattedDate(measurement.date))
                        .font(.headline)

                    if measurement.isEdited {
                        Text(LocalizedStringKey.edited.localized())
                            .font(.caption2)
                            .foregroundColor(.orange)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                Spacer()
                HStack(spacing: 4) {
                    Text("\(LocalizedStringKey.iop.localized()):")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(String(format: "%.1f", measurement.iop))
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                HStack(spacing: 8) {
                    Button(action: { showingEditSheet = true }) {
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(.accentColor)
                            .padding(8)
                            .background(Color.accentColor.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Button(action: { showingDeleteConfirmation = true }) {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(8)
                            .background(Color.red.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .disabled(isDeleting)
                }
            }
            
            // OCT Measurements
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedStringKey.rnfl.localized())
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(measurement.rnflOverall)")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.green)
                            .fontWeight(.medium)
                        Text(LocalizedStringKey.micrometers.localized())
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedStringKey.macularGcc.localized())
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(measurement.macularGCC)")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.purple)
                            .fontWeight(.medium)
                        Text(LocalizedStringKey.micrometers.localized())
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.vertical, 4)
            
            // Visual Field Measurements
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedStringKey.meanDefect.localized())
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text(String(format: "%.1f", measurement.meanDefect))
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.orange)
                            .fontWeight(.medium)
                        Text(LocalizedStringKey.db.localized())
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedStringKey.patternStandardDeviation.localized())
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text(String(format: "%.1f", measurement.patternStandardDeviation))
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.red)
                            .fontWeight(.medium)
                        Text(LocalizedStringKey.db.localized())
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.vertical, 4)
            
            // Notes if present
            if let notes = measurement.notes, !notes.isEmpty {
                Text(notes)
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .sheet(isPresented: $showingEditSheet) {
            NavigationStack {
                GlaucomaDataEntryView(
                    viewModel: viewModel,
                    selectedEye: measurement.eye,
                    existingMeasurement: measurement
                )
            }
        }
        .alert(LocalizedStringKey.deleteMeasurement.localized(), isPresented: $showingDeleteConfirmation) {
            Button(LocalizedStringKey.cancel.localized(), role: .cancel) { }
            Button(LocalizedStringKey.deleteConfirmation.localized(), role: .destructive) {
                deleteMeasurement()
            }
        } message: {
            Text(LocalizedStringKey.deleteMeasurementConfirmation.localized())
        }
    }
    
    private func deleteMeasurement() {
        isDeleting = true
        Task {
            do {
                try await viewModel.deleteMeasurement(measurement)
                await MainActor.run {
                    isDeleting = false
                }
            } catch {
                await MainActor.run {
                    isDeleting = false
                    // Handle error - could show an alert here
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: currentLanguage == .french ? "fr_FR" : "en_US")
        return formatter.string(from: date)
    }
}

// Info view for Glaucoma
struct GlaucomaInfoView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    
    private var currentLanguage: Language {
        localizationManager.currentLanguage
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text(LocalizedStringKey.aboutGlaucoma.localized())
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(LocalizedStringKey.glaucomaDescription.localized())
                        .font(.body)
                }
                
                Group {
                    Text(LocalizedStringKey.keyMeasurements.localized())
                        .font(.headline)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        measurementSection(
                            title: LocalizedStringKey.intraocularPressure.localized(),
                            description: LocalizedStringKey.iopTooltip.localized()
                        )
                        
                        measurementSection(
                            title: LocalizedStringKey.visualFieldParameters.localized(),
                            description: LocalizedStringKey.averageSensitivityLoss.localized()
                        )
                        
                        measurementSection(
                            title: LocalizedStringKey.retinalNerveFiberLayer.localized(),
                            description: LocalizedStringKey.thicknessNerveFibers.localized()
                        )
                        
                        measurementSection(
                            title: LocalizedStringKey.macularGanglionCellComplex.localized(),
                            description: LocalizedStringKey.thicknessGanglionCells.localized()
                        )
                    }
                }
                
                Group {
                    Text(LocalizedStringKey.riskFactors.localized())
                        .font(.headline)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        measurementSection(
                            title: LocalizedStringKey.familyHistory.localized(),
                            description: LocalizedStringKey.familyHistoryDescription.localized()
                        )
                        
                        measurementSection(
                            title: LocalizedStringKey.lasikSurgery.localized(),
                            description: LocalizedStringKey.lasikSurgeryDescription.localized()
                        )
                    }
                }
                
                Group {
                    Text(LocalizedStringKey.warningSigns.localized())
                        .font(.headline)
                        .padding(.top)
                    
                    Text(LocalizedStringKey.warningSignsDescription.localized())
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .navigationTitle(LocalizedStringKey.glaucomaInformation.localized())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func measurementSection(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            Text(description)
                .font(.callout)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

struct EmptyChartView: View {
    let message: String
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.1))
            .frame(height: 200)
            .overlay(
                VStack {
                    Image(systemName: "chart.line.downtrend.xyaxis")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .padding(.bottom, 4)
                    Text(message)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            )
            .cornerRadius(8)
            .padding(.horizontal)
    }
}

private struct ChartData {
    let data: [(Date, Double, Bool)]
    let geometry: GeometryProxy
    let selectedIndex: Int?
    
    var minValue: Double { data.map { $0.1 }.min() ?? 0 }
    var maxValue: Double { data.map { $0.1 }.max() ?? 1 }
    var midValue: Double { (maxValue + minValue) / 2 }
    var chartHeight: CGFloat { geometry.size.height * 0.85 }
    var topPadding: CGFloat { 10 }
    var availableWidth: CGFloat { geometry.size.width - 40 }
    var yScale: CGFloat { chartHeight / max((maxValue - minValue), 1) }
    
    func calculateY(_ value: Double) -> CGFloat {
        topPadding + chartHeight - ((value - minValue) * yScale)
    }
    
    func calculateX(_ index: Int) -> CGFloat {
        CGFloat(index) / CGFloat(max(data.count - 1, 1)) * availableWidth + 20
    }
}

private struct GridLinesView: View {
    let chartData: ChartData
    
    var body: some View {
        // Horizontal grid lines
        ForEach([chartData.minValue, chartData.midValue, chartData.maxValue], id: \.self) { val in
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .position(x: chartData.geometry.size.width / 2, y: chartData.calculateY(val))
        }
        
        // Vertical grid lines
        let indices = getVerticalGridIndices()
        ForEach(indices, id: \.self) { i in
            let x = chartData.calculateX(i)
            Path { path in
                path.move(to: CGPoint(x: x, y: chartData.topPadding))
                path.addLine(to: CGPoint(x: x, y: chartData.topPadding + chartData.chartHeight))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            .foregroundColor(Color.gray.opacity(0.15))
        }
    }
    
    private func getVerticalGridIndices() -> [Int] {
        guard !chartData.data.isEmpty else { return [] }
        let last = chartData.data.count - 1
        let mid = chartData.data.count > 2 ? last / 2 : (chartData.data.count == 2 ? 1 : 0)
        return [0, mid, last].removingDuplicates()
    }
}

private struct ChartPathView: View {
    let chartData: ChartData
    let color: Color
    
    var body: some View {
        // Main path
        Path { path in
            guard !chartData.data.isEmpty else { return }
            let startX = 20.0
            path.move(to: CGPoint(x: startX, y: chartData.calculateY(chartData.data[0].1)))
            
            for i in 1..<chartData.data.count {
                let x = chartData.calculateX(i)
                let y = chartData.calculateY(chartData.data[i].1)
                let prevX = chartData.calculateX(i - 1)
                let prevY = chartData.calculateY(chartData.data[i - 1].1)
                
                let control1 = CGPoint(x: prevX + (x - prevX) / 2, y: prevY)
                let control2 = CGPoint(x: prevX + (x - prevX) / 2, y: y)
                path.addCurve(to: CGPoint(x: x, y: y), control1: control1, control2: control2)
            }
        }
        .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        
        // Fill gradient
        Path { path in
            guard !chartData.data.isEmpty else { return }
            let startX = 20.0
            let startY = chartData.calculateY(chartData.data[0].1)
            path.move(to: CGPoint(x: startX, y: chartData.chartHeight + chartData.topPadding))
            path.addLine(to: CGPoint(x: startX, y: startY))
            
            for i in 1..<chartData.data.count {
                let x = chartData.calculateX(i)
                let y = chartData.calculateY(chartData.data[i].1)
                let prevX = chartData.calculateX(i - 1)
                let prevY = chartData.calculateY(chartData.data[i - 1].1)
                
                let control1 = CGPoint(x: prevX + (x - prevX) / 2, y: prevY)
                let control2 = CGPoint(x: prevX + (x - prevX) / 2, y: y)
                path.addCurve(to: CGPoint(x: x, y: y), control1: control1, control2: control2)
            }
            path.addLine(to: CGPoint(x: chartData.availableWidth + 20, y: chartData.chartHeight + chartData.topPadding))
            path.closeSubpath()
        }
        .fill(LinearGradient(
            gradient: Gradient(colors: [color.opacity(0.3), color.opacity(0.05)]),
            startPoint: .top,
            endPoint: .bottom
        ))
    }
}

private struct DataPointsView: View {
    let chartData: ChartData
    let color: Color
    let onSelectIndex: (Int) -> Void
    
    var body: some View {
        ForEach(0..<chartData.data.count, id: \.self) { index in
            let x = chartData.calculateX(index)
            let y = chartData.calculateY(chartData.data[index].1)
            let point = CGPoint(x: x, y: y)
            let isSelected = index == (chartData.selectedIndex ?? (chartData.data.count - 1))
            let isCrossLinking = chartData.data[index].2
            let shouldShowTapArea = index % 2 == 0 || index == chartData.data.count - 1 || index == (chartData.selectedIndex ?? -1)
            
            // Data point visualization
            if isSelected {
                // Selection indicator
                Rectangle()
                    .fill(isCrossLinking ? Color.red.opacity(0.3) : color.opacity(0.3))
                    .frame(width: 1, height: chartData.chartHeight)
                    .position(x: point.x, y: chartData.topPadding + chartData.chartHeight / 2)
                
                // Selected point
                Circle()
                    .fill(Color.white)
                    .frame(width: 16, height: 16)
                    .position(point)
                
                Circle()
                    .fill(isCrossLinking ? .red : color)
                    .frame(width: 10, height: 10)
                    .position(point)
            } else {
                // Unselected point
                Circle()
                    .fill(isCrossLinking ? Color.red.opacity(0.3) : color.opacity(0.3))
                    .frame(width: 6, height: 6)
                    .position(point)
            }
            
            // Tap area
            if shouldShowTapArea {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 44, height: 44)
                    .position(point)
                    .onTapGesture {
                        onSelectIndex(index)
                    }
            }
        }
    }
}

private struct XAxisView: View {
    let data: [(Date, Double, Bool)]
    let geometry: GeometryProxy
    let currentLanguage: Language
    
    var body: some View {
        ZStack(alignment: .top) {
            let step = data.count > 1 ? max(1, (data.count - 1) / 2) : 1
            let horizontalPadding: CGFloat = 20
            let availableWidth = geometry.size.width - 2 * horizontalPadding
            
            ForEach(0..<data.count, id: \.self) { i in
                if i % step == 0 || i == data.count - 1 {
                    let x = horizontalPadding + CGFloat(i) / CGFloat(max(data.count - 1, 1)) * availableWidth
                    VStack(spacing: 2) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 1, height: 5)
                        Text(formatDateShort(data[i].0))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .position(x: x, y: 15)
                }
            }
        }
        .frame(height: 25)
    }
    
    private func formatDateShort(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        formatter.locale = Locale(identifier: currentLanguage == .french ? "fr_FR" : "en_US")
        return formatter.string(from: date)
    }
}

private struct InlineChartContentView: View {
    let data: [(Date, Double, Bool)]
    let color: Color
    let selectedIndex: Int?
    let onSelectIndex: (Int) -> Void
    let forceShowAllPoints: Bool
    let currentLanguage: Language

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .leading) {
                    let chartData = ChartData(
                        data: data,
                        geometry: geometry,
                        selectedIndex: selectedIndex
                    )
                    
                    // Grid lines
                    GridLinesView(chartData: chartData)
                    
                    // Chart path
                    ChartPathView(chartData: chartData, color: color)
                    
                    // Data points
                    DataPointsView(
                        chartData: chartData,
                        color: color,
                        onSelectIndex: onSelectIndex
                    )
                }
                .frame(height: 180)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            guard !data.isEmpty else { return }
                            let tapPositionFraction = value.location.x / geometry.size.width
                            let index = Int((tapPositionFraction * CGFloat(data.count - 1)).rounded())
                            if index >= 0 && index < data.count {
                                onSelectIndex(index)
                            }
                        }
                )

                // X-Axis
                XAxisView(data: data, geometry: geometry, currentLanguage: currentLanguage)
            }
        }
        .frame(height: 210)
    }
}

