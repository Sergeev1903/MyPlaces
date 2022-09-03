//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 27.08.2022.
//

import RealmSwift

class Place: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    
    let placesNames = ["Ischia, Italy", "Maldives", "Bali, Indonesia",
                       "Mílos, Greece", "Fiji Islands", "Galápagos Islands, Ecuador", "Phuket, Thailand", "Dominica", "Boracay, Philippines", "Cape Breton Island, Nova Scotia", "Palawan, Philippines", "Páros, Greece", "Azores, Portugal",
                       "Phu Quoc, Vietnam", "Moorea, French Polynesia", "Cebu, Philippines",
                       "Ibiza, Spain", "St. Vincent and the Grenadines", "Madeira, Portugal",
                       "Maui, Hawaii", "Anguilla", "Crete, Greece", "Mackinac Island, Michigan",
                       "Island of Hawaii", "Kiawah Island, South Carolina"]
    
    func savePlaces() {
        
        for place in placesNames {
            
            let image = UIImage(named: place)
            
            guard let imageData = image?.pngData() else {return}
            
            let newPlace = Place()
            
            newPlace.name = place
            newPlace.location = place
            newPlace.type = "Island"
            newPlace.imageData = imageData
            
            StorageManager.saveObject(newPlace)
        }
    }
}
