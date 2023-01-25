//
//  settings.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 25/01/23.
//

import SwiftUI

struct settings: View {
    @AppStorage("isDarkMode") private var isDarkMode = true;
    var body: some View {
        HStack {
            Toggle("Dark Mode", isOn: $isDarkMode)
        }
    }
}

struct settings_Previews: PreviewProvider {
    static var previews: some View {
        settings()
    }
}
