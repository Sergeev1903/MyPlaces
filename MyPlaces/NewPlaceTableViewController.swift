//
//  NewPlaceTableViewController.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 28.08.2022.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {
    
    // Pass from placeTable to newPlaceTable
    var currentPlace: Place!
    
    var imageIsChanged = false
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var placeImage: UIImageView!
    @IBOutlet var placeName: UITextField!
    @IBOutlet var placeLocation: UITextField!
    @IBOutlet var placeType: UITextField!
    
    @IBOutlet var raitingControl: RatingControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        // if see line link on the table, this instruction change empty cell on base view
        // + delete line link on the last row (for us - raitings)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.height,
                                                         height: 1))
        
        setUpEditScreen() // must call after saveButton.isEnabled = false
        
    }
    
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = UIImage(systemName: "camera")
            let photoIcon = UIImage(systemName: "photo")
            
            // Select menu
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            //            camera.setValue( CATextLayerAlignmentMode.left,
            //                             forKey: "titleTextAlignment")
            
            let album = UIAlertAction(title: "Album", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            album.setValue(photoIcon, forKey: "image")
            //            photo.setValue(CATextLayerAlignmentMode.left,
            //                           forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(album)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    // Save new place to data base
    func savePlace() {
        
        var image: UIImage?
        
        if imageIsChanged {
            image = placeImage.image
        } else {
            image = #imageLiteral(resourceName: "appstore")
        }
        
        let imageData = image?.pngData()
        
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData,
                             raiting: Double(raitingControl.raiting))
        
        // Choose add new place or edit place
        if currentPlace != nil {
            try! realm.write({
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.raiting = newPlace.raiting
            })
        } else {
            StorageManager.saveObject(newPlace)
        }
    }
    
    // Set up edit screen
    private func setUpEditScreen() {
        
        if currentPlace != nil {
            
            setUpNavigationBar()
            imageIsChanged = true
            
            guard let data = currentPlace?.imageData,
                  let image = UIImage(data: data) else { return }
            
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            raitingControl.raiting = Int(currentPlace.raiting)
        }
    }
    
    
    // Set up navigation when call edit screen
    private func setUpNavigationBar() {
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: " ",
                                                        style: .plain,
                                                        target: nil,
                                                        action: nil)
        }
        
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

//MARK: - Text field delegate
extension NewPlaceTableViewController: UITextFieldDelegate {
    
    // Hide keyboard when tapped Done button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

//MARK: Work with image

extension NewPlaceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // allow to edit image
    func chooseImagePicker(source: UIImagePickerController.SourceType ) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    // choose image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}
