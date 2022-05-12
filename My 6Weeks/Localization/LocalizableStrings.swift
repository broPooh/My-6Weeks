//
//  LocalizableStrings.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/12.
//

import Foundation

enum LocalizableStrings: String {
    case welcome_text
    case data_backup = "백업하기"
    case data_restore = "라라라랄라라라"
    
    
    var localized: String {
        return self.rawValue.localized() //Localizable.strings
    }
    
    var localizedWithTabel: String {
        return self.rawValue.localized(tableName: "Setting") //Localizable.strings
    }
    
    func localizedWithTable(tableName: String) -> String {
        return self.rawValue.localized(tableName: tableName) //Localizable.strings
    }
}
