//
//  Post.swift
//  Continuum
//
//  Created by Devin Flora on 2/2/21.
//  Copyright © 2021 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

struct PostStrings {
    static let recordType = "Post"
    fileprivate static let captionKey = "caption"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let commentsKey = "comments"
    fileprivate static let photoAssetKey = "photo"
    fileprivate static let commentCountKey = "commentCount"
    
}//End of Struct


class Post {
    var photoData: Data?
    let timestamp: Date
    var caption: String
    var comments: [Comment]
    var recordID: CKRecord.ID
    var commentCount: Int = 0
    var photoAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print(error.localizedDescription)
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    init(photo: UIImage, caption: String, timestamp: Date = Date(), comments: [Comment] = [], commentCount: Int, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.caption = caption
        self.timestamp = timestamp
        self.comments = comments
        self.recordID = recordID
        self.commentCount = commentCount
        self.photo = photo
        
    }
}//End of Class

// MARK: - Extensions
extension Post: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if caption.lowercased().contains(searchTerm.lowercased()) {
            return true
        } else {
            return false
        }
    }
}//End of Extension

extension Post {
    convenience init?(ckRecord: CKRecord) {
        guard let caption = ckRecord[PostStrings.captionKey] as? String,
              let timestamp = ckRecord[PostStrings.timestampKey] as? Date,
              let comments = ckRecord[PostStrings.commentsKey] as? [Comment],
              let commentCount = ckRecord[PostStrings.commentCountKey] as? Int else { return nil }
        var foundPhoto: UIImage?
        if let photoAsset = ckRecord[PostStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not transform asset into data")
            }
        }
        self.init(photo: foundPhoto ?? UIImage(), caption: caption, timestamp: timestamp, comments: comments, commentCount: commentCount)
    }
}

extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType: PostStrings.recordType, recordID: post.recordID)
        setValuesForKeys([
            PostStrings.captionKey : post.caption,
            PostStrings.timestampKey : post.timestamp,
            PostStrings.photoAssetKey : post.photo,
            PostStrings.commentsKey : post.comments,
            PostStrings.commentCountKey : post.commentCount
        ])
    }
}//End of Extension

