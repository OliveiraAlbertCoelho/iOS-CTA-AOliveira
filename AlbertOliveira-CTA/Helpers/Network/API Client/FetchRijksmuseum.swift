//
//  FetchRijksmuseum.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation

class FetchRijksmuseum{
    
    static let manager = FetchRijksmuseum()
    
    func getArtData(author: String?,completionHandler: @escaping (Result<[ArtObjects], AppError>) -> ()) {
        
        
        var urlString = "https://www.rijksmuseum.nl/api/en/collection?key=\(Secrets.rijkKey)&q=New+York"
        if let userInfo = author{
            let updatedString = userInfo.replacingOccurrences(of: " ", with: "+")
            urlString = "https://www.rijksmuseum.nl/api/en/collection?key=\(Secrets.rijkKey)&q=\(updatedString)"
        }
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        NetworkHelper.manager.performDataTask(withUrl: url , andMethod: .get) { (result) in
            switch result {
            case .failure(let error) :
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let artData = try Rijksmuseum.decodeArtObjects(from: data)
                    completionHandler(.success(artData))
                } catch {
                    completionHandler(.failure(.other(rawError: error)))
                }
            }
        }
    }
    
    func getArtDetailData(objectNum: String,completionHandler: @escaping (Result<ArtObject, AppError>) -> ()) {
        let urlString = "https://www.rijksmuseum.nl/api/en/collection/\(objectNum)?key=\(Secrets.rijkKey)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        NetworkHelper.manager.performDataTask(withUrl: url , andMethod: .get) { (result) in
            switch result {
            case .failure(let error) :
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let artData = try ArtDetailModel.decodeArtObjects(from: data)
                    completionHandler(.success(artData))
                } catch {
                    completionHandler(.failure(.other(rawError: error)))
                }
            }
        }
    }
}
