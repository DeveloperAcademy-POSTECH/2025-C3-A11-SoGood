//
//  Public_Opinion_for_StockApp.swift
//  Public Opinion for Stock
//
//  Created by 유승재 on 5/29/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Public_Opinion_for_StockApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var viewModel = SentimentViewModel(category: "IT")
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
//            SentimentFrameView()
//                .environmentObject(viewModel)
            SentimentBarChart()
        }
//        .modelContainer(sharedModelContainer)
    }
}
