//
//  PlacesTableViewController.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 26.08.2022.
//

import UIKit
import RealmSwift

class PlacesTableViewController: UITableViewController {
    
    
    var places: Results<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data base request
        places = realm.objects(Place.self)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.isEmpty ? 0 : places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlacesTableViewCell
        
        
        let place = places[indexPath.row]
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 112 , bottom: 0, right: 12)
        
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.height / 2
        cell.imageOfPlace.clipsToBounds = true
        
        cell.nameOfPlace.text = "\(indexPath.row + 1). \(place.name)"
        cell.locationOfPlace.text = place.location
        cell.typeOfPlace.text = place.type
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    // Delete place from data base & table view
    // FIXME: Deprecated
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let place = places[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else {return}
        newPlaceVC.saveNewPlace()
        tableView.reloadData()
    }
    
}

