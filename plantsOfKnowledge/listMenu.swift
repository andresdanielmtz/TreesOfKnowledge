//
//  listMenu.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 11/12/22.
//

import SwiftUI
import SwiftyJSON
import Files

func readMenuJson() { // Read original menu.json in the project's root folder and writes it in the NSHomeDirectory
    let fileManager = FileManager.default
    let documentsUrl =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let destinationUrl = documentsUrl.appendingPathComponent("menu.json")
    if fileManager.fileExists(atPath: destinationUrl.path) {
        print("menu.json already exists at path")
        return
    } else {
        let fileURL = Bundle.main.url(forResource: "menu", withExtension: "json")
        do {
            let data = try Data(contentsOf: fileURL!)
            try data.write(to: destinationUrl)
            print("menu.json successfully copied to path")
        } catch {
            print("error: \(error)")
        }
    }
}

func appendToJSONFile(json: JSON) {
    let path = NSHomeDirectory() + "/Documents/menu.json"
    do {
        let fileContents = try String(contentsOfFile: path)
        let modifiedContents = fileContents.replacingOccurrences(of: "]", with: "\(json.rawString()!),\n]")
        try modifiedContents.write(toFile: path, atomically: true, encoding: .utf8)
    } catch {
        print(error)
    }
}


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


// let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
struct listMenu: View {
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
            Text("There's no elements here...")
            // .onAppear(perform: loadData)
            
            Text("You have clicked this \(x) times.")
            Button("test", action: {
                
                let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                let randomString = String((0..<10).map{ _ in letters.randomElement()! })
                let randomInt = Int.random(in: 0..<100)

                let menuItem = MenuItem(id: randomString, name: randomString, photoCredit: randomString, imgUrl: randomString, scientific_name: randomString, wikipedia_entry: randomString, price: randomInt, description: randomString)
                let json = JSON(["id": randomString, "name": randomString, "photoCredit": randomString, "imgUrl": randomString, "scientific_name": randomString, "wikipedia_entry": randomString, "price": randomInt, "description": randomString])
                            
                appendToJSONFile(json: json)
                self.menuItems.addElement(element: menuItem)
                x += 1
                print("Button pressed.")
            })
        }
    }
    struct listMenu_Previews: PreviewProvider {
        static var previews: some View {
            listMenu()
        }
    }
}
