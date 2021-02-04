//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Devin Flora on 2/2/21.
//  Copyright © 2021 trevorAdcock. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Properties
    var post: Post? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    // MARK: - Actions
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        presentAlertController()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        let image = UIActivityViewController(activityItems: [post], applicationActivities: .none)
        present(image, animated: true)
    }
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        
    }

    // MARK: - Methods
    func updateViews() {
        photoImageView.image = post?.photo
        tableView.reloadData()
    }
    
    func presentAlertController() {
        let alertController = UIAlertController(title: "Post a Comment", message: "Whatever you little heart desires.", preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Compose"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let postAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
            if let post = self.post {
                PostController.shared.addComment(text: text, post: post) { (_) in
                }
                self.tableView.reloadData()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(postAction)
        self.present(alertController, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post?.comments.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        let comment = post?.comments[indexPath.row]
        
        cell.textLabel?.text = comment?.text
        cell.detailTextLabel?.text = DateFormatter.postDate.string(from: comment?.timestamp ?? Date())
        
        return cell
    }
}//End of Class
