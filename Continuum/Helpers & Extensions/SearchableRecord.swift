//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Devin Flora on 2/3/21.
//  Copyright © 2021 trevorAdcock. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}//End of Protocol
