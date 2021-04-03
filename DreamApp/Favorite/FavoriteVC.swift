//
//  FavoriteVC.swift
//  DreamApp
//
//  Created by bird on 3/14/21.
//

import UIKit
import JTMaterialSpinner
import Alamofire
import SDWebImage
import Toast_Swift

class FavoriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var favoriteTable: UITableView!
    
    var spinnerView = JTMaterialSpinner()
    var serviceId : String!
    var allServicers = [ServicersList]()
    var user_uid : String!
    
    
    var servicerVC : ServicerVC!
    var homeVC : HomeVC!
    var historyVC : HistoryVC!
    var chatVC : ChatVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTable.delegate = self
        favoriteTable.dataSource = self
        favoriteTable.register(UINib(nibName: "FavoriteListCell", bundle: nil), forCellReuseIdentifier: "cell")
        favoriteTable.isUserInteractionEnabled = false
        user_uid = AppDelegate.shared().user_uid
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getData()
    }
    
    func getData(){
        allServicers = []
        //
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        let parameters: Parameters = ["uid": user_uid!]
        AF.request(Global.baseUrl + "api/getFavoriteInfo", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                self.favoriteTable.isUserInteractionEnabled = true
                let servicersInfo = value["servicersInfo"] as? [[String: AnyObject]]
                if servicersInfo!.count > 0{
                    for i in 0 ... (servicersInfo!.count)-1 {
                        let id = servicersInfo![i]["id"] as! String
                        let uid = servicersInfo![i]["uid"] as! String
                        let jobid = servicersInfo![i]["jobid"] as! String
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
                        
                        let servicerCell = ServicersList(id: id, uid: uid, jobid: jobid, firstname: firstname, lastname: lastname, location: location, latitude: latitude, longitude: longitude, avatar: avatar, price: price,fcount: fcount, lcount: lcount,rmark: rmark)
                        self.allServicers.append(servicerCell)
                        
//
                    }
                }
////
                self.favoriteTable.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allServicers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavoriteListCell
        let oneservicers = allServicers[indexPath.row]
        cell.mainView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        cell.userImg.sd_setImage(with: URL(string: Global.baseUrl + oneservicers.avatar), completed: nil)
        cell.txtname.text = oneservicers.firstname + " " + oneservicers.lastname
        cell.favCountTxt.text = "\(oneservicers.fcount)"
        cell.reviewCountTxt.text = "\(oneservicers.lcount)"
        cell.userRatingCOS.rating = oneservicers.rmark
        cell.userRatingCOS.text = "\(oneservicers.rmark)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.shared().seluser_uid = allServicers[indexPath.row].uid
        AppDelegate.shared().serviceID = allServicers[indexPath.row].jobid
        self.servicerVC = self.storyboard?.instantiateViewController(withIdentifier: "servicerVC") as? ServicerVC
        self.servicerVC.modalPresentationStyle = .fullScreen
        self.present(self.servicerVC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    @IBAction func onHistoryBtn(_ sender: Any) {
        self.historyVC = self.storyboard?.instantiateViewController(withIdentifier: "historyVC") as? HistoryVC
        self.historyVC.modalPresentationStyle = .fullScreen
        self.present(self.historyVC, animated: true, completion: nil)
        
    }
    
    @IBAction func onHomeBtn(_ sender: Any) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.homeVC.modalPresentationStyle = .fullScreen
        self.present(self.homeVC, animated: true, completion: nil)
        
    }
    
    @IBAction func onChatBtn(_ sender: Any) {
        self.chatVC = self.storyboard?.instantiateViewController(withIdentifier: "chatVC") as? ChatVC
        self.chatVC.modalPresentationStyle = .fullScreen
        self.present(self.chatVC, animated: true, completion: nil)
    }
}
