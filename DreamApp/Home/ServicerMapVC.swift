//
//  ServicerMapVC.swift
//  DreamApp
//
//  Created by bird on 3/9/21.
//

import UIKit
import GoogleMaps
class ServicerMapVC: UIViewController {

    @IBOutlet weak var txtCategoryTitle: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    var servicerVC: ServicerVC!
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    @IBAction func onListBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
