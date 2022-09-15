//
//  PlacesTableViewCell.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 27.08.2022.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {
    
    @IBOutlet var imageOfPlace: UIImageView!
    @IBOutlet var nameOfPlace: UILabel!
    @IBOutlet var locationOfPlace: UILabel!
    @IBOutlet var typeOfPlace: UILabel!
    
    @IBOutlet var raitingOfPlace: RatingControl!
}
