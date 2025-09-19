import SwiftUI
import Charts

struct KeratoconusView: View {
    @StateObject private var viewModel = KeratoconusViewModel()
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var selectedEye: EyeType = .OD
    @State private var showingAddMeasurement = false
    @State private var showingDeleteConfirmation = false
    @State private var measurementToDelete: KeratoconusMeasurement?
    @State private var selectedDataPointIndex: Int? = nil
    @State private var showingInfo = false
    
    // Force view updates when language changes
    private var currentLanguage: Language {
        localizationManager.currentLanguage
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Disease Info Card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(LocalizedStringKey.aboutKeratoconus.localized())
                        .font(.headline)
                    Spacer()
                    Button {
                        showingInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                    }
                }
                
                Text(LocalizedStringKey.keratoconusDescription.localized())
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Eye selector
            EyeToggleView(selectedEye: $selectedEye)
                .padding()
            
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
            
            // Graphs section
            ScrollView {
                VStack(spacing: 20) {
                    if !viewModel.getMeasurements(for: selectedEye).isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // K2 Graph
                            createGraphCard(
                                title: LocalizedStringKey.k2Values.localized(),
                                data: viewModel.getMeasurements(for: selectedEye).map { ($0.date, $0.k2, $0.hasCrossLinking) },
                                valueLabel: { String(format: "%.1f", $0) },
                                color: .blue,
                                normalRange: 41.0...46.0,
                                unit: LocalizedStringKey.diopters.localized(),
                                infoText: LocalizedStringKey.k2Tooltip.localized()
                            )
                            
                            // K Max Graph
                            createGraphCard(
                                title: LocalizedStringKey.kMaxValues.localized(),
                                data: viewModel.getMeasurements(for: selectedEye).map { ($0.date, $0.kMax, $0.hasCrossLinking) },
                                valueLabel: { String(format: "%.1f", $0) },
                                color: .orange,
                                normalRange: 41.0...46.0,
                                unit: LocalizedStringKey.diopters.localized(),
                                infoText: LocalizedStringKey.kMaxTooltip.localized()
                            )
                            
                            // Thinnest Pachymetry Graph
                            createGraphCard(
                                title: LocalizedStringKey.thinnestPachymetry.localized(),
                                data: viewModel.getMeasurements(for: selectedEye).map { ($0.date, Double($0.thinnestPachymetry), $0.hasCrossLinking) },
                                valueLabel: { String(format: "%.0f", $0) },
                                color: .green,
                                normalRange: 500.0...600.0,
                                unit: LocalizedStringKey.micrometers.localized(),
                                infoText: LocalizedStringKey.pachymetryTooltip.localized()
                            )
                            
                            // Epithelial Thickness Graphs
                            createGraphCard(
                                title: LocalizedStringKey.epithelialThickness.localized(),
                                data: viewModel.getMeasurements(for: selectedEye).map { ($0.date, $0.thickestEpithelialSpot, $0.hasCrossLinking) },
                                valueLabel: { String(format: "%.0f", $0) },
                                color: .purple,
                                normalRange: 50...60,
                                unit: LocalizedStringKey.micrometers.localized(),
                                subtitle: LocalizedStringKey.thickestSpot.localized(),
                                infoText: LocalizedStringKey.epithelialTooltip.localized()
                            )
                            
                            createGraphCard(
                                title: LocalizedStringKey.epithelialThickness.localized(),
                                data: viewModel.getMeasurements(for: selectedEye).map { ($0.date, Double($0.thinnestEpithelialSpot), $0.hasCrossLinking) },
                                valueLabel: { String(format: "%.0f", $0) },
                                color: .indigo,
                                normalRange: 38...50,
                                unit: LocalizedStringKey.micrometers.localized(),
                                subtitle: LocalizedStringKey.thinnestSpot.localized(),
                                infoText: LocalizedStringKey.epithelialTooltip.localized()
                            )
                            
                            // Risk Score Graph
                            createGraphCard(
                                title: LocalizedStringKey.keratoconusRiskScore.localized(),
                                data: viewModel.getMeasurements(for: selectedEye).map { ($0.date, Double($0.keratoconusRiskScore), $0.hasCrossLinking) },
                                valueLabel: { String(format: "%.0f", $0) },
                                color: .yellow,
                                normalRange: 0.0...3.0,
                                unit: "",
                                subtitle: "\(LocalizedStringKey.lowRisk.localized()), \(LocalizedStringKey.highRisk.localized())",
                                infoText: LocalizedStringKey.riskScoreTooltip.localized()
                            )
                        }
                        // Add star legend at the bottom of all graphs if any measurement hasCrossLinking
                        if viewModel.getMeasurements(for: selectedEye).contains(where: { $0.hasCrossLinking }) {
                            HStack(spacing: 6) {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.red)
                                Text(" \(LocalizedStringKey.crosslinkingPerformed.localized())")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 8)
                        }
                    }
                    
                    // Measurements list
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
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else if viewModel.getMeasurements(for: selectedEye).isEmpty {
                            VStack {
                                Spacer()
                                VStack(spacing: 16) {
                                    VStack(spacing: 12) {
                                        Image(systemName: "eye")
                                            .font(.system(size: 60))
                                            .foregroundColor(.gray.opacity(0.5))
                                        
                                        Text(LocalizedStringKey.noMeasurements.localized())
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.accentColor.opacity(0.7))
                                        
                                        Text(LocalizedStringKey.addFirstMeasurementToTrack.localized())
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
                                KeratoconusMeasurementRow(measurement: measurement, viewModel: viewModel)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        measurementToDelete = measurement
                                        showingDeleteConfirmation = true
                                    }
                            }
                        }
                        // Add Measurement button at end of history (only when there's data)
                        if !viewModel.getMeasurements(for: selectedEye).isEmpty {
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
        .navigationTitle(LocalizedStringKey.keratoconus.localized())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddMeasurement) {
            NavigationStack {
                KeratoconusDataEntryView(viewModel: viewModel, selectedEye: selectedEye)
            }
        }
        .alert(LocalizedStringKey.deleteMeasurement.localized(), isPresented: $showingDeleteConfirmation) {
            Button(LocalizedStringKey.cancel.localized(), role: .cancel) { }
            Button(LocalizedStringKey.delete.localized(), role: .destructive) {
                if let measurement = measurementToDelete {
                    Task {
                        try? await viewModel.deleteMeasurement(measurement)
                    }
                }
            }
        } message: {
            Text(LocalizedStringKey.deleteConfirmationMessage.localized())
        }
        .task {
            await viewModel.fetchMeasurements()
        }
        .refreshable {
            await viewModel.fetchMeasurements()
        }
        .background(Color(.systemBackground))
        .sheet(isPresented: $showingInfo) {
            NavigationStack {
                KeratoconusInfoView()
            }
        }
        .id(currentLanguage) // Force re-render on language change
    }
    
    // MARK: - Chart Card
    private func createGraphCard(
        title: String,
        data: [(Date, Double, Bool)],
        valueLabel: @escaping (Double) -> String,
        color: Color,
        normalRange: ClosedRange<Double>,
        unit: String,
        subtitle: String? = nil,
        infoText: String? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                        .fontWeight(.medium)
                    
                if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                        .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Show the selected value with highlighted display
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
                // Y-axis labels
                HStack(spacing: 0) {
                    VStack(alignment: .trailing, spacing: 0) {
                        let range = Self.getValueRange(data)
                        let minValue = range.lowerBound
                        let maxValue = range.upperBound
                        let midValue = (maxValue + minValue) / 2
                        
                        // Top value
                        Text(valueLabel(maxValue))
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(height: 20)
                            .frame(maxWidth: 40, alignment: .trailing)
                            .padding(.trailing, 2)
                        
                        Spacer()
                        
                        // Middle value
                        Text(valueLabel(midValue))
                            .font(.caption2)
                            .foregroundColor(.gray)
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
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    let sortedData = data.sorted(by: { $0.0 < $1.0 })
                    
                    // Main chart area
                        ChartContentView(
                            data: sortedData,
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
    
    // Helper function to get measurement type name for empty state
    private func getMeasurementTypeName(_ title: String) -> String {
        if title.contains("K2") {
            return "K2"
        } else if title.contains("K Max") {
            return "K Max"
        } else if title.contains("Pachymetry") {
            return "pachymetry"
        } else if title.contains("Epithelial") {
            return "epithelial thickness"
        } else if title.contains("Risk Score") {
            return "risk score"
        } else {
            return title.lowercased()
        }
    }
    
    // Helper to get value range
    static func getValueRange(_ data: [(Date, Double, Bool)]) -> ClosedRange<Double> {
        guard !data.isEmpty else { return 0...1 }
        let values = data.map { $0.1 }
        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 1
        if minValue == maxValue {
            return (minValue - 0.5)...(maxValue + 0.5)
        }
        return minValue...maxValue
    }
    
    private func formatDateFull(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: currentLanguage == .french ? "fr_FR" : "en_US")
        return formatter.string(from: date)
    }
    
    // MARK: - Chart Content View
    private struct ChartContentView: View {
        let data: [(Date, Double, Bool)]
        let color: Color
        let selectedIndex: Int?
        let onSelectIndex: (Int) -> Void
        let forceShowAllPoints: Bool
        let currentLanguage: Language
        
        // Static date formatter
        private static func formatDateShort(_ date: Date, language: Language = .english) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d" // (e.g., "Apr 7")
            formatter.locale = Locale(identifier: language == .french ? "fr_FR" : "en_US")
            return formatter.string(from: date)
        }
        
        var body: some View {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Main chart area (without x-axis)
                    ZStack(alignment: .leading) {
                        let range = KeratoconusView.getValueRange(data)
                        let minValue = range.lowerBound
                        let maxValue = range.upperBound
                        let midValue = (maxValue + minValue) / 2
                        
                        // Add a small padding to the value range
                        let valueRange = maxValue - minValue
                        let paddedMinValue = max(0, minValue - (valueRange * 0.05))
                        let paddedMaxValue = maxValue + (valueRange * 0.05)
                        
                        let chartHeight = geometry.size.height * 0.85
                        let topPadding: CGFloat = 10
                        
                        let yScale = chartHeight / (paddedMaxValue - paddedMinValue)
                        
                        // Calculate helper with padding included
                        let calculateYPosition: (Double) -> CGFloat = { value in
                            topPadding + chartHeight - ((value - paddedMinValue) * yScale)
                        }
                        
                        // Top grid line (max value)
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                            .frame(width: geometry.size.width)
                            .position(x: geometry.size.width / 2, y: calculateYPosition(maxValue))
                        
                        // Middle grid line
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                            .frame(width: geometry.size.width)
                            .position(x: geometry.size.width / 2, y: calculateYPosition(midValue))
                        
                        // Bottom grid line (min value)
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                            .frame(width: geometry.size.width)
                            .position(x: geometry.size.width / 2, y: calculateYPosition(minValue))
                        
                        // Calculate step for vertical grid lines
                        let maxGridLines = 3
                        let step = data.count > 1 ? max(1, (data.count - 1) / (maxGridLines - 1)) : 1
                        
                        // Vertical grid lines at each data point
                        ForEach(0..<data.count, id: \.self) { index in
                            if index % step == 0 || index == data.count - 1 {
                                let xPosition = CGFloat(index) / CGFloat(max(data.count - 1, 1)) * geometry.size.width
                                Path { path in
                                    path.move(to: CGPoint(x: xPosition, y: topPadding))
                                    path.addLine(to: CGPoint(x: xPosition, y: topPadding + chartHeight))
                                }
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                                .foregroundColor(Color.gray.opacity(0.15))
                            }
                        }
                        
                        // Chart path
                        Path { path in
                            guard !data.isEmpty else { return }
                            
                            var startPoint = CGPoint(
                                x: 0,
                                y: calculateYPosition(data[0].1)
                            )
                            path.move(to: startPoint)
                            
                            for i in 1..<data.count {
                                let point = CGPoint(
                                    x: CGFloat(i) / CGFloat(max(data.count - 1, 1)) * geometry.size.width,
                                    y: calculateYPosition(data[i].1)
                                )
                                
                                // Use a smooth curve
                                let control1 = CGPoint(
                                    x: startPoint.x + (point.x - startPoint.x) / 2,
                                    y: startPoint.y
                                )
                                let control2 = CGPoint(
                                    x: startPoint.x + (point.x - startPoint.x) / 2,
                                    y: point.y
                                )
                                
                                path.addCurve(to: point, control1: control1, control2: control2)
                                startPoint = point
                            }
                        }
                        .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        
                        // Area gradient under the path
                        Path { path in
                            guard !data.isEmpty else { return }
                            
                            let chartHeight = geometry.size.height * 0.85
                            
                            var startPoint = CGPoint(
                                x: 0,
                                y: calculateYPosition(data[0].1)
                            )
                            path.move(to: CGPoint(x: startPoint.x, y: chartHeight + topPadding))
                            path.addLine(to: startPoint)
                            
                            for i in 1..<data.count {
                                let point = CGPoint(
                                    x: CGFloat(i) / CGFloat(max(data.count - 1, 1)) * geometry.size.width,
                                    y: calculateYPosition(data[i].1)
                                )
                                
                                // Use a smooth curve for the area gradient too
                                let control1 = CGPoint(
                                    x: startPoint.x + (point.x - startPoint.x) / 2,
                                    y: startPoint.y
                                )
                                let control2 = CGPoint(
                                    x: startPoint.x + (point.x - startPoint.x) / 2,
                                    y: point.y
                                )
                                
                                path.addCurve(to: point, control1: control1, control2: control2)
                                startPoint = point
                            }
                            
                            path.addLine(to: CGPoint(x: geometry.size.width, y: chartHeight + topPadding))
                            path.closeSubpath()
                        }
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [color.opacity(0.3), color.opacity(0.05)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        
                        // Bottom border line to separate chart from x-axis
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                            .position(x: geometry.size.width / 2, y: chartHeight + topPadding)
                        
                        // Data points with selection
                        ForEach(0..<data.count, id: \.self) { index in
                            let xPosition = CGFloat(index) / CGFloat(max(data.count - 1, 1)) * geometry.size.width
                            let yPosition = calculateYPosition(data[index].1)
                            let point = CGPoint(x: xPosition, y: yPosition)
                            let isCrossLinking = data[index].2

                            // Always show small circle for every data point
                            if index == (selectedIndex ?? (data.count - 1)) {
                                // Selection indicator vertical line
                                Rectangle()
                                    .fill(isCrossLinking ? Color.red.opacity(0.3) : color.opacity(0.3))
                                    .frame(width: 1, height: chartHeight)
                                    .position(x: point.x, y: topPadding + chartHeight / 2)

                                // Outer circle (white ring)
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 16, height: 16)
                                    .position(point)

                                // Inner circle (colored dot)
                                Circle()
                                    .fill(isCrossLinking ? .red : color)
                                    .frame(width: 10, height: 10)
                                    .position(point)
                            } else {
                                // Unselected data points
                                Circle()
                                    .fill(isCrossLinking ? Color.red.opacity(0.3) : color.opacity(0.3))
                                    .frame(width: 6, height: 6)
                                    .position(point)
                            }

                            // Larger tap area for interaction (only for step/last/selected)
                            if index % step == 0 || index == data.count - 1 || index == (selectedIndex ?? -1) {
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
                    
                    // X-axis labels
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 2)
                    
                    ZStack(alignment: .top) {
                        let maxGridLines = 3
                        let step = data.count > 1 ? max(1, (data.count - 1) / (maxGridLines - 1)) : 1
                        
                        ForEach(0..<data.count, id: \.self) { index in
                            if index % step == 0 || index == data.count - 1 {
                                let xPosition = CGFloat(index) / CGFloat(max(data.count - 1, 1)) * geometry.size.width
                                
                                VStack(spacing: 2) {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.5))
                                        .frame(width: 1, height: 5)
                                    
                                    Text(Self.formatDateShort(data[index].0, language: currentLanguage))
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                .position(x: xPosition, y: 15)
                            }
                        }
                    }
                    .frame(height: 25)
                }
            }
            .frame(height: 210)
        }
    }
}

