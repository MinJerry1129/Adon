//
//  ServicerListVC.swift
//  DreamApp
//
//  Created by bird on 3/9/21.
//
import GoogleMobileAds
import UIKit
import Alamofire
import SDWebImage
import Toast_Swift
import JTMaterialSpinner
class ServicerListVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var txtCategoryTitle: UILabel!
    @IBOutlet weak var ServicerListTable: UITableView!
    
    var servicermapVC : ServicerMapVC!
    var servicerVC: ServicerVC!
    var spinnerView = JTMaterialSpinner()
    var serviceId : String!
    var allServicers = [ServicersList]()
    var user_uid : String!
    
    private let banner : GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = Global.admobID
        banner.load(GADRequest())
        return banner
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        ServicerListTable.delegate = self
        ServicerListTable.dataSource = self
        ServicerListTable.register(UINib(nibName: "ServicerListCell", bundle: nil), forCellReuseIdentifier: "cell")
        ServicerListTable.isUserInteractionEnabled = false
        banner.rootViewController = self
        adsView.addSubview(banner)
        
        serviceId = AppDelegate.shared().serviceID
        user_uid = AppDelegate.shared().user_uid
        
        setReady()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: 0, y: 0, width: adsView.frame.size.width, height: adsView.frame.height)
    }
    func setReady(){
        txtCategoryTitle.text = AppDelegate.shared().serviceName
    }
    func getData(){
        allServicers = []
        //
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        let parameters: Parameters = ["id": serviceId ?? "1"]
        AF.request(Global.baseUrl + "api/getServicersInfo", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                self.ServicerListTable.isUserInteractionEnabled = true
                let servicersInfo = value["servicersInfo"] as? [[String: AnyObject]]
                if servicersInfo!.count > 0{
                    for i in 0 ... (servicersInfo!.count)-1 {
                        let id = servicersInfo![i]["id"] as! String
                        let uid = servicersInfo![i]["uid"] as! String
                        let firstname = servicersInfo![i]["firstname"] as! String
                        let lastname = servicersInfo![i]["lastname"] as! String
                        let location = servicersInfo![i]["location"] as! String
                        let latitude = servicersInfo![i]["latitude"] as! String
                        let longitude = servicersInfo![i]["longitude"] as! String
                        let avatar = servicersInfo![i]["avatar"] as! String
                        let price = servicersInfo![i]["price"] as! String
                        let fcount = servicersInfo![i]["fcount"] as! Int
                        let lcount = servicersInfo![i]["lcount"] as! Int
                        let rmark = servicersInfo![i]["lmark"] as! Double
                        if uid != self.user_uid{
                            let servicerCell = ServicersList(id: id, uid: uid, firstname: firstname, lastname: lastname, location: location, latitude: latitude, longitude: longitude, avatar: avatar, price: price,fcount: fcount, lcount: lcount,rmark: rmark)
                            self.allServicers.append(servicerCell)
                        }
//
                    }
                }
//                
                self.ServicerListTable.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allServicers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServicerListCell
        let oneservicers = allServicers[indexPath.row]
        cell.mainView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        cell.servicerImg.sd_setImage(with: URL(string: Global.baseUrl + oneservicers.avatar), completed: nil)
        cell.servicerName.text = oneservicers.firstname + " " + oneservicers.lastname
        cell.servicerRate.text = oneservicers.price + "$/hr"
        cell.servicerLike.text = "\(oneservicers.fcount)"
        cell.servicerReview.text = "\(oneservicers.lcount)"
        cell.servicerRatingView.rating = oneservicers.rmark
        cell.servicerRatingView.text = "\(oneservicers.rmark)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.shared().seluser_uid = allServicers[indexPath.row].uid
        self.servicerVC = self.storyboard?.instantiateViewController(withIdentifier: "servicerVC") as? ServicerVC
        self.servicerVC.modalPresentationStyle = .fullScreen
        self.present(self.servicerVC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    @IBAction func onMapBtn(_ sender: Any) {
        self.servicermapVC = self.storyboard?.instantiateViewController(withIdentifier: "servicermapVC") as? ServicerMapVC
        self.servicermapVC.modalPresentationStyle = .fullScreen
        self.present(self.servicermapVC, animated: true, completion: nil)
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
