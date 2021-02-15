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
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        photoImageView.image = nil
    }
    
    // MARK: - Properties
    weak var delegate: PhotoSelectorViewControllerDelegate?
    
    // MARK: - Actions
    @IBAction func photoSelectedButtonTapped(_ sender: UIButton) {
        presentImagePicker()
    }
    
    // MARK: - Functions
    func presentImagePicker() {
        let imageActionSheet = UIAlertController(title: "Add Image", message: "", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
            self.selectAnImage(source: .photoLibrary)
        })
        
        imageActionSheet.addAction(cancelAction)
        imageActionSheet.addAction(photoAction)
        present(imageActionSheet, animated: true)
    }
    
    func selectAnImage(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
}//End of Class

// MARK: - Extensions
extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            photoImageView.image = image
            delegate?.photoSelectViewControllerSelected(image: image)
        }
        dismiss(animated: true)
    }
}

