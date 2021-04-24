//
//  ServiceOneVC.swift
//  DreamApp
//
//  Created by bird on 4/24/21.
//

import UIKit
import Alamofire
import SDWebImage
import JTMaterialSpinner
import Toast_Swift

class ServiceOneVC: UIViewController {
    @IBOutlet weak var imgServicer: UIImageView!
    @IBOutlet weak var txtServicerName: UILabel!
    @IBOutlet weak var txtServicerRate: UILabel!
    @IBOutlet weak var btnSendMsg: UIButton!
    @IBOutlet weak var btnCompleteService: UIButton!
    @IBOutlet weak var segSelType: UISegmentedControl!
    @IBOutlet weak var logWorkTB: UITableView!
    
    var userId : String!
    var suid : String!
    var serviceId : String!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
