//
//  Migrator.swift
//  MessageBoardWithSwiftUI
//
//  Created by Leo Ho on 2023/3/22.
//

import Foundation
import RealmSwift

class Migrator {
    
    func updateSchema() {
        let config = Migrator.setupRealmConfig()
        
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
    
    static func setupRealmConfig() -> Realm.Configuration {
        return Realm.Configuration(schemaVersion: 2) { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                // 新增新欄位
                migration.enumerateObjects(ofType: Message.className()) { oldObject, newObject in
                    newObject!["date"] = Date()
                }
            }
        }
    }
}
