//
//  listMenu.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 11/12/22.
//

import SwiftUI
import SwiftyJSON
import Files

/*
struct Item: Codable, Hashable, Identifiable {
    var id: UUID
    var name: String
    var photoCredit: String
    var imgUrl: String;
    var scientific_name: String;
    var wikipedia_entry: String;
    var price: Int
    var restrictions: [String]
    var description: String
    
}
*/

class Logger {
    static var logFile: URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: Date())
        let fileName = "\(dateString).txt"
        return documentsDirectory.appendingPathComponent(fileName)
    }

    static func log(_ message: String) {
        guard let logFile = logFile else {
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        guard let data = (timestamp + ": " + message + "\n").data(using: String.Encoding.utf8) else { return }

        if FileManager.default.fileExists(atPath: logFile.path) {
            if let fileHandle = try? FileHandle(forWritingTo: logFile) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } else {
            try? data.write(to: logFile, options: .atomicWrite)
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

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func readJsonFile() -> [String: Any] {
    let path = Bundle.main.path(forResource: "menu", ofType: "json")
    let url = URL(fileURLWithPath: path!)
    let data = try! Data(contentsOf: url)
    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    return json
}

class JSONWriter: UIResponder, UIApplicationDelegate { // when closing app, must look into it
    var it = Menu()
    func applicationWillTerminate(_ application: UIApplication) {
        do {
            let json: [String: Any] = ["menuItems": it.menuItems.map { $0.toJSON() }]
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            if let fileURL = Bundle.main.url(forResource: "data", withExtension: "json") {
                try data.write(to: fileURL)
            }
        } catch {
            print("Error writing to JSON file: \(error)")
        }
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

        let data = try! Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        menuItems = try! decoder.decode([MenuItem].self, from: data)
        print(":D")
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
    @State var x = -1

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
                x += 1
                self.menuItems.loadMenu()
            }
            
            // .onAppear(perform: loadData)
            
            Text("You have clicked this \(x) times.")
            Button("test", action: {
                
                // Example JSONs, to be changed.
                
                let v = JSON(["id": UUID().uuidString, "name": "Arbol", "photoCredit": "Joseph Gonzalez", "imgUrl": "", "scientific_name": "", "wikipedia_entry": "https://en.wikipedia.org/wiki/Hamburger", "price": 6, "description": "Sweet, fluffy, and served piping hot, our French toast is flown in fresh every day from Maple City, Canada, which is where all maple syrup in the world comes from. And if you believe that, we have some land to sell you…"])
                    
                let y = MenuItem(id: UUID().uuidString, name: "Arbol", photoCredit: "Joseph Gonzalez", imgUrl: "", scientific_name: "", wikipedia_entry: "https://en.wikipedia.org/wiki/Hamburger", price: 6, description: "Sweet, fluffy, and served piping hot, our French toast is flown in fresh every day from Maple City, Canada, which is where all maple syrup in the world comes from. And if you believe that, we have some land to sell you…")
                
                appendToJSONFile(json: v)
                self.menuItems.addElement(element: y)
                x += 1
                print("Does this even work?")
            })
        }
    }
    /*
    func loadData() {
        let url = Bundle.main.url(forResource: "menu", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        menuItems = try! decoder.decode([MenuItem].self, from: data)
        print(":D")
    }
    */ 
    struct listMenu_Previews: PreviewProvider {
        static var previews: some View {
            listMenu()
        }
    }
}
