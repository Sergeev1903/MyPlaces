//
//  NewPlaceTableViewController.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 28.08.2022.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if see line link on the table, this instruction change empty cell on base view
//        tableView.tableFooterView = UIView()

    }
    
//MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // Select menu
        } else {
            view.endEditing(true)
        }
        
    }

}

//MARK: - Text field delegate
extension NewPlaceTableViewController: UITextFieldDelegate {
   
    // Hide keyboard when tapped Done button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
