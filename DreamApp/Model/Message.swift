//
//  Message.swift
//  DreamApp
//
//  Created by bird on 3/24/21.
//

import Foundation

enum MessageSide {
    case receive
    case send
}

struct Message {
    var text = ""
    var date = ""
    var side: MessageSide = .send
}
