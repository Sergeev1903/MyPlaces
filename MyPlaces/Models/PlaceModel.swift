//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 27.08.2022.
//

import RealmSwift

class Place: Object {
    
    //FIXME: update properties to @Persisted
    @objc dynamic var name: String = " "
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    @objc dynamic var raiting = 0.0 // Double for precision
    
    convenience init(name: String,
                     location: String?,
                     type: String?,
                     imageData: Data?,
                     raiting: Double) {
        self.init() // Creates an object by default, and then assigns values ​​to the created object!
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
        self.raiting = raiting
    }
}
