//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 20.04.2022.
//

import RealmSwift

class Place: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    
}
