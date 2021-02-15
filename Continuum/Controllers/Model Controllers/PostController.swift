//
//  PostController.swift
//  Continuum
//
//  Created by Devin Flora on 2/2/21.
//  Copyright © 2021 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class PostController {
    
    // MARK: - Properties
    static let shared = PostController()
    var posts: [Post] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - Methods
    func addComment(text: String, post: Post, completion: @escaping (Result<Comment,PostError>) -> Void) {
        let newComment = Comment(text: text, post: post)
        let record = CKRecord(comment: newComment)
        
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("===== ERROR =====")
                print("Function: \(#function)")
                print(error)
                print("Description: \(error.localizedDescription)")
                print("===== ERROR =====")
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                  let comment = Comment(ckRecord: record, post: post) else { return completion(.failure(.unableToUnwrap)) }
            post.comments.append(comment)
            self.updateCommentCount(post: post, completion: {_ in})
            completion(.success(comment))
        }
        
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Result<Post?,PostError>) -> Void) {
        let newPost = Post(photo: image, caption: caption)
        let record = CKRecord(post: newPost)
        
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("===== ERROR =====")
                print("Function: \(#function)")
                print(error)
                print("Description: \(error.localizedDescription)")
                print("===== ERROR =====")
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                  let savedPost = Post(ckRecord: record) else { return completion(.failure(.unableToUnwrap)) }
            self.posts.append(savedPost)
            return completion(.success(savedPost))
        }
    }
    
    func fetchPosts(completion: @escaping (Result<[Post]?,PostError>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostStrings.recordType, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("===== ERROR =====")
                print("Function: \(#function)")
                print(error)
                print("Description: \(error.localizedDescription)")
                print("===== ERROR =====")
                return completion(.failure(.ckError(error)))
            }
            guard let records = records else { return completion(.failure(.unableToUnwrap)) }
            let fetchedRecords = records.compactMap { Post(ckRecord: $0) }
            self.posts = fetchedRecords
            return completion(.success(fetchedRecords))
        }
    }
    
    func fetchComments(for post: Post, completion: @escaping (Result<[Comment]?,PostError>) -> Void) {
        let postReference = post.recordID
        let predicate = NSPredicate(format: "%K == %@", CommentStrings.postReferenceKey , postReference)
        let commentIDs = post.comments.compactMap({$0.recordID})
        
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: "Comment", predicate: compoundPredicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("===== ERROR =====")
                print("Function: \(#function)")
                print(error)
                print("Description: \(error.localizedDescription)")
                print("===== ERROR =====")
                completion(.failure(.ckError(error)))
            }
            guard let records = records else { return completion(.failure(.unableToUnwrap)) }
            let comments = records.compactMap { Comment(ckRecord: $0, post: post) }
            post.comments.append(contentsOf: comments)
            completion(.success(comments))
        }
    }
    
    func updateCommentCount(post: Post, completion: @escaping (String) -> Void?) {
        post.commentCount += 1
        let record = CKRecord(post: post)
            
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { record, _, error in
            if let error = error {
                print("===== ERROR =====")
                print("Function: \(#function)")
                print(error)
                print("Description: \(error.localizedDescription)")
                print("===== ERROR =====")
                completion("Unable to update comment count")
                return
            } else {
                completion("Updated comment count")
                return
            }
        }
        publicDB.add(operation)
    }
}//End of Class
