//
//  rijksmuseum.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation

struct Rijksmuseum: Codable {
    let artObjects: [ArtObjects]
    static func decodeArtObjects(from jsonData: Data) throws -> [ArtObjects] {
           let response = try JSONDecoder().decode(Rijksmuseum.self, from: jsonData)
        return response.artObjects
       }
}
struct ArtObjects: Codable, ThingsProtocol{

    let objectNumber: String
    let id: String
    let title: String
    let principalOrFirstMaker: String
    let longTitle: String
    let webImage : WebImage?
    var ThingsId: String{
        return self.objectNumber
    }
    var mainInfo: String {
        return self.title
    }
    
    var addInfo: String{
        return self.principalOrFirstMaker
    }
    var imageUrl: String{
        guard let webImage = webImage?.url else{
         return "Unknown"
        }
        return webImage
    }
 
}
struct WebImage: Codable{
    let url: String
}

