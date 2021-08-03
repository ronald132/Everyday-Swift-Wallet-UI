//
//  Week.swift
//  Everyday Swift Wallet UI
//
//  Created by Ronald on 4/8/21.
//

import SwiftUI

struct Week : Identifiable {
    var id = UUID().uuidString
    var day: String
    var date: String
    var amountSpent: CGFloat
}
