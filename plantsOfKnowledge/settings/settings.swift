//
//  settings.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 25/01/23.
//

import SwiftUI

struct settings: View {
    @AppStorage("isDarkMode") private var isDarkMode = true;
    @AppStorage("myFontSize") private var myFontSize: Int = 20;
    
    var body: some View {
        VStack {
            HStack {
                Toggle("Dark Mode", isOn: $isDarkMode)
            }
            HStack {
                Text("Font size")
                Picker("Font-size", selection: $myFontSize) {
                    ForEach(1...100, id: \.self) { number in
                        Text("\(number)")
                    }
                }
            }
        }
        
    }
}

struct settings_Previews: PreviewProvider {
    static var previews: some View {
        settings()
    }
}
