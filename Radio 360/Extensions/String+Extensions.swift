//
//  String+Extensions.swift
//  Radio 360
//
//  Created by Hadi Ali on 08/07/2021.
//

import Foundation

// MARK: - String extension

extension String {
    
    /// get strings from localized files
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
