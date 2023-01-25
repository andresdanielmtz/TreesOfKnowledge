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
    @AppStorage("myFontSize") private var myFontSize: Int = 20;
    
    var body: some Scene {
        WindowGroup {
            main_menu()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .font(.system(size: CGFloat(myFontSize)))
        }
    }
}
