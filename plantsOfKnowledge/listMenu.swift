//
//  listMenu.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 11/12/22.
//

import SwiftUI

let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
struct listMenu: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(menu) { section in
                    Section(section.name) { // show sections
                        ForEach(section.items) { item in
                            NavigationLink(destination: ContentView(plant: item.name, scientific_name: item.scientific_name, imgUrl: item.imgUrl, wiki: item.wikipedia_entry)) { // show items
                                Text(item.name)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Secciones"))
            .listStyle(GroupedListStyle())
        }
    }
}


struct listMenu_Previews: PreviewProvider {
    static var previews: some View {
        listMenu()
    }
}
