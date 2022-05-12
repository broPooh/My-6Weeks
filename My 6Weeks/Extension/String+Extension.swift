//
//  String+Extension.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/12.
//

import Foundation

extension String {
//    var localized: String {
//        return NSLocalizedString(self, comment: "")
//    }
    
    
    func localized(tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: .main, value: "", comment: "")
    }
}
