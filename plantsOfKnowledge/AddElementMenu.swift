//
//  addElement.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 20/12/22.
//

import SwiftUI
import SwiftyJSON
import Foundation

func add_element_to_json(idUUID: String, name: String, imgURL: String, wikipedia_entry: String) -> Void {
    let instanceListMenu = listMenu()
    let jsonElement = JSON(["id": idUUID, "name" : name, "imgUrl": imgURL, "scientific_name": "", "wikipedia_entry": wikipedia_entry, "description":":D"])
    let menuElement = MenuItem(id: idUUID, name: name, imgUrl: "", scientific_name: "", wikipedia_entry: "", description: "…")
    
    appendToJSONFile(json: jsonElement)
    instanceListMenu.menuItems.addElement(element: menuElement)
    print("Added element.")
}

// let menuItem = MenuItem(id: randomString, name: randomString, photoCredit: randomString, imgUrl: randomString, scientific_name: randomString, wikipedia_entry: randomString, price: randomInt, description: randomString)

struct addElementMenu: View {
    var wikipedia_entry: String = "https://en.wikipedia.org/wiki/Like_I%27m_Gonna_Lose_You" // Placeholder Wikipedia in case of no input
    
    @State var idUUID: String = NSUUID().uuidString
    @State var name: String = "";
    @State var imgUrl: String = ""
    @State var user_wikipedia_entry: String = ""
    // @state
    
    var body: some View {
        VStack {
            // Text("Name: \(name) \n")
            // Should make like a card here...
            
            TextField("Name: ", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Image URL (Change this): ", text: $imgUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Wikipedia Entry: ", text: $user_wikipedia_entry)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            Button("Add", action: {
                if user_wikipedia_entry == "" {
                    user_wikipedia_entry = wikipedia_entry
                }
                add_element_to_json(idUUID: idUUID, name: name, imgURL: imgUrl, wikipedia_entry: user_wikipedia_entry)
            })
            
        }
        .navigationTitle(Text("Add Element: "))
    }
}

struct addElementMenu_Previews: PreviewProvider {
    static var previews: some View {
        addElementMenu()
    }
}
