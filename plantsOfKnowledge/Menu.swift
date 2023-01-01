//
//  Menu.swift
//  iDine
//  Decoder, taken from Hacking With Swift.
//
//  Created by Paul Hudson on 27/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI

struct MenuSection: Codable, Identifiable {
    var id: String
    var name: String
    var items: [MenuItem]
}

struct MenuItem: Codable, Hashable, Identifiable, Equatable {
    var id: String
    var name: String
    var imgUrl: String;
    var scientific_name: String;
    var wikipedia_entry: String;
    var description: String
    
    var mainImage: String {
        name.replacingOccurrences(of: " ", with: "-").lowercased()
    }

    var thumbnailImage: String {
        "\(mainImage)-thumb"
    }
    
    func toJSON() -> [String: Any] {
            return [
                "id": id,
                "name": name,
                "imgUrl":imgUrl,
                "scientific_name":scientific_name,
                "wikipedia_entry":wikipedia_entry,
                "descriptions":description,
                "mainImage":mainImage,
                "thumbnailImage":thumbnailImage,
            ]
        }

    #if DEBUG
    static let example = MenuItem(id: "Woah", name: "Maple French Toast", imgUrl: "", scientific_name: "", wikipedia_entry: "", description: "Sweet, fluffy, and served piping hot, our French toast is flown in fresh every day from Maple City, Canada, which is where all maple syrup in the world comes from. And if you believe that, we have some land to sell you…")
    #endif
}

