//
//  FoursquarePlacesAPI.swift
//  cravethru
//
//  Created by Raymond Esteybar on 8/11/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class FoursquarePlacesAPI {
    let headers = [
        "User-Agent": "PostmanRuntime/7.15.2",
        "Accept": "*/*",
        "Cache-Control": "no-cache",
        "Postman-Token": "facf3448-0d96-4fc5-8f3a-1b48614ddc3c,5ce08825-77e1-403b-9d03-0b26a88fa1e7",
        "Host": "api.foursquare.com",
        "Accept-Encoding": "gzip, deflate",
        "Connection": "keep-alive",
        "cache-control": "no-cache"
    ]
    
//    class func foursquare_business_search(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<VenueRecommendations, Error>) -> ()) {
//        print("\nLatitude: \(String(describing: latitude)) | Longitude: \(String(describing: longitude))\n")
//
//        let url_string = "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&categories=restaurants&limit=2"
//        guard let url = URL(string: url_string) else { return }
//
//        let request = NSMutableURLRequest(url: url,
//                                          cachePolicy: .useProtocolCachePolicy,
//                                          timeoutInterval: 10.0)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = self.headers
//
//        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            // Successful
//            do {
//                let restaurants = try JSONDecoder().decode(Restaurant.self, from: data!)
//
//                completion(.success(restaurants))
//            } catch let json_error {
//                completion(.failure(json_error))
//            }
//            }.resume()
//    }
}
