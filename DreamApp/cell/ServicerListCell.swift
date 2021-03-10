//
//  ServicerListCell.swift
//  DreamApp
//
//  Created by bird on 3/9/21.
//

import UIKit
import Cosmos
class ServicerListCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var servicerImg: UIImageView!
    @IBOutlet weak var servicerName: UILabel!
    @IBOutlet weak var servicerRate: UILabel!
    @IBOutlet weak var servicerRatingView: CosmosView!
    @IBOutlet weak var servicerLike: UILabel!
    @IBOutlet weak var servicerReview: UILabel!
    
}
