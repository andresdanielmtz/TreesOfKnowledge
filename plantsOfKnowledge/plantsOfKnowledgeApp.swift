//
//  plantsOfKnowledgeApp.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 08/12/22.
//

import SwiftUI


@main
struct plantsOfKnowledgeApp: App {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let jsonWriter = JSONWriter()
        UIApplication.shared.delegate = jsonWriter
    }

    var body: some Scene {
        WindowGroup { // where to start
            listMenu()
        }
    }
}
