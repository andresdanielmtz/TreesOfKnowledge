//
//  funcWebRequests.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 26/12/22.
//

import Foundation
import UIKit
import SwiftyJSON

func extractInfo(from s: String, choice: String) -> String? {
    let regexExpression: String
    
    switch (choice) {
        case "id": regexExpression = "id=(\\d+)"
        case "name": regexExpression = "name=([^\\?]+)"
        case "imgUrl": regexExpression = "imgUrl=([^\\?]+)"
        case "scientific_name": regexExpression = "scientific_name=([^\\?]+)"
        case "wikipedia_entry": regexExpression = "wikipedia_entry=([^\\?]+)"
        case "desc": regexExpression = "desc='(.+?)'"
        default: regexExpression = ""
    }
    
    let regex = try! NSRegularExpression(pattern: regexExpression)
    let range = NSRange(location: 0, length: s.utf16.count)
    if let match = regex.firstMatch(in: s, options: [], range: range) {
        return String(s[Range(match.range(at: 1), in: s)!])
    }
    return nil
}


func parseCustomUrl(url: URL) {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
        print("Invalid URL")
        return
    }

    guard components.scheme == "plantsOfKnowledge" else {
        print("Invalid scheme")
        return
    }

    if let id = components.queryItems?.first(where: { $0.name == "id" })?.value {
        print(id)
    } else {
        print("No id found")
    }
}

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
