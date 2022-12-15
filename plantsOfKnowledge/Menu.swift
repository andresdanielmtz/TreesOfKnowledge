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

struct MenuItem: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var photoCredit: String
    var imgUrl: String;
    var scientific_name: String;
    var wikipedia_entry: String;
    var price: Int
    var restrictions: [String]
    var description: String
    
    var mainImage: String {
        name.replacingOccurrences(of: " ", with: "-").lowercased()
    }

    var thumbnailImage: String {
        "\(mainImage)-thumb"
    }

    #if DEBUG
    static let example = MenuItem(id: "Woah", name: "Maple French Toast", photoCredit: "Joseph Gonzalez", imgUrl: "", scientific_name: "", wikipedia_entry: "", price: 6, restrictions: ["G", "V"], description: "Sweet, fluffy, and served piping hot, our French toast is flown in fresh every day from Maple City, Canada, which is where all maple syrup in the world comes from. And if you believe that, we have some land to sell you…")
    #endif
}
