//
//  HomeView.swift
//  MessageBoardWithSwiftUI
//
//  Created by Leo Ho on 2023/3/21.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    
    @Environment(\.realm) private var realm
    
    var body: some View {
        MessageBoardView()
            .onAppear {
                print("File URL：",String(describing: realm.configuration.fileURL))
                print("SchemaVersion：",String(describing: realm.configuration.schemaVersion))
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
