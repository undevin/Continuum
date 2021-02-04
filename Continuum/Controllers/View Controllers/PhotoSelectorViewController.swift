//
//  PhotoSelectorViewController.swift
//  Continuum
//
//  Created by Devin Flora on 2/3/21.
//  Copyright © 2021 trevorAdcock. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol PhotoSelectorViewControllerDelegate: AnyObject {
    func photoSelectViewControllerSelected(image: UIImage)
}

class PhotoSelectorViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Properties
    weak var delegate: PhotoSelectorViewControllerDelegate?
    
    
    
    // MARK: - Actions
    @IBAction func photoSelectedButtonTapped(_ sender: UIButton) {
        
    }
    
    
    // MARK: - Functions
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        let photoSelect = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAl
    }
    
    
    
}//End of Class

// MARK: - Extensions
extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        dismiss(animated: true)
    }
}
