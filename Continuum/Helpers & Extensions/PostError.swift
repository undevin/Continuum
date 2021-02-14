//
//  PostError.swift
//  Continuum
//
//  Created by Devin Flora on 2/2/21.
//  Copyright © 2021 trevorAdcock. All rights reserved.
//

import Foundation

enum PostError: LocalizedError {
    case ckError(Error)
    case unableToUnwrap
    case unexpectedRecordsFound
    case noUserLoggedIn
    case noUserForPost
    
    var errorDescription: String? {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .unableToUnwrap:
            return "Could not unwrap the value"
        case .unexpectedRecordsFound:
            return "No records found. Different data was expected"
        case .noUserLoggedIn:
            return "No user logged in. Check currentUser"
        case .noUserForPost:
            return "No user was found for posts"
        }
    }
}//End of Enum
