//
//  ClassroomApp.swift
//  Classroom
//
//  Created by Gianluca Orpello for the Developer Academy on 19/10/21.
//
//


import SwiftUI

@main
struct ClassroomApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    
    var body: some Scene {
        WindowGroup {
            LearnerList()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        URLCache.shared.memoryCapacity = 25_000_000
        URLCache.shared.diskCapacity = 50_000_000
        
        return true
    }
}
