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
    
    func addElement(element: MenuItem) {
            // Add the element to the data property and update the JSON file
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
// let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
struct listMenu: View {
    @State private var url: URL?
    
    @ObservedObject var menuItems = Menu()
    @State var x = 0
    init() {
        readMenuJson()
    }
    
    var body: some View {
        NavigationStack {
            List(menuItems.menuItems, id: \.self) { menuItem in
                NavigationLink(destination: ContentView(plant: menuItem.name, scientific_name: menuItem.scientific_name, imgUrl: menuItem.imgUrl, wiki: menuItem.wikipedia_entry))
                {
                    Text(menuItem.name)
                    // Text("\(x)")
                }
            }
            .navigationTitle("Arboles")
            .onAppear {
                self.menuItems.loadMenu()
            }
            // Text("There's no elements here...")
            // (Add later)
            
            NavigationLink(destination: addElementMenu()) {
                Text("Testing Button.")
            }

            Text("You have clicked this \(x) times.")
            Button("test", action: {
                
                let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                let randomString = String((0..<10).map{ _ in letters.randomElement()! })

                let menuItem = MenuItem(id: randomString, name: randomString, imgUrl: randomString, scientific_name: randomString, wikipedia_entry: randomString, description: randomString)
                let json = JSON(["id": randomString, "name": randomString, "imgUrl": randomString, "scientific_name": randomString, "wikipedia_entry": randomString, "description": randomString])
                            
                appendToJSONFile(json: json)
                self.menuItems.addElement(element: menuItem)
                x += 1
                print("Button pressed.")
            })
        }
        .onOpenURL { url in
            self.url = url
            let urlString = url.absoluteString
            let id = extractInfo(from: urlString, choice: "id")
            let name = extractInfo(from: urlString, choice: "name")
            
            // https://i.imgur.com/
            // .jpg
            
            let imgUrl = extractInfo(from: urlString, choice: "imgUrl")
            let imgHost = "https://i.imgur.com/" + imgUrl! + ".jpg"
            
            let scientific_name = extractInfo(from: urlString, choice: "scientific_name")
            let wikipedia_entry = extractInfo(from: urlString, choice: "wikipedia_entry")
            let full_wikiEntry = "https://es.wikipedia.org/wiki/" + wikipedia_entry!
            let desc = extractInfo(from: urlString, choice: "desc")
            
            let menuItem = MenuItem(id: id!, name: name!, imgUrl: imgHost, scientific_name: scientific_name!, wikipedia_entry: full_wikiEntry, description: desc!)
            let json = JSON(["id": id!, "name": name!, "imgUrl": imgHost, "scientific_name": scientific_name!, "wikipedia_entry": full_wikiEntry, "description": desc!])
            
            appendToJSONFile(json: json)
            self.menuItems.addElement(element: menuItem)
            
            print(id!)
            print(name!)
            print(imgHost)
            print(scientific_name!)
            print(full_wikiEntry)
            
            
            // https://es.wikipedia.org/wiki/Parkinsonia_aculeata
            // plantsOfKnowledge://id=92
            // plantsofknowledge://plants?id=12?name=palo_verde?imgUrl=sKjio0I?scientific_name=acuosa?wikipedia_entry=Parkinsonia_aculeata?desc='It_works_just_fine'

        }
    }
    struct listMenu_Previews: PreviewProvider {
        static var previews: some View {
            listMenu()
        }
    }
}
