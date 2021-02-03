//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Devin Flora on 2/2/21.
//  Copyright © 2021 trevorAdcock. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
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
    
    // MARK: - Actions
    @IBAction func selectedPhotoButtonTapped(_ sender: UIButton) {
        postImageView.image = #imageLiteral(resourceName: "spaceEmptyState")
        selectPhotoButton.setTitle("", for: .normal)
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
}//End of Class
