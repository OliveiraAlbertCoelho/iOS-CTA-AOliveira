//
//  ArtDetailModel.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/3/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation

struct ArtDetailModel: Codable{
    let artObject: ArtObject
    static func decodeArtObjects(from jsonData: Data) throws -> ArtObject {
        let response = try JSONDecoder().decode(ArtDetailModel.self, from: jsonData)
        return response.artObject
    }
}
struct ArtObject: Codable{
    let plaqueDescriptionEnglish: String?
    let dating: Dating?
    let title: String
    let productionPlaces: [String]?
    var plaqueFormatDescript: String {
        if let plaque = plaqueDescriptionEnglish {
            return "PlaqueDescription: \(plaque)"
        }else {return "Unknown"}
    }
    var datingFormat: String {
        if let dating = dating?.presentingDate {
            return "Created: \(dating)"
        }else {return "Unknown"}
    }
    var placeFormat: String {
        if let place = productionPlaces?.first {
            return "Location: \(place)"
        }else {return "Unknown"}
    }
    
}

struct Dating: Codable{
    let presentingDate: String
}
