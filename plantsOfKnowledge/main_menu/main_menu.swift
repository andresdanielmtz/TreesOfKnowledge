//
//  main_menu.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 24/01/23.
//

import SwiftUI

struct main_menu: View {
    @State private var show_list_menu: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Andrés Martínez")
                Text("Trees of Life\n\n")
                    .font(.system(size: 36))
                    .bold()
                NavigationLink(destination: listMenu()) {
                    Text("Start\n")
                }
                NavigationLink(destination: settings()) {
                    Text("Settings\n")
                }
            }
        }
    }
}

struct main_menu_Previews: PreviewProvider {
    static var previews: some View {
        main_menu()
    }
}
