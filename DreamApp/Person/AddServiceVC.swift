//
//  AddServiceVC.swift
//  DreamApp
//
//  Created by bird on 4/1/21.
//

import UIKit
import iOSDropDown
import Alamofire
import JTMaterialSpinner
import Toast_Swift
class AddServiceVC: UIViewController {

    @IBOutlet weak var iddCategory: DropDown!
    @IBOutlet weak var iddService: DropDown!
    @IBOutlet weak var txtHourlyRate: UITextField!
    
    var spinnerView = JTMaterialSpinner()
    
    var category : String!
    var service : String!
    var hourlyRate : String!
    var user_uid : String!
    var selServiceID = "no"
    var allCategory = [Category]()
    var allServices = [Service]()
    var categoryNames = [String]()
    var categoryIDS = [Int]()
    var serviceNames = [String]()
    var serviceIDS = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        user_uid = AppDelegate.shared().user_uid
    }
    func getData(){
        allServices = []
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        AF.request(Global.baseUrl + "api/getServiceData", method: .post, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let categoryInfos = value["categorysInfo"] as? [[String: AnyObject]]
                if categoryInfos!.count > 0{
                    for i in 0 ... (categoryInfos!.count)-1 {
                        let id = categoryInfos![i]["id"] as! String
                        let name = categoryInfos![i]["name"] as! String
                        let url = categoryInfos![i]["url"] as! String
                        self.categoryNames.append(name)
                        self.categoryIDS.append(Int(id) ?? 1)
                        let categoryCell = Category(id: id, name: name, url: url)
                        self.allCategory.append(categoryCell)
                    }
                }
                let serviceInfos = value["servicesInfo"] as? [[String: AnyObject]]
                if serviceInfos!.count > 0{
                    for i in 0 ... (serviceInfos!.count)-1 {
                        let id = serviceInfos![i]["id"] as! String
                        let categoryid = serviceInfos![i]["categoryid"] as! String
                        let name = serviceInfos![i]["name"] as! String
                        let url = serviceInfos![i]["url"] as! String
                        
                        let serviceCell = Service(id: id, categoryid: categoryid, name: name, url: url)
                        self.allServices.append(serviceCell)
                    }
                }
                self.setCategory()
            }
        }
    }
    func setCategory(){
        iddCategory.optionArray = categoryNames
        iddCategory.optionIds = categoryIDS
        iddCategory.didSelect{(selectedText , index ,id) in
            self.serviceNames = []
            self.serviceIDS = []
            for i in 0 ... self.allServices.count - 1 {
                if self.allServices[i].categoryid == "\(id)"{
                    self.serviceNames.append(self.allServices[i].name)
                    self.serviceIDS.append(Int(self.allServices[i].id) ?? 1)
                }
            }
            self.iddService.text = self.serviceNames[0]
            self.selServiceID = "\(self.serviceIDS[0])"
            self.setService()
            
        }
    }
    func setService(){
        iddService.optionArray = serviceNames
        iddService.optionIds = serviceIDS
        iddService.selectedIndex = 0
        iddService.didSelect{(selectedText , index ,id) in
            self.selServiceID = "\(id)"
            print(self.selServiceID)
        }
    }
    func validateData() -> Bool {
        if selServiceID == "no"{
            self.view.makeToast("Select the Service type")
            return false
        }
        if hourlyRate == ""{
            self.view.makeToast("Input Hourly Rate")
            return false
        }else{
            let phoneRegEx = "[1-9][0-9]"
            let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
            if !phonePred.evaluate(with: hourlyRate){
                self.view.makeToast("Input correct price")
                return false
            }
        }
        
        return true
    }
    
    @IBAction func onBtnAddservice(_ sender: Any) {
        hourlyRate = txtHourlyRate.text!
        if !validateData(){
            return
        }
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["uid": user_uid!, "jobid": selServiceID, "price": hourlyRate!]
        
        AF.request(Global.baseUrl + "api/addService", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let status = value["status"] as? String
                if status == "ok"{
                    self.view.makeToast("Add service success!")
//                    let alert = UIAlertController(title: "Signup Result", message: "Signup success, Please Login", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "O K", style: .default, handler: { _ in
//                        self.onHomePage()
//                    }))
//                    self.present(alert, animated: true, completion: nil)
                    
                }else if status == "exist" {
                    self.view.makeToast("You already set this service!")
                }else {
                    self.view.makeToast("Add Fail!")
                }
            }
        }
        
    }
    
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
