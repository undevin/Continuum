//
//  PostController.swift
//  Continuum
//
//  Created by Devin Flora on 2/2/21.
//  Copyright © 2021 trevorAdcock. All rights reserved.
//

import UIKit

class PostController {
    
    // MARK: - Properties
    static let shared = PostController()
    var posts: [Post] = []
    
    // MARK: - Methods
    func addComment(text: String, post: Post, completion: @escaping (Result<Comment,PostError>) -> Void) {
        let newComment = Comment(text: text, post: post)
        post.comments.append(newComment)
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Result<Post?,PostError>) -> Void) {
        let newPost = Post(photo: image, caption: caption)
        posts.append(newPost)
    }
    
}//End of Class
