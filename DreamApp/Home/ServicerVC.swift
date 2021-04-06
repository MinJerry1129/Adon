//
//  ServicerVC.swift
//  DreamApp
//
//  Created by bird on 3/14/21.
//
import GoogleMobileAds
import UIKit
import Cosmos
import Alamofire
import Toast_Swift
import SDWebImage
import JTMaterialSpinner
class ServicerVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var chatVC : ChatVC!
    var loginhomeVC : LoginHomeVC!
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
    
    @IBOutlet weak var likeImg: UIImageView!
    
    var spinnerView = JTMaterialSpinner()
    
    var suid : String!
    var jobid : String!
    var user_uid : String!
    var ilike : Int!
    var fcount = 0
    var loginStatus : String!
    
    var allReviews = [Review]()
    
    private let banner : GADBannerView = {
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
        serviceReviewTB.isUserInteractionEnabled = false
        banner.rootViewController = self
        banner.delegate = self
        suid = AppDelegate.shared().seluser_uid
        jobid = AppDelegate.shared().serviceID
        user_uid = AppDelegate.shared().user_uid
        loginStatus = AppDelegate.shared().loginStatus
        
        likeImg.isUserInteractionEnabled = true
        let gestureRecognizerw = UITapGestureRecognizer(target: self, action: #selector(setfavorite))
        likeImg.addGestureRecognizer(gestureRecognizerw)
        
        adsView.addSubview(banner)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: 0, y: 0, width: adsView.frame.size.width, height: adsView.frame.size.height)        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getData()
        
    }
    func getData(){
        allReviews = []
        //
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        let parameters: Parameters = ["cuid" : user_uid, "suid": suid, "jobid" : jobid]
        AF.request(Global.baseUrl + "api/getServicerInfo", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                self.serviceReviewTB.isUserInteractionEnabled = true
                let servicerReviewInfo = value["servicerReviewInfo"] as? [[String: AnyObject]]
                let servicerInfo = value["servicersInfo"] as? [String: AnyObject]
                if servicerReviewInfo!.count > 0{
                    for i in 0 ... (servicerReviewInfo!.count)-1 {
                        let id = servicerReviewInfo![i]["id"] as! String
                        let cuid = servicerReviewInfo![i]["cuid"] as! String
                        let suid = servicerReviewInfo![i]["suid"] as! String
                        let jobid = servicerReviewInfo![i]["jobid"] as! String
                        let firstname = servicerReviewInfo![i]["firstname"] as! String
                        let lastname = servicerReviewInfo![i]["lastname"] as! String
                        let review = servicerReviewInfo![i]["review"] as! String
                        let avatar = servicerReviewInfo![i]["avatar"] as! String
                        let rmark = servicerReviewInfo![i]["mark"] as! String
                        let rdate = servicerReviewInfo![i]["date"] as! String
                        

                        let reviewCell = Review(id: id, cuid: cuid, suid: suid, jobid: jobid, firstname: firstname, lastname: lastname, rdate: rdate, avatar: avatar, rmark: rmark, review: review, status: "complete")
                        self.allReviews.append(reviewCell)
                    }
                }
                
                let id = servicerInfo!["id"] as! String
                let uid = servicerInfo!["uid"] as! String
                let firstname = servicerInfo!["firstname"] as! String
                let lastname = servicerInfo!["lastname"] as! String
                let location = servicerInfo!["location"] as! String
                let latitude = servicerInfo!["latitude"] as! String
                let longitude = servicerInfo!["longitude"] as! String
                let avatar = servicerInfo!["avatar"] as! String
                let price = servicerInfo!["price"] as! String
                let information = servicerInfo!["information"] as! String
                self.fcount = servicerInfo!["fcount"] as! Int
                let lcount = servicerInfo!["lcount"] as! Int
                let rmark = servicerInfo!["lmark"] as! Double
                self.ilike = servicerInfo!["ilike"] as! Int
                
                self.servicerNameTxt.text = firstname + " " + lastname
                self.servicerImg.sd_setImage(with: URL(string: Global.baseUrl + avatar), completed: nil)
                self.servicerInfoTxt.text = information
                self.servicerNameVTxt.text = firstname + " " + lastname
                self.hourlyRateTxt.text = "\(price)" + "$/hr"
                self.reviewCountTxt.text = "\(lcount)"
                self.likeCountTxt.text = "\(self.fcount)"
                self.ratingCOs.rating = rmark
                self.ratingCOs.text = "\(rmark)"
                if self.ilike == 0 {
                    self.likeImg.image = UIImage(systemName: "heart")
                }else{
                    self.likeImg.image = UIImage(systemName: "heart.fill")
                }

                self.serviceReviewTB.reloadData()
            }
        }
    }
    
    @objc func setfavorite(){
        if ilike == 0 {
            onSetLike()
        }else{
            onSetUnlike()
        }
    }
    
    func onSetLike(){
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        let parameters: Parameters = ["cuid" : user_uid, "suid": suid, "jobid" : jobid]
        AF.request(Global.baseUrl + "api/setLike", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let result = value["status"] as? String
                if result == "ok"{
                    self.ilike = 1
                    self.fcount = self.fcount + 1
                    self.likeCountTxt.text = "\(self.fcount)"
                    self.likeImg.image = UIImage(systemName: "heart.fill")
                }else{
                    self.view.makeToast("Set fail!")
                }
            }
        }
    }
    
    func onSetUnlike(){
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        let parameters: Parameters = ["cuid" : user_uid, "suid": suid, "jobid" : jobid]
        AF.request(Global.baseUrl + "api/setUnLike", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let result = value["status"] as? String
                if result == "ok"{
                    self.ilike = 0
                    self.fcount = self.fcount - 1
                    self.likeCountTxt.text = "\(self.fcount)"
                    self.likeImg.image = UIImage(systemName: "heart")
                }else{
                    self.view.makeToast("Set fail!")
                }
            }
        }
    }
    
    
    @IBAction func onRequestService(_ sender: Any) {
        if loginStatus == "no"{
            self.loginhomeVC = self.storyboard?.instantiateViewController(withIdentifier: "loginhomeVC") as? LoginHomeVC
            self.loginhomeVC.modalPresentationStyle = .fullScreen
            self.present(self.loginhomeVC, animated: true, completion: nil)
        }else{
            self.view.addSubview(spinnerView)
            spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
            spinnerView.circleLayer.lineWidth = 2.0
            spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
            spinnerView.beginRefreshing()
            
            let parameters: Parameters = ["cuid" : user_uid, "suid": suid, "jobid" : jobid]
            AF.request(Global.baseUrl + "api/requestService", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
                print(response)
                self.spinnerView.endRefreshing()
                if let value = response.value as? [String: AnyObject] {
                    let result = value["status"] as? String
                    if result == "ok"{
                        self.chatVC = self.storyboard?.instantiateViewController(withIdentifier: "chatVC") as? ChatVC
                        self.chatVC.modalPresentationStyle = .fullScreen
                        self.present(self.chatVC, animated: true, completion: nil)
                        self.view.makeToast("Requst")
                    }else{
                        self.view.makeToast("Set fail!")
                    }
                }
            }
            
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneReview = allReviews[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReviewListCell
        cell.mainView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        cell.userImg.sd_setImage(with: URL(string: Global.baseUrl + oneReview.avatar), completed: nil)
        cell.nameTxt.text = oneReview.firstname + " " + oneReview.lastname
        cell.dateTxt.text = oneReview.rdate
        cell.reviewRating.rating = Double(oneReview.rmark) ?? 0.0
        cell.reviewRating.text = oneReview.rmark
        cell.reviewTxt.text = oneReview.review
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = self.getRowHeightFromText(strText: allReviews[indexPath.row].review)
        return height
    }
    func getRowHeightFromText(strText : String!) -> CGFloat
    {
        let textView : UITextView! = UITextView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.95 - 20 ,  height: 0))
        textView.text = strText
        textView.font = UIFont(name: "system", size:  12.0)
        textView.sizeToFit()

        var txt_frame : CGRect! = CGRect()
        txt_frame = textView.frame

        var size : CGSize! = CGSize()
        size = txt_frame.size

        size.height = txt_frame.size.height

        return (size.height + 60) / 0.95
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
