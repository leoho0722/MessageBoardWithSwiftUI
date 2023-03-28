//
//  MessageBoardView.swift
//  MessageBoardWithSwiftUI
//
//  Created by Leo Ho on 2023/3/21.
//

import SwiftUI
import RealmSwift

struct MessageBoardView: View {
    
    @ObservedResults(Message.self) private var messageList
    
    @State private var filterKey: String = FilterKey.oldToNew.rawValue
    
    @State private var isPresentedSheet: Bool = false
    
    var messages: Results<Message> {
        if filterKey == FilterKey.oldToNew.rawValue {
            return messageList
        } else {
            return messageList.sorted(byKeyPath: "timestamp", ascending: false)
        }
    }
    
    enum FilterKey: String {
        
        /// 新到舊
        case newToOld = "newToOld"
        
        /// 舊到新
        case oldToNew = "oldToNew"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                buildView()
            }
            .navigationTitle("留言板")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    buildFilterMenu()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    buildAddButton()
                }
            }.sheet(isPresented: $isPresentedSheet) {
                AddEditMessageView(messageList: Message(), displayMode: .add)
                    .presentationDetents([.medium])
            }
        }
    }
}

// MARK: - ViewBuilder

extension MessageBoardView {
    
    @ViewBuilder private func buildView() -> some View {
        List {
            ForEach(messages) { message in
                NavigationLink {
                    AddEditMessageView(messageList: message,
                                       messageToEdit: message,
                                       displayMode: .edit)
                } label: {
                    buildMessageView(message: message)
                }
            }.onDelete(perform: $messageList.remove)
        }
    }
    
    @ViewBuilder private func buildMessageView(message: Message) -> some View {
        VStack(alignment: .leading) {
            Text(message.person)
            Text(message.message)
        }
    }
    
    @ViewBuilder private func buildFilterMenu() -> some View {
        Menu {
            Button {
                filterKey = FilterKey.oldToNew.rawValue
            } label: {
                Text("舊到新 (預設)")
            }
            
            Button {
                filterKey = FilterKey.newToOld.rawValue
            } label: {
                Text("新到舊")
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
        }
    }
    
    @ViewBuilder private func buildAddButton() -> some View {
        Button {
            isPresentedSheet.toggle()
        } label: {
            Image(systemName: "plus")
        }
    }
}

struct MessageBoardView_Previews: PreviewProvider {
    static var previews: some View {
        MessageBoardView()
    }
}
