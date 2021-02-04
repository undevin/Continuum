//
//  DateFormatterExtension.swift
//  Continuum
//
//  Created by Devin Flora on 2/2/21.
//  Copyright © 2021 trevorAdcock. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let postDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}//End of Extension
