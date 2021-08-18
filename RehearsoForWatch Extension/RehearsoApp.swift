//
//  RehearsoApp.swift
//  RehearsoForWatch Extension
//
//  Created by Mohammad Sulthan on 19/08/21.
//

import SwiftUI

@main
struct RehearsoApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
