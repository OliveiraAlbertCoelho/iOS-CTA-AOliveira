//
//  FetchTicketMaster.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//


import Foundation

class FetchTicketMaster{

static let manager = FetchTicketMaster()

 func getTicketsData(city: String?,completionHandler: @escaping (Result<[EventInfo], AppError>) -> ()) {
    var urlString = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=\(Secrets.ticketKey)&city=New+York"
     if let userInfo = city{
    let updatedString = userInfo.replacingOccurrences(of: " ", with: "+")
         urlString = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=\(Secrets.ticketKey)&city=\(updatedString)"
     }
     guard let url = URL(string: urlString) else {
         completionHandler(.failure(.badURL))

                   return
    }
         NetworkHelper.manager.performDataTask(withUrl: url , andMethod: .get) { (result) in
                  print(url)
             switch result {
             case .failure(let error) :
                 completionHandler(.failure(error))
             case .success(let data):
                 do {
                 let ticket = try JSONDecoder().decode(TicketMaster.self, from: data)
                    guard let ticketData = ticket._embedded?.events else {return}
                    completionHandler(.success(ticketData))
                 } catch {
                     completionHandler(.failure(.other(rawError: error)))
                 }
             }
         }
    }}
   
