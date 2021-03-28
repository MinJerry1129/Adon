//
//  ServicerMapVC.swift
//  DreamApp
//
//  Created by bird on 3/9/21.
//
import GoogleMobileAds
import UIKit
import GoogleMaps
class ServicerMapVC: UIViewController {

    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var txtCategoryTitle: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    var servicerVC: ServicerVC!
    private let banner : GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-8064612229280440/6686469025"
        banner.load(GADRequest())
        return banner
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        banner.rootViewController = self
        adsView.addSubview(banner) 
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: 0, y: 0, width: adsView.frame.size.width, height: adsView.frame.size.height)
    }
    @IBAction func onListBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
