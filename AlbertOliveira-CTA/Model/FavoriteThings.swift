//
//  Things.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
struct FavoriteThings {
        let id: String
        let creatorID: String
        let dateCreated: Date?
        let imageUrl: String?
        let mainInfo: String?
        let addInfo: String?
        let experience: String
        let favoriteId: String

        var dateFormat: String {
            guard let date = dateCreated else{
                return "no date"
            }
          let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "dd MMM, yyyy hh:mm:ss"
            return dateFormatter.string(from: date)
        }
        
    init(creatorID: String, dateCreated: Date? = nil , imageUrl: String? = nil, mainInfo: String?, addInfo: String?, experience: String, favoriteId: String){
            self.creatorID = creatorID
            self.dateCreated = dateCreated
            self.imageUrl = imageUrl
            self.id = UUID().description
        self.mainInfo = mainInfo
        self.addInfo = addInfo
        self.experience = experience
        self.favoriteId = favoriteId
    }
    
        init? (from dict: [String: Any], id: String){
            guard let userId = dict["creatorID"] as? String,
            let thingImage = dict["imageUrl"] as? String,
            let mainInfo = dict["mainInfo"] as? String,
            let addInfo = dict["addInfo"] as? String,
            let experience = dict["experience"] as? String,
            let favoriteId = dict["favoriteId"] as? String,
            let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else { return nil }
            self.creatorID = userId
            self.id = id
            self.dateCreated = dateCreated
            self.imageUrl = thingImage
            self.mainInfo = mainInfo
            self.addInfo = addInfo
            self.experience = experience
            self.favoriteId = favoriteId
        }
    
        var fieldsDict: [String: Any] {
               return [
                   "creatorID": self.creatorID,
                   "imageUrl": self.imageUrl ?? "",
                   "mainInfo": self.mainInfo ?? "",
                   "addInfo": self.addInfo ?? "",
                "experience": self.experience,
                "favoriteId": self.favoriteId,
               ]
           }
        
    }
