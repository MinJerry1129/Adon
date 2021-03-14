//
//  ReviewListCell.swift
//  DreamApp
//
//  Created by bird on 3/14/21.
//

import UIKit
import Cosmos
class ReviewListCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var dateTxt: UILabel!
    @IBOutlet weak var reviewRating: CosmosView!
    @IBOutlet weak var reviewTxt: UITextView!
}
