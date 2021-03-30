//
//  ServicerVC.swift
//  DreamApp
//
//  Created by bird on 3/14/21.
//
import GoogleMobileAds
import UIKit
import Cosmos
class ServicerVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var servicerNameTxt: UILabel!
    @IBOutlet weak var servicerImg: UIImageView!
    @IBOutlet weak var servicerNameVTxt: UILabel!
    @IBOutlet weak var ratingCOs: CosmosView!
    @IBOutlet weak var likeCountTxt: UILabel!
    @IBOutlet weak var reviewCountTxt: UILabel!
    @IBOutlet weak var hourlyRateTxt: UILabel!
    @IBOutlet weak var requestServiceBtn: UIButton!
    @IBOutlet weak var servicerInfoTxt: UILabel!
    @IBOutlet weak var serviceReviewTB: UITableView!
    
    private let banner : GADBannerView = {
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [""]
        let banner = GADBannerView()
        banner.adUnitID = Global.admobID
        banner.load(GADRequest())
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceReviewTB.delegate = self
        serviceReviewTB.dataSource = self
        serviceReviewTB.register(UINib(nibName: "ReviewListCell", bundle: nil), forCellReuseIdentifier: "cell")
        banner.rootViewController = self
        banner.delegate = self
        
        adsView.addSubview(banner)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: 0, y: 0, width: adsView.frame.size.width, height: adsView.frame.size.height)        
    }
    @IBAction func onRequestService(_ sender: Any) {
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReviewListCell
        cell.mainView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    @IBAction func onBackBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ServicerVC: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}
