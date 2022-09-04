//
//  PlacesTableViewController.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 26.08.2022.
//

import UIKit
import RealmSwift

class PlacesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortingButton: UIBarButtonItem!
    
    var places: Results<Place>!
    
    var ascendingSorting = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    
        // Data base request
        places = realm.objects(Place.self)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.isEmpty ? 0 : places.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let place = places[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
    
    
    // Pass data from selected row to the new place vc for edit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place = places[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceTableViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else {return}
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
    
    
    // Sorting
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
//        if sender.selectedSegmentIndex == 0 {
//            places = places.sorted(byKeyPath: "date")
//        } else {
//            places = places.sorted(byKeyPath: "name")
//        }
//
//        tableView.reloadData()
        
        sorting()
    }
    
    
    @IBAction func reversedSorting(_ sender: UIBarButtonItem) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = UIImage(systemName: "arrow.down")
        } else {
            reversedSortingButton.image = UIImage(systemName: "arrow.up")
        }
        
        sorting()
    }
    
    private func sorting() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
    }
    
}

