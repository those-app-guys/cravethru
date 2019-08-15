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
    private static let client_id = "UH3KGN3HLTNDN1DIA1EIY0FKN120TC5W2L1H22EFPXMZFHJF"
    private static let client_secret = "OQ0F5RZWB53GZSWIKC4YWBTTJ4IDXQPPICLZQEUD3GQITVAA"
    private static var current_date = ""
    private static var category = "food"
    private static var limit = 50
    
    private static let headers = [
        "User-Agent": "PostmanRuntime/7.15.2",
        "Accept": "*/*",
        "Cache-Control": "no-cache",
        "Postman-Token": "facf3448-0d96-4fc5-8f3a-1b48614ddc3c,5ce08825-77e1-403b-9d03-0b26a88fa1e7",
        "Host": "api.foursquare.com",
        "Accept-Encoding": "gzip, deflate",
        "Connection": "keep-alive",
        "cache-control": "no-cache"
    ]
    
    let request = NSMutableURLRequest(url: NSURL(string: "&limit=50&offset=5&openNow=1&sortByDistance=1")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    
    class func foursquare_business_search(latitude: CLLocationDegrees, longitude: CLLocationDegrees, open_now: Bool, completion: @escaping (Result<VenueRecommendations, Error>) -> ()) {
        
//        let query = "vietnamese"
        
        getDate()
        let request_url = "https://api.foursquare.com/v2/venues/explore"
        let authorization = "?client_id=\(client_id)&client_secret=\(client_secret)&v=\(current_date)"
        let parameters = "&ll=\(latitude),\(longitude)&section=\(category)&limit=\(limit)&openNow=\(NSNumber(value: open_now))"
//        let parameters = "&ll=\(latitude),\(longitude)&limit=\(limit)&query=\(query)"
        
        let url_string = request_url + authorization + parameters
        print(url_string)

        guard let url = URL(string: url_string) else { return }

        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = self.headers

        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            // Successful
            do {
                let restaurants = try JSONDecoder().decode(VenueRecommendations.self, from: data!)
                
                restaurants.response.groups.first?.items.forEach({ (restaurant) in
                    print(restaurant.venue.name)
                })
                
                completion(.success(restaurants))
            } catch let json_error {
                print("\n\n", "Did not work!")
                completion(.failure(json_error))
            }
            }.resume()
    }
    
    class func getDate() {
        // 1. Setup Date & Calendar
        let date = Date()
        let calendar = Calendar.current
        
        // 2. Get Date for Places API Request URLs
        let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: date)
        let year = components.year
        var formatted_month = ""
        var formatted_day = ""
        
        // 3. Format month
        if let unwrapped_month = components.month {
            if unwrapped_month >= 1 && unwrapped_month <= 9 {
                formatted_month = "0\(unwrapped_month)"
            } else {
                formatted_month = "\(unwrapped_month)"
            }
        }
        
        // 4. Format day
        if let unwrapped_day = components.day {
            if unwrapped_day >= 1 && unwrapped_day <= 9 {
                formatted_day = "0\(unwrapped_day)"
            } else {
                formatted_day = "\(unwrapped_day)"
            }
        }
        
        // 4. Setup Current Date
        current_date = "\(year!)\(formatted_month)\(formatted_day)"
    }
}
