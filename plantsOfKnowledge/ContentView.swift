//
//  ContentView.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 08/12/22.
//

import SwiftUI
import MapKit

struct ContentView: View {

    var body: some View {
        VStack {
            MapView()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CircleImage()
                .offset(y: -130)
                .padding(.bottom, -129.974)

            VStack(alignment: .center) {
                Text("Arbol SuperGenial y Cool :)")
                    .bold()
                    .padding()
                    .font(.system(size: 25))

                VStack {
                    Text("Tec de Monterrey, Campus Sonora Norte")
                    Text("Hermosillo, Sonora")
                        .font(.subheadline)
                }
            }
            .padding()
            Spacer()
        }
        .background(Color("AccentColor"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
