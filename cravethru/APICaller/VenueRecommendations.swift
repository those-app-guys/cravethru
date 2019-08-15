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
    struct Meta : Decodable {
        let code : Int
    }
    
    struct Response : Decodable {
        let groups : [Places]
        let headerLocation : String
    }

    struct Places : Decodable {
        let items : [Restaurant]
        let type : String
    }

    struct Restaurant : Decodable {
        let venue : RestaurantInfo
    }

    struct RestaurantInfo : Decodable {
        struct Location : Decodable {
            // (Used for Pins on Maps)
            let lat : Double
            let lng : Double

            let distance : Int
            let city : String
            let state : String
            let country : String
            let formattedAddress : [String] // An array = [Street, {City, State, Zipcode}, Country]
        }

        struct Category : Decodable {
            struct IconImage : Decodable {
                let prefix : String
                let suffix : String
            }

            let shortName : String
            let icon : IconImage
        }

        let name : String           // Restaurant Name
        let location : Location     // Location
        let categories : [Category]   // Category (Ex: Sandwich, Fast Food)
    }

    let response : Response
    let meta : Meta
}
