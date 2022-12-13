//
//  ContentView.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 08/12/22.
//

import SwiftUI
import MapKit
import Foundation


struct ContentView: View {
    let plant: String;
    let scientific_name: String;
    let imgUrl: String;
    let wiki: String;
    
    var body: some View {
    
        VStack {
            MapView()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CircleImage(imag: imgUrl)
                .offset(y: -130)
                .padding(.bottom, -129.974)

            VStack(alignment: .center) {
                Text(plant)
                    .bold()
                    .font(.system(size: 25))

                Text(scientific_name)
                    .italic()
                    .padding(.bottom)
                VStack {
                    Text("School Name")
                    Text("City, State")
                        .font(.subheadline)
                    Spacer();
                    Link("Wikipedia Entry", destination: URL(string: wiki)!)
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
        ContentView(plant: "", scientific_name:"", imgUrl: "", wiki: "")
    }
}
