import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var selectedTab = 0
    @State private var previousTab = 0
    @State private var showingLanguageMenu = false
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        appearance.backgroundColor = .clear
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        let offset = UIOffset(horizontal: 0, vertical: 4)
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = offset
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = offset
        
        // Remove the problematic imageInsets setting that causes threading issues
        // UITabBarItem.appearance().imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            MyHealthView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(LocalizedStringKey.home.localized())
                }
                .tag(0)
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text(LocalizedStringKey.profile.localized())
                }
                .tag(1)
            
            // Language Dropdown Tab - Empty view that shows language menu
            Color.clear
                .tabItem {
                    Image(systemName: "globe")
                    Text(localizationManager.currentLanguage == .english ? "EN" : "FR")
                }
                .tag(2)
        }
        .tint(Color(red: 68/255, green: 55/255, blue: 235/255))
        .onChange(of: selectedTab) { _, newValue in
            if newValue == 2 {
                // Show language menu when language tab is selected
                showingLanguageMenu = true
                // Immediately reset to previous tab to keep current view active
                selectedTab = previousTab
            } else if newValue != 2 {
                // Track the previous tab (only for non-language tabs)
                previousTab = newValue
            }
        }
        .confirmationDialog("Select Language", isPresented: $showingLanguageMenu) {
            Button("EN") {
                localizationManager.setLanguage(.english)
            }
            Button("FR") {
                localizationManager.setLanguage(.french)
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AuthViewModel())
            .environmentObject(LocalizationManager.shared)
    }
}

