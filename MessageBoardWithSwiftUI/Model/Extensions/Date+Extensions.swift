//
//  Date+Extensions.swift
//  MessageBoardWithSwiftUI
//
//  Created by Leo Ho on 2023/3/28.
//

import Foundation

extension Date {

    /// 透過時間戳來初始化 Date (UTC+0)
    /// - Parameters:
    ///   - timestamp: 時間戳，Int64
    init(timestamp: Int64) {
        self.init(timeIntervalSince1970: TimeInterval(timestamp))
    }
}
