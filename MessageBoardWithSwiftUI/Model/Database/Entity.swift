//
//  Entity.swift
//  MessageBoardWithSwiftUI
//
//  Created by Leo Ho on 2023/3/21.
//

import SwiftUI
import RealmSwift

class Message: Object, ObjectKeyIdentifiable {
    
    /// UUID，Primary Key
    @Persisted(primaryKey: true) var _id: ObjectId
    
    /// 留言人
    @Persisted var person: String = ""
    
    /// 留言內容
    @Persisted var message: String = ""
    
    /// 留言當下／更新留言當下的時間戳
    @Persisted var timestamp: Int64 = 0
    
    /// 日期
    @Persisted var date = Date()
}
