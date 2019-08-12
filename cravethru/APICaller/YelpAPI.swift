////
////  YelpAPI.swift
////  cravethru
////
////  Created by Raymond Esteybar on 8/4/19.
////  Copyright © 2019 Raymond Esteybar. All rights reserved.
////
//
//import UIKit
//import MapKit
//import Foundation
//
//struct Restaurant : Codable {
//    struct Business : Codable {
//        let id : String
//        let name : String
//    }
//    
//    let businesses : [Business]
//}
//
//class YelpAPI {
//    private static let headers = [
//        "Authorization": "Bearer hTYF7-rb3s5YvDbH4BtsByLIBaATYCUksKeyNpWAFiDgOfi5EzSrA8YRhqPIUiKUv-p9Ey2E31cHLvCpKbWXBHgT3MKUrr5p7Sbn-ZoeYg91OT-CAZGhedpHC6O3XHYx",
//        "User-Agent": "PostmanRuntime/7.15.2",
//        "Accept": "*/*",
//        "Cache-Control": "no-cache",
//        "Postman-Token": "84bff9b2-357b-4cc9-b5e6-d7b2ba0505b2,72e2dc29-92b7-4107-b926-ee9b64317e98",
//        "Host": "api.yelp.com",
//        "Accept-Encoding": "gzip, deflate",
//        "Connection": "keep-alive",
//        "cache-control": "no-cache"
//    ]
//    
//    class func yelp_business_search(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<Restaurant, Error>) -> ()) {
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
//        }.resume()
//    }
//}
