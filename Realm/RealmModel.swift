//
//  RealmModel.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/16.
//

import Foundation
import RealmSwift

//UserDiary: 테이블 이름
//@Persisted: 컬럼 이름
class UserDiary: Object {
    
    
    //PK(필수) : Int, String, UUID, ObjectId -> AutoIncrement
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var writeDate = Date()
    @Persisted var regDate = Date()
    @Persisted var favorite: Bool
    
    convenience init(title: String, content: String?, writeDate: Date, regDate: Date) {
        self.init()
        
        self.title = title
        self.content = content
        self.writeDate = writeDate
        self.regDate = regDate
        self.favorite = false
    }
}
