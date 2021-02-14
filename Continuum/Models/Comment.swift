//
//  Comment.swift
//  Continuum
//
//  Created by Devin Flora on 2/2/21.
//  Copyright © 2021 trevorAdcock. All rights reserved.
//

import CloudKit

struct CommentStrings {
    static let recordType = "Comment"
    fileprivate static let textKey = "text"
    fileprivate static let timestampKey = "timestamp"
    static let postReferenceKey = "post"
}


class Comment {
    var text: String
    let timestamp: Date
    weak var post: Post?
    var recordID: CKRecord.ID
    var postReference: CKRecord.Reference? {
        guard let post = post else { return nil }
        return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
    }
    
    init(text: String, timestamp: Date = Date(), post: Post, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
        self.recordID = recordID
    }
}//End of Class

// MARK: - Extensions
extension Comment {
    convenience init?(ckRecord: CKRecord, post: Post){
        guard let text = ckRecord[CommentStrings.textKey] as? String,
              let timestamp = ckRecord[CommentStrings.timestampKey] as? Date else { return nil }
        
        self.init(text: text, timestamp: timestamp, post: post, recordID: ckRecord.recordID)
    }
}//End of Extension

extension Comment: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return text.contains(searchTerm)
    }
}//End of Extension

extension CKRecord {
    convenience init(comment: Comment) {
        self.init(recordType: CommentStrings.recordType, recordID: comment.recordID)
        setValuesForKeys([
            CommentStrings.textKey : comment.text,
            CommentStrings.timestampKey : comment.timestamp,
            CommentStrings.postReferenceKey : comment.postReference
        ])
    }
}//End of Extension

