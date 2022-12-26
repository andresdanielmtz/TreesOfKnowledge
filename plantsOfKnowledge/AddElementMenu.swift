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
    let jsonElement = JSON(["id": idUUID, "name" : name, "photoCredit": "", "imgUrl": imgURL, "scientific_name": "", "wikipedia_entry": wikipedia_entry, "price": 6, "description":":D"])
    let menuElement = MenuItem(id: idUUID, name: name, photoCredit: "Joseph Gonzalez", imgUrl: "", scientific_name: "", wikipedia_entry: "", price: 6, description: "…")
    
    appendToJSONFile(json: jsonElement)
    instanceListMenu.menuItems.addElement(element: menuElement)
    print("Added element.")
}

// let menuItem = MenuItem(id: randomString, name: randomString, photoCredit: randomString, imgUrl: randomString, scientific_name: randomString, wikipedia_entry: randomString, price: randomInt, description: randomString)

struct addElementMenu: View {
    @State var idUUID: String = NSUUID().uuidString
    @State var name: String = "";
    @State var imgUrl: String = ""
    @State var wikipedia_entry: String = "https://en.wikipedia.org/wiki/Like_I%27m_Gonna_Lose_You" // to change
    
    // @state
    
    var body: some View {
        VStack {
            Text("Name: \(name) \n")
            // Text("Image URL: \(imgUrl) \n")
            // Text("Wikipedia Entry: \(wikipedia_entry)")
            
            TextField("Name: ", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Image URL (Change this): ", text: $imgUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Wikipedia Entry: ", text: $wikipedia_entry)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            Button("Add", action: {
                add_element_to_json(idUUID: idUUID, name: name, imgURL: imgUrl, wikipedia_entry: wikipedia_entry)
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
