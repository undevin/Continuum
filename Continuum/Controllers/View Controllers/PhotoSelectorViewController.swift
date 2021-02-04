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
        presentImagePicker()
    }
    
    // MARK: - Functions
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        let imageActionSheet = UIAlertController(title: "Add Image", message: "", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        imageActionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
            self.present(imagePicker, animated: true)
        }))
        imageActionSheet.addAction(cancelAction)
        present(imageActionSheet, animated: true)
    }
}//End of Class

// MARK: - Extensions
extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            photoImageView.image = image
        }
        dismiss(animated: true)
    }
}

