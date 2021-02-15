//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by Devin Flora on 2/2/21.
//  Copyright © 2021 trevorAdcock. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var postSearchBar: UISearchBar!
    
    // MARK: - Properties
    var resultsArray: [Post] = []
    var isSearching: Bool = false
    var dataSource: [SearchableRecord] {
        if isSearching {
            return resultsArray
        } else {
            return PostController.shared.posts
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        postSearchBar.delegate = self
        fullSyncOpertaion(completion: {_ in})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultsArray = PostController.shared.posts
        self.title = "Posts"
        tableView.reloadData()
    }
    
    // MARK: - Methods
    func fullSyncOpertaion(completion: @escaping(String) -> Void?) {
        PostController.shared.fetchPosts { (result) in
            switch result {
            case .success(_):
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        let post = PostController.shared.posts[indexPath.row]
        
        cell.post = post
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDetails" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? PostDetailTableViewController else { return }
            let postToSend = PostController.shared.posts[indexPath.row]
            destination.post = postToSend
        }
    }
}//End of Class

extension PostListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsArray = PostController.shared.posts.filter { $0.matches(searchTerm: searchText) }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsArray = PostController.shared.posts
        postSearchBar.text = ""
        tableView.reloadData()
        resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
}//End of Extension
