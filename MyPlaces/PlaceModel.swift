//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 20.04.2022.
//

import Foundation
import UIKit

struct Place {
    
    var name: String
    var location: String
    var type: String
    var image: String
    
    static let restaurantNames = ["Балкан Гриль", "Бочка", "Вкусные истории", "Дастархан", "Индокитай",
                           "Классик", "Шок", "Bonsai", "Burger Heroes", "Kitchen",
                           "Love&Life", "Morris Pub", "Sherlock Holmes", "Speak Easy", "X.O"]
    
    static func getPlaces() ->[Place] {
        
        var places = [Place]()
        
        for place in restaurantNames {
            places.append(Place(name: place, location: "Харьков", type: "Ресторан", image: place))
        }
        
        return places
    }
    
}
