//
//  plantsOfKnowledgeApp.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 08/12/22.
//

import SwiftUI

@main
struct plantsOfKnowledgeApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some Scene {
        WindowGroup {
            main_menu()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                
        }
    }
}
