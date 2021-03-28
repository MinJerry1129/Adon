//
//  Message.swift
//  DreamApp
//
//  Created by bird on 3/24/21.
//

import Foundation

enum MessageSide {
    case left
    case right
}

struct Message {
    var text = ""
    var side: MessageSide = .right
}
