//
//  listMenu.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 11/12/22.
//

import SwiftUI

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

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}




let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
struct listMenu: View {
    @State var showAddElement = true;
    // /Users/autummata/Desktop/xcode/plantsOfKnowledge/plantsOfKnowledge/plantsOfKnowledge
    // changeCurrentDirectoryPath("/Users/autummata/Desktop/xcode/plantsOfKnowledge/plantsOfKnowledge/plantsOfKnowledge")
    var body: some View {
        NavigationView {
            List {
                ForEach(menu) { section in
                    Section(section.name) { // show sections
                        ForEach(section.items) { item in
                            NavigationLink(destination: ContentView(plant: item.name, scientific_name: item.scientific_name, imgUrl: item.imgUrl, wiki: item.wikipedia_entry)) { // show items
                                Button(action: {
                                    print(":D")
                                }) {
                                    Text(item.name)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
                Button("Add element", action: {
                    // addToMenu(name: "Daigo", price: 20);
                    Logger.log("fuuu")
                    print(getDocumentsDirectory())

                    

                })

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