// Row for displaying a measurement in the list
struct KeratoconusMeasurementRow: View {
    let measurement: KeratoconusMeasurement
    @ObservedObject var viewModel: KeratoconusViewModel
    @State private var showingEditSheet = false
    @State private var showingDeleteConfirmation = false
    @State private var isDeleting = false
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with date, time, risk score, and action buttons
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(formattedDate(measurement.date))
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        if measurement.isEdited {
                            Text(LocalizedStringKey.edited.localized())
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.orange)
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(formattedTime(measurement.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Risk score badge
                VStack(spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption2)
                            .foregroundColor(riskColor(score: measurement.keratoconusRiskScore))
                        Text("\(measurement.keratoconusRiskScore)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(riskColor(score: measurement.keratoconusRiskScore))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(riskColor(score: measurement.keratoconusRiskScore).opacity(0.15))
                    .cornerRadius(12)
                    
                    Text(LocalizedStringKey.keratoconusRiskScore.localized())
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                // Action buttons
                HStack(spacing: 6) {
                    Button(action: { showingEditSheet = true }) {
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(.accentColor)
                            .frame(width: 32, height: 32)
                            .background(Color.accentColor.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Button(action: { showingDeleteConfirmation = true }) {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(width: 32, height: 32)
                            .background(Color.red.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .disabled(isDeleting)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // Main measurements section
            VStack(spacing: 16) {
                // Top row - K values
                HStack(spacing: 0) {
                    // K2 Value
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "circle.grid.cross")
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text(LocalizedStringKey.k2Values.localized())
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(String(format: "%.1f", measurement.k2))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            Text(LocalizedStringKey.diopters.localized())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // K2 status indicator
                        HStack(spacing: 4) {
                            Circle()
                                .fill(k2StatusColor(measurement.k2))
                                .frame(width: 8, height: 8)
                            Text(k2StatusText(measurement.k2))
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(k2StatusColor(measurement.k2))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                        .frame(height: 60)
                        .padding(.horizontal, 16)
                    
                    // KMax Value
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "circle.grid.cross.fill")
                                .font(.caption)
                                .foregroundColor(.red)
                            Text(LocalizedStringKey.kMaxValues.localized())
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(String(format: "%.1f", measurement.kMax))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            Text(LocalizedStringKey.diopters.localized())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // KMax status indicator
                        HStack(spacing: 4) {
                            Circle()
                                .fill(kMaxStatusColor(measurement.kMax))
                                .frame(width: 8, height: 8)
                            Text(kMaxStatusText(measurement.kMax))
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(kMaxStatusColor(measurement.kMax))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Bottom row - Thickness measurements
                HStack(spacing: 0) {
                    // Thinnest Pachymetry
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "ruler")
                                .font(.caption)
                                .foregroundColor(.green)
                            Text(LocalizedStringKey.thinnestPachymetry.localized())
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("\(measurement.thinnestPachymetry)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            Text(LocalizedStringKey.micrometers.localized())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Pachymetry status indicator
                        HStack(spacing: 4) {
                            Circle()
                                .fill(pachymetryStatusColor(measurement.thinnestPachymetry))
                                .frame(width: 8, height: 8)
                            Text(pachymetryStatusText(measurement.thinnestPachymetry))
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(pachymetryStatusColor(measurement.thinnestPachymetry))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                        .frame(height: 60)
                        .padding(.horizontal, 16)
                    
                    // Epithelial Thickness
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "layers")
                                .font(.caption)
                                .foregroundColor(.purple)
                            Text(LocalizedStringKey.epithelialThickness.localized())
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("\(measurement.thickestEpithelialSpot)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                            Text(LocalizedStringKey.micrometers.localized())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Epithelial status indicator
                        HStack(spacing: 4) {
                            Circle()
                                .fill(epithelialStatusColor(measurement.thickestEpithelialSpot))
                                .frame(width: 8, height: 8)
                            Text(epithelialStatusText(measurement.thickestEpithelialSpot))
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(epithelialStatusColor(measurement.thickestEpithelialSpot))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            // Status indicators and notes section
            if measurement.documentedCylindricalIncrease || measurement.subjectiveVisionLoss || measurement.hasCrossLinking || measurement.notes != nil {
                Divider()
                    .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    // Status indicators
                    HStack(spacing: 12) {
                        if measurement.documentedCylindricalIncrease {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                                Text(LocalizedStringKey.cylindricalIncrease.localized())
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        if measurement.subjectiveVisionLoss {
                            HStack(spacing: 4) {
                                Image(systemName: "eye.slash.fill")
                                    .font(.caption2)
                                    .foregroundColor(.red)
                                Text(LocalizedStringKey.visionLoss.localized())
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        if measurement.hasCrossLinking {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                                Text(LocalizedStringKey.crossLinking.localized())
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    // Notes
                    if let notes = measurement.notes, !notes.isEmpty {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "note.text")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 2)
                            Text(notes)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .sheet(isPresented: $showingEditSheet) {
            NavigationStack {
                KeratoconusDataEntryView(
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
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: localizationManager.currentLanguage == .french ? "fr_FR" : "en_US")
        return formatter.string(from: date)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: localizationManager.currentLanguage == .french ? "fr_FR" : "en_US")
        return formatter.string(from: date)
    }
    
    private func riskColor(score: Int) -> Color {
        switch score {
        case 0...2: return .green
        case 3...5: return .yellow
        case 6...8: return .orange
        case 9...10: return .red
        default: return .gray
        }
    }
    
    private func k2StatusColor(_ k2: Double) -> Color {
        switch k2 {
        case 0..<45: return .green
        case 45..<50: return .yellow
        case 50..<55: return .orange
        default: return .red
        }
    }
    
    private func k2StatusText(_ k2: Double) -> String {
        switch k2 {
        case 0..<45: return "Normal"
        case 45..<50: return "Mild"
        case 50..<55: return "Moderate"
        default: return "Severe"
        }
    }
    
    private func kMaxStatusColor(_ kMax: Double) -> Color {
        switch kMax {
        case 0..<47: return .green
        case 47..<52: return .yellow
        case 52..<57: return .orange
        default: return .red
        }
    }
    
    private func kMaxStatusText(_ kMax: Double) -> String {
        switch kMax {
        case 0..<47: return "Normal"
        case 47..<52: return "Mild"
        case 52..<57: return "Moderate"
        default: return "Severe"
        }
    }
    
    private func pachymetryStatusColor(_ pachymetry: Int) -> Color {
        switch pachymetry {
        case 500...: return .green
        case 450..<500: return .yellow
        case 400..<450: return .orange
        default: return .red
        }
    }
    
    private func pachymetryStatusText(_ pachymetry: Int) -> String {
        switch pachymetry {
        case 500...: return "Normal"
        case 450..<500: return "Thin"
        case 400..<450: return "Very Thin"
        default: return "Critical"
        }
    }
    
    private func epithelialStatusColor(_ epithelial: Double) -> Color {
        switch epithelial {
        case 50..<60: return .green
        case 40..<50: return .yellow
        case 30..<40: return .orange
        default: return .red
        }
    }
    
    private func epithelialStatusText(_ epithelial: Double) -> String {
        switch epithelial {
        case 50..<60: return "Normal"
        case 40..<50: return "Thin"
        case 30..<40: return "Very Thin"
        default: return "Critical"
        }
    }
}

// Boolean indicator view
struct BooleanIndicator: View {
    let label: String
    let value: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: value ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(value ? .green : .red)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// Add KeratoconusInfoView
struct KeratoconusInfoView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    
    // Force view updates when language changes
    private var currentLanguage: Language {
        localizationManager.currentLanguage
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text(LocalizedStringKey.aboutKeratoconus.localized())
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(LocalizedStringKey.keratoconusSurgicalProcedure.localized())
                        .font(.body)
                }
                
                Group {
                    Text(LocalizedStringKey.keyMeasurements.localized())
                        .font(.headline)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        measurementSection(
                            title: LocalizedStringKey.k2Values.localized(),
                            description: LocalizedStringKey.k2Tooltip.localized()
                        )
                        
                        measurementSection(
                            title: LocalizedStringKey.kMaxValues.localized(),
                            description: LocalizedStringKey.kMaxTooltip.localized()
                        )
                        
                        measurementSection(
                            title: LocalizedStringKey.thinnestPachymetry.localized(),
                            description: LocalizedStringKey.pachymetryTooltip.localized()
                        )
                        
                        measurementSection(
                            title: LocalizedStringKey.epithelialThickness.localized(),
                            description: LocalizedStringKey.epithelialTooltip.localized()
                        )
                        
                        measurementSection(
                            title: LocalizedStringKey.keratoconusRiskScore.localized(),
                            description: LocalizedStringKey.riskScoreTooltip.localized()
                        )
                    }
                }
                
                Group {
                    Text(LocalizedStringKey.treatmentOptions.localized())
                        .font(.headline)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        treatmentSection(
                            title: LocalizedStringKey.crossLinkingCxl.localized(),
                            description: LocalizedStringKey.crossLinkingDescription.localized()
                        )
                        
                        treatmentSection(
                            title: LocalizedStringKey.specialtyContactLenses.localized(),
                            description: LocalizedStringKey.specialtyLensesDescription.localized()
                        )
                        
                        treatmentSection(
                            title: LocalizedStringKey.intacs.localized(),
                            description: LocalizedStringKey.intacsDescription.localized()
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
        .navigationTitle(LocalizedStringKey.keratoconusInformation.localized())
        .navigationBarTitleDisplayMode(.inline)
        .id(currentLanguage) // Force re-render on language change
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
    
    private func treatmentSection(title: String, description: String) -> some View {
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

