//
//  AddEditMessageView.swift
//  MessageBoardWithSwiftUI
//
//  Created by Leo Ho on 2023/3/21.
//

import SwiftUI
import RealmSwift

struct AddEditMessageView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedRealmObject var messageList: Message
    
    var messageToEdit: Message?
    
    @State private var person: String = ""
    
    @State private var message: String = ""
    
    @State private var isPresentedAlert: Bool = false
    
    private var displayMode: DisplayMode = .add
    
    enum DisplayMode {
        
        /// 新增留言
        case add
        
        /// 編輯留言
        case edit
    }
    
    enum BuildViewOptions {
        
        /// 留言人
        case person
        
        /// 留言內容
        case message
        
        /// 儲存按鈕
        case saveButton
    }
    
    init(messageList: Message, messageToEdit: Message? = nil, displayMode: DisplayMode) {
        self.messageList = messageList
        self.messageToEdit = messageToEdit
        self.displayMode = displayMode
        
        if let messageToEdit = messageToEdit {
            _person = State(initialValue: messageToEdit.person)
            _message = State(initialValue: messageToEdit.message)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                buildView(build: .person)
                buildView(build: .message)
                buildView(build: .saveButton)
            }
            .navigationTitle(displayMode == .add ? "新增留言" : "編輯留言")
        }
    }
}

// MARK: - ViewBuilder

extension AddEditMessageView {
    
    /// 建構畫面
    /// - Parameters:
    ///   - options: 要建構哪一個畫面
    /// - Returns: some View
    @ViewBuilder private func buildView(build options: BuildViewOptions) -> some View {
        switch options {
        case .person:
            buildMessageView(icon: "person.circle.fill",
                             text: "留言人：",
                             placeHolder: "請輸入留言人...",
                             textFieldText: $person)
        case .message:
            buildMessageView(icon: "message.circle.fill",
                             text: "留言內容：",
                             placeHolder: "請輸入留言內容...",
                             textFieldText: $message)
        case .saveButton:
            Button {
                switch displayMode {
                case .add:
                    save()
                    dismiss()
                case .edit:
                    if !message.isEmpty && !person.isEmpty {
                        update()
                    } else {
                        isPresentedAlert.toggle()
                    }
                }
            } label: {
                Text(displayMode == .add ? "儲存" : "更新")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .alert("請將留言填寫完整！", isPresented: $isPresentedAlert) {
                Button("確認") {
                    dismiss()
                }
            }
        }
    }
    
    /// 建立留言人、留言內容的 View
    /// - Parameters:
    ///   - icon: SF Symbols icon 名稱
    ///   - text: Text 要顯示的字
    ///   - textField: TextField placeholder
    ///   - textFieldText: TextField 要顯示的字
    /// - Returns: some View
    @ViewBuilder private func buildMessageView(icon: String,
                                               text: String,
                                               placeHolder: String,
                                               textFieldText: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon)
            Text(text)
            TextField(placeHolder, text: textFieldText)
        }
    }
}

// MARK: - Realm Function

extension AddEditMessageView {
    
    /// 儲存留言到 Realm 內
    private func save() {
        do {
            let realm = try Realm()
            
            let msg = Message()
            msg.person = person
            msg.message = message
            msg.timestamp = Int64(Date().timeIntervalSince1970)
            msg.date = Date(timestamp: Int64(Date().timeIntervalSince1970))
            
            try realm.write {
                realm.add(msg)
            }
        } catch {
            print("Add Message Failed，Error：\(error.localizedDescription)")
        }
    }
    
    /// 更新 Realm 內的留言
    private func update() {
        if let messageToEdit = messageToEdit {
            do {
                let realm = try Realm()
                guard let result = realm.object(ofType: Message.self,
                                                forPrimaryKey: messageToEdit._id) else {
                    return
                }
                try realm.write {
                    result.person = person
                    result.message = message
                    result.timestamp = Int64(Date().timeIntervalSince1970)
                    result.date = Date(timestamp: Int64(Date().timeIntervalSince1970))
                }
            } catch {
                print("Update Message Failed，Error：\(error.localizedDescription)")
            }
        }
    }
}

struct AddMessageView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditMessageView(messageList: Message(), displayMode: .add)
    }
}
