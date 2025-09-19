//
//  HauteVisionApp.swift
//  HauteVision
//
//  Created by romi bonomo on 2025-03-09.
//

//Website Colors:
//  Gray: FAF9FD 
//  Purple: E8DEF5
//  Green: CEFFAE
//  White: FFFFFF
//  DarkGray: EEEEEE
//  Black: 000000
//  DarkPurple: E0D3F1
//  MainBlue: 4437EB

import SwiftUI
import FirebaseCore
import FirebaseAuth
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        // Set notification center delegate
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Handle notification delivery and reschedule for custom intervals
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let interval = userInfo["customInterval"] as? TimeInterval,
           let medicationName = userInfo["medicationName"] as? String {
            // Schedule the next notification for the same interval
            let content = UNMutableNotificationContent()
            content.title = "Medication Reminder"
            content.body = "It's time to take your medication: \(medicationName)"
            content.sound = .default
            content.userInfo = ["customInterval": interval, "medicationName": medicationName]

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            let identifier = "medication_reminder_\(UUID().uuidString)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error rescheduling custom interval notification: \(error)")
                }
            }
            // Optionally update UserDefaults if you want to keep track of the latest identifier
            UserDefaults.standard.set(identifier, forKey: "currentMedicationReminderID")
        }
        completionHandler()
    }
}

@main
struct HauteVisionApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Initialize AuthViewModel only after Firebase is ready
    @StateObject private var viewModel = AuthViewModel()
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(localizationManager)
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let appWillTerminate = Notification.Name("appWillTerminate")
}
