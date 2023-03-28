//
//  MessageBoardWithSwiftUIApp.swift
//  MessageBoardWithSwiftUI
//
//  Created by Leo Ho on 2023/3/21.
//

import SwiftUI

@main
struct MessageBoardWithSwiftUIApp: App {
        
    let migration = Migrator()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.realmConfiguration, Migrator.setupRealmConfig())
        }
    }
}
