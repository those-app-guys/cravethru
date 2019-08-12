//
//  VenueRecommendations.swift
//  cravethru
//
//  Created by Raymond Esteybar on 8/11/19.
//  Copyright © 2019 Raymond Esteybar. All rights reserved.
//

import UIKit
import Foundation

struct VenueRecommendations : Decodable {
    struct Response : Decodable {
        let groups : Places
    }
    
    struct Places : Decodable {
        let items : [Restaurant]
    }
    
    struct Restaurant : Decodable {
        let venue : RestaurantInfo
    }
    
    struct RestaurantInfo : Decodable {
        struct Location : Decodable {
            let lat : Double
            let lng : Double
        }
        
        struct Category : Decodable {
            let name : String
        }
        
        let name : String           // Restaurant Name
        let location : Location     // Location
        let categories : Category   // Category (Ex: Sandwich Place, Fast Food Restaurant)
        
    }
    
    let response : Response
}
