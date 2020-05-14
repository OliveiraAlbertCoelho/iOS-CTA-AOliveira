//
//  ImageHelper.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation
import UIKit
class ImageHelper {
    static let shared = ImageHelper()
    private var imageCache: NSCache<NSString, UIImage>
    private init() {
        imageCache = NSCache<NSString, UIImage>()
        imageCache.countLimit = 100
        imageCache.totalCostLimit = 10 * 1024 * 1024
    }
    func fetchImage(urlString: String, completionHandler: @escaping (Result<UIImage,AppError>) -> ()) {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completionHandler(.failure(.noDataReceived))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noDataReceived))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completionHandler(.failure(.notAnImage))
                return
            }
            ImageHelper.shared.imageCache.setObject(image, forKey: urlString as NSString)
            completionHandler(.success(image))
        } .resume()
        
}
  
    public func image(forKey key: NSString) -> UIImage? {
      return imageCache.object(forKey: key)
        
    }
    
}


