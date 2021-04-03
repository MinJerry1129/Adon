//
//  FavoriteListCell.swift
//  DreamApp
//
//  Created by bird on 4/2/21.
//

import UIKit
import Cosmos
class FavoriteListCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var txtname: UILabel!
    @IBOutlet weak var userRatingCOS: CosmosView!
    @IBOutlet weak var favCountTxt: UILabel!
    @IBOutlet weak var reviewCountTxt: UILabel!
    
}
