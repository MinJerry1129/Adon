//
//  PersonVC.swift
//  DreamApp
//
//  Created by bird on 1/10/21.
//

import UIKit
import Firebase
import Alamofire
import JTMaterialSpinner
import SDWebImage
import Toast_Swift
class PersonVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var addserviceVC : AddServiceVC!
    var updateinfoVC : UpdateInfoVC!
    
    @IBOutlet weak var ServiceRateTB: UITableView!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnPhoneVerify: UIButton!
    
    var spinnerView = JTMaterialSpinner()
    
    var user_uid : String!
    var verify_status : String!
    var firstname : String!
    var lastname : String!
    var phone : String!
    var location : String!
    var info : String!
    var avatarImage : String!
    var phone_verify : String!
    
    var allJobRate = [JobRate]()    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServiceRateTB.delegate = self
        ServiceRateTB.dataSource = self
        ServiceRateTB.register(UINib(nibName: "ServiceRateCell", bundle: nil), forCellReuseIdentifier: "cell")
        user_uid = AppDelegate.shared().user_uid
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserData()
    }
    
    func getUserData(){
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["uid": user_uid!]
        AF.request(Global.baseUrl + "api/getuserdata", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.allJobRate = []
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let userinfo = value["userInfo"] as? [String: AnyObject]
                self.avatarImage = userinfo!["avatar"] as? String
                self.firstname = userinfo!["firstname"] as? String
                self.lastname = userinfo!["lastname"] as? String
                self.phone = userinfo!["phone"] as? String
                self.location = userinfo!["location"] as? String
                self.info = userinfo!["information"] as? String
                self.verify_status = userinfo!["status"] as? String
                self.phone_verify = userinfo!["phoneverify"] as? String
                
                let joblistInfos = value["joblistInfo"] as? [[String: AnyObject]]
                if joblistInfos!.count > 0{
                    for i in 0 ... (joblistInfos!.count)-1 {
                        let id = joblistInfos![i]["id"] as! String
                        let jobid = joblistInfos![i]["jobid"] as! String
                        let name = joblistInfos![i]["jobname"] as! String
                        let price = joblistInfos![i]["price"] as! String
//                        self.categoryNames.append(name)
//                        self.categoryIDS.append(Int(id) ?? 1)
                        let jobrateCell = JobRate(id: id, jobid: jobid, title: name, price: price)
                        self.allJobRate.append(jobrateCell)
                    }
                }
                self.ServiceRateTB.reloadData()
                self.setReady()
            }
        }
    }
    
    func setReady(){
        self.lblUsername.text = firstname + " " + lastname
        self.lblPhone.text = phone
        self.lblLocation.text = location
//                self.lblInfo.text = info
        self.imgAvatar.sd_setImage(with: URL(string: Global.baseUrl + avatarImage), completed: nil)
        if verify_status == "verify"{
            btnVerify.setTitle("Verified", for: .normal)
            btnVerify.setTitleColor(UIColor(named: "MajorColor"), for: .normal)
        }else if verify_status == "new"{
            btnVerify.setTitle("Verify your account", for: .normal)
            btnVerify.setTitleColor(UIColor(named: "RedBrown"), for: .normal)
            
        }else if verify_status == "block"{
            btnVerify.setTitle("Account Blocked", for: .normal)
            btnVerify.setTitleColor(UIColor(named: "textBlack"), for: .normal)
        }
        if phone_verify == "yes"{
            btnPhoneVerify.setTitle("Verified", for: .normal)
            btnPhoneVerify.backgroundColor = UIColor(named: "MajorColor")
        }else{
            btnPhoneVerify.setTitle("Verify", for: .normal)
            btnPhoneVerify.backgroundColor = UIColor(named: "RedBrown")
        }
    }
    func updatePhonenumber(phonenumber : String){
        print(phonenumber)
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["uid": user_uid!, "phone" : phonenumber]
        AF.request(Global.baseUrl + "api/updateUserPhone", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                self.phone = phonenumber
                self.verify_status = "no"
                self.setReady()
            }
        }
    }
    
    @IBAction func onBtnUpdatePhone(_ sender: Any) {
        let alert = UIAlertController(title: "update phonenumber", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.phone
            textField.placeholder = "Input phonenumber"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.updatePhonenumber(phonenumber: textField!.text!)
            
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onBtnVerifyPhone(_ sender: Any) {
    }
    
    @IBAction func onBtnUpdateInfo(_ sender: Any) {
        self.updateinfoVC = self.storyboard?.instantiateViewController(withIdentifier: "updateinfoVC") as? UpdateInfoVC
        self.updateinfoVC.modalPresentationStyle = .fullScreen
        self.present(self.updateinfoVC, animated: true, completion: nil)
    }
    
    @IBAction func onBtnVerify(_ sender: Any) {
    }
    
    @IBAction func onSignout(_ sender: Any) {
        try! Auth.auth().signOut()
        AppDelegate.shared().loginStatus = "no"
        UserDefaults.standard.set("no", forKey: "loginstatus")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddService(_ sender: Any) {
        if verify_status == "verify" {
            self.addserviceVC = self.storyboard?.instantiateViewController(withIdentifier: "addserviceVC") as? AddServiceVC
            self.addserviceVC.modalPresentationStyle = .fullScreen
            self.present(self.addserviceVC, animated: true, completion: nil)
        }else if verify_status == "block" {
            let alert = UIAlertController(title: nil, message: "Your account is blocked, Please send contact to support team", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: nil , message: "Please Verify your account to work here.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allJobRate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneJobRate: JobRate
        oneJobRate =  allJobRate[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceRateCell
        
        cell.lblHourlyRate.text = oneJobRate.price
        cell.lblServiceName.text = oneJobRate.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        AppDelegate.shared().categoryID = allCategory[indexPath.row].id
//        AppDelegate.shared().categoryName = allCategory[indexPath.row].name
//
//
//        self.subcategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "subcategoryVC") as? SubCategoryVC
//        self.subcategoryVC.modalPresentationStyle = .fullScreen
//        self.present(self.subcategoryVC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableview: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            allJobRate.remove(at: indexPath.row)
            tableview.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    @IBAction func openHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
