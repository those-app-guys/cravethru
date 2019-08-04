//
//  YelpAPI.swift
//  cravethru
//
//  Created by Raymond Esteybar on 8/4/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import Foundation

struct Restaurant : Decodable {
    let name: String
}

class YelpAPI {
    static let client_id = "bY2HHd2SJLIhYXZYLnnT_Q"
    static let api_key = "hTYF7-rb3s5YvDbH4BtsByLIBaATYCUksKeyNpWAFiDgOfi5EzSrA8YRhqPIUiKUv-p9Ey2E31cHLvCpKbWXBHgT3MKUrr5p7Sbn-ZoeYg91OT-CAZGhedpHC6O3XHYx"
    
    /*
 
     https://api.yelp.com/v3/businesses/search
     
    */
    class func yelp_business_search(completion: @escaping (Result<[Restaurant], Error>) -> ()) {
        let url_string = "https://api.yelp.com/v3/businesses/search"
        guard let url = URL(string: url_string) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Successful
            do {
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data!)
                completion(.success(restaurants))
            } catch let json_error {
                completion(.failure(json_error))
            }
        }
    }
}
