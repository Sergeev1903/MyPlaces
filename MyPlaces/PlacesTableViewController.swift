//
//  PlacesTableViewController.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 26.08.2022.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    let placesNames = ["Ischia, Italy", "Maldives", "Bali, Indonesia",
    "Mílos, Greece", "Fiji Islands", "Galápagos Islands, Ecuador", "Phuket, Thailand", "Dominica", "Boracay, Philippines", "Cape Breton Island, Nova Scotia", "Palawan, Philippines", "Páros, Greece", "Azores, Portugal",
    "Phu Quoc, Vietnam", "Moorea, French Polynesia", "Cebu, Philippines",
    "Ibiza, Spain", "St. Vincent and the Grenadines", "Madeira, Portugal",
    "Maui, Hawaii", "Anguilla", "Crete, Greece", "Mackinac Island, Michigan",
    "Island of Hawaii", "Kiawah Island, South Carolina"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return placesNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlacesTableViewCell


        let place = placesNames[indexPath.row]
    
        cell.nameOfPlace.text = place
        
        cell.imageOfPlace.image = UIImage(named: place)
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.height / 2
        cell.imageOfPlace.clipsToBounds = true
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 100 , bottom: 0, right: 16)
    
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       return 100
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

