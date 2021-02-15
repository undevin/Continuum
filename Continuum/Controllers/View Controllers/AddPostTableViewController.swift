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
    @IBOutlet weak var captionTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captionTextField.text = ""
        self.title = "Add Post"
    }
    
    // MARK: - Properties
    var selectedImage: UIImage?
    
    // MARK: - Actions
    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        guard let photo = selectedImage,
              let caption = captionTextField.text, !caption.isEmpty else { return }
        PostController.shared.createPostWith(image: photo, caption: caption) { (_) in
        }
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPicker" {
            let destination = segue.destination as? PhotoSelectorViewController
            destination?.delegate = self
        }
    }
}//End of Class

//MARK: - Extension
extension AddPostTableViewController: PhotoSelectorViewControllerDelegate {
    func photoSelectViewControllerSelected(image: UIImage) {
        selectedImage = image
    }
}
