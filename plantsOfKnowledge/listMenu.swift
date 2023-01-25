//
//  listMenu.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 11/12/22.
//

import SwiftUI
import SwiftyJSON
import Files

class Menu: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    
    init() {
        loadMenu()
    }
    
    func loadMenu() {
        let fileName = "Documents/menu.json"
        let homeDirectory = NSHomeDirectory()
        let fileURL = URL(fileURLWithPath: homeDirectory).appendingPathComponent(fileName)
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            menuItems = try decoder.decode([MenuItem].self, from: data)
        } catch {
            
            print("no menu.json found, ")
            readMenuJson()
            
        }
        print("Loading Menu...")
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        do {
            let json: [String: Any] = ["menuItems": menuItems.map { $0.toJSON() }]
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            if let fileURL = Bundle.main.url(forResource: "menu", withExtension: "json") {
                try data.write(to: fileURL)
            }
        } catch {
            print("Error writing to JSON file: \(error)")
        }
    }
    
    func addElement(element: MenuItem) { // Add the element to the data property and update the JSON file
        menuItems.append(element)
        do {
            let json: [String: Any] = ["menuItems": menuItems.map { $0.toJSON() }]
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            if let fileURL = Bundle.main.url(forResource: "menu", withExtension: "json") {
                try data.write(to: fileURL)
            }
        } catch {
            print("Error writing to JSON file: \(error)")
        }
    }
}

func parseIDFromURL(url: URL) -> String? {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
        return nil
    }
    for queryItem in components.queryItems ?? [] {
        if queryItem.name == "id", let value = queryItem.value {
            return value
        }
    }
    return nil
}

struct listMenu: View {
    @State private var url: URL?
    @State private var presentAlert: Bool = false;
    @AppStorage("userOnboarded") var userOnboarded: Bool = false
    
    @ObservedObject var menuItems = Menu()
    init() {
        readMenuJson()
    }
    
    var body: some View {
        NavigationStack {
            List(menuItems.menuItems, id: \.self) { menuItem in
                NavigationLink(destination: ContentView(plant: menuItem.name, scientific_name: menuItem.scientific_name, imgUrl: menuItem.imgUrl, wiki: menuItem.wikipedia_entry))
                {
                    Text(menuItem.name)
                }
                
            }
            
            
            .navigationTitle("Arboles Registrados")
            .onAppear {
                let path = NSHomeDirectory() // Used for debugging purposes, can be removed.
                print(path)
                userOnboarded = true;
                
                self.menuItems.loadMenu() // IMPORTANT
                
            }

            Button("Add Random Element", action: {
                
                let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                let randomString = String((0..<10).map{ _ in letters.randomElement()! })
                
                let menuItem = MenuItem(id: randomString, name: randomString, imgUrl: randomString, scientific_name: randomString, wikipedia_entry: randomString, description: randomString)
                let json = JSON(["id": randomString, "name": randomString, "imgUrl": randomString, "scientific_name": randomString, "wikipedia_entry": randomString, "description": randomString])
                
                appendToJSONFile(json: json)
                self.menuItems.addElement(element: menuItem)
                print("Button pressed.")
            })
        }
        .onOpenURL { url in
            let urlString = url.absoluteString
            let id = extractInfo(from: urlString, choice: "id")!
            let name = extractInfo(from: urlString, choice: "name")!
            let imgHost = "https://i.imgur.com/" + extractInfo(from: urlString, choice: "imgUrl")! + ".jpg"
            let scientific_name = extractInfo(from: urlString, choice: "scientific_name")!
            let wikiEntry = "https://es.wikipedia.org/wiki/" + extractInfo(from: urlString, choice: "wikipedia_entry")!
            let desc = extractInfo(from: urlString, choice: "desc")!
            
            let menuItem = MenuItem(id: id, name: name, imgUrl: imgHost, scientific_name: scientific_name, wikipedia_entry: wikiEntry, description: desc)
            let json = JSON(["id": id, "name": name, "imgUrl": imgHost, "scientific_name": scientific_name, "wikipedia_entry": wikiEntry, "description": desc])
            appendToJSONFile(json: json)
            self.menuItems.addElement(element: menuItem)
            
            // https://es.wikipedia.org/wiki/Parkinsonia_aculeata
            // plantsOfKnowledge://id=92
            
            // Example ID
            // plantsofknowledge://plants?id=2231?name=letsgo?imgUrl=sKjio0I?scientific_name=acuosa?wikipedia_entry=Parkinsonia_aculeata?desc='It_works_just_fine'
            
        }
        
    }
    struct listMenu_Previews: PreviewProvider {
        static var previews: some View {
            listMenu()
        }
    }
}
