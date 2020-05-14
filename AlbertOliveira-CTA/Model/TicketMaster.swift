//
//  TicketMaster.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation

struct TicketMaster: Codable{
    let _embedded: Events?
  
}
struct Events: Codable {
    let events: [EventInfo]
}
struct EventInfo: Codable, ThingsProtocol{
    let name: String
    let id: String
    let url: String
    let images: [Images]
    let dates: Dates?
    let priceRanges: [Price]?
     var dateFormat: String {
        guard let newDate = dates?.start.dateTime else{
              return "No date"
          }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ "
        guard  let date = dateFormatter.date(from: newDate) else {
            return ""
        }
        dateFormatter.dateFormat = "dd MMM, yyyy hh:mm a"
        return dateFormatter.string(from: date)
      }
    var priceFormat: String {
        guard let newPrice = priceRanges?[0] else {
        return ""
        }
        return "Price: Range from \(newPrice.min)-\(newPrice.max)\(newPrice.currency)"
    }
    var experienceObject: Any {
          return self
      }
      
      var ThingsId: String {
          return id
      }
      
      var mainInfo: String{
          return name
      }
      
      var addInfo: String{
          return dateFormat
      }
      
      var imageUrl: String {
          if let urlImage = images.first?.url{
             return urlImage
          }else {
              return "Url not found"
          }
      }
}

struct Images: Codable {
    let url : String
     let width: Int
   let height: Int
}

struct Dates: Codable{
    let start: Start
}
struct Start: Codable{
    let dateTime: String
}
struct Price: Codable{
    let currency: String
    let min: Double
    let max: Double
}
