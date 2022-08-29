//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 27.08.2022.
//

import UIKit

struct Place {
    let name: String
    let location: String?
    let type: String?
    let image: UIImage?
    let testImage: String?
    
   static let placesNames = ["Ischia, Italy", "Maldives", "Bali, Indonesia",
    "Mílos, Greece", "Fiji Islands", "Galápagos Islands, Ecuador", "Phuket, Thailand", "Dominica", "Boracay, Philippines", "Cape Breton Island, Nova Scotia", "Palawan, Philippines", "Páros, Greece", "Azores, Portugal",
    "Phu Quoc, Vietnam", "Moorea, French Polynesia", "Cebu, Philippines",
    "Ibiza, Spain", "St. Vincent and the Grenadines", "Madeira, Portugal",
    "Maui, Hawaii", "Anguilla", "Crete, Greece", "Mackinac Island, Michigan",
    "Island of Hawaii", "Kiawah Island, South Carolina"]
    
    static func getPlace()-> [Place]{
        
        var places = [Place]()
        
        for place in placesNames {
            places.append(Place(name: place, location: place, type: "#Island", image: nil, testImage: place))
            
        }
        
        return places
    }
}
