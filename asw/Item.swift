//
//  Item.swift
//  asw
//
//  Created by Seam Boleslawski on 21.11.23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
