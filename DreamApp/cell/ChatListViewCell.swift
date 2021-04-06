//
//  ChatListViewCell.swift
//  ChatSample
//
//  Created by Hafiz on 22/10/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import UIKit
import SDWebImage
class ChatListViewCell: UITableViewCell {

    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var chatTitleLabel: UILabel!
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var alarmImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatImageView.rounded(radius: chatImageView.frame.width/2)
    }
    
    func configure(chat: Chat) {
        chatTitleLabel.text = chat.title
        senderLabel.text = chat.sender
        if chat.status == "no"  {
            alarmImg.isHidden = true
        }
        else {
            senderLabel.isHidden = false
        }
        chatImageView.sd_setImage(with: URL(string: Global.baseUrl + chat.imageUrl), completed: nil)
    }
}
