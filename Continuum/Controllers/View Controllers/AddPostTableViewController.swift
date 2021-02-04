//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Devin Flora on 2/2/21.
//  Copyright © 2021 trevorAdcock. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController{
    
    // MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postImageView.image = nil
        captionTextField.text = ""
        selectPhotoButton.setTitle("Select Image", for: .normal)
    }
    
    // MARK: - Properties
    var delegate: UIImagePickerControllerDelegate?
    
    // MARK: - Actions
    @IBAction func selectedPhotoButtonTapped(_ sender: UIButton) {
        presentUIImagePicker()
    }
    
    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        guard let photo = postImageView.image,
              let caption = captionTextField.text else { return }
        PostController.shared.createPostWith(image: photo, caption: caption) { (result) in
        }
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPicker" {
            let photo = segue.destination as? PhotoSelectorViewController
            photo?.delegate = self
        }
    }
    
    // MARK: - Methods
    
    func presentUIImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        dismiss(animated: true)
    }
}//End of Class

extension AddPostTableViewController: PhotoSelectorViewControllerDelegate {
    func photoSelectViewControllerSelected(image: UIImage) {
        <#code#>
    }
}
