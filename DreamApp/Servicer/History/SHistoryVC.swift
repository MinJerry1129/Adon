//
//  SHistoryVC.swift
//  DreamApp
//
//  Created by bird on 4/17/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import SDWebImage
import Toast_Swift

class SHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var schatVC : SChatVC!
    var ssettingVC : SSettingVC!
    @IBOutlet weak var historyTB: UITableView!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var goonBtn: UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    
    
    var spinnerView = JTMaterialSpinner()
    var allReviews = [Review]()
    var completeReviews = [Review]()
    var ongoingReviews = [Review]()
    var sel_type = 0
    
    var user_uid : String!

    @IBOutlet weak var footerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTB.delegate = self
        historyTB.dataSource = self
        historyTB.register(UINib(nibName: "ReviewListCell", bundle: nil), forCellReuseIdentifier: "cell")
        historyTB.register(UINib(nibName: "HistoryGoListCell", bundle: nil), forCellReuseIdentifier: "cellgo")
        historyTB.isUserInteractionEnabled = false
        user_uid = AppDelegate.shared().user_uid
        getData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    func getData(){
        //
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        let parameters: Parameters = ["suid" : user_uid]
        AF.request(Global.baseUrl + "api/getServicerReviewInfo", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                self.allReviews = []
                self.completeReviews = []
                self.ongoingReviews = []
                
                self.historyTB.isUserInteractionEnabled = true
                let reviewInfo = value["reviewInfo"] as? [[String: AnyObject]]
                
                if reviewInfo!.count > 0{
                    for i in 0 ... (reviewInfo!.count)-1 {
                        let id = reviewInfo![i]["id"] as! String
                        let cuid = reviewInfo![i]["cuid"] as! String
                        let suid = reviewInfo![i]["suid"] as! String
                        let jobid = reviewInfo![i]["jobid"] as! String
                        let firstname = reviewInfo![i]["firstname"] as! String
                        let lastname = reviewInfo![i]["lastname"] as! String
                        let review = reviewInfo![i]["review"] as! String
                        let avatar = reviewInfo![i]["avatar"] as! String
                        let rmark = reviewInfo![i]["mark"] as! String
                        let rdate = reviewInfo![i]["date"] as! String
                        let status = reviewInfo![i]["rstatus"] as! String
                        

                        let reviewCell = Review(id: id, cuid: cuid, suid: suid, jobid: jobid, firstname: firstname, lastname: lastname, rdate: rdate, avatar: avatar, rmark: rmark, review: review,status: status)
                        if status == "complete"{
                            self.completeReviews.append(reviewCell)
                        }else{
                            self.ongoingReviews.append(reviewCell)
                        }
                        self.allReviews.append(reviewCell)
                    }
                }
                self.historyTB.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sel_type == 0 {
            return allReviews.count
        }else if sel_type == 1{
            return completeReviews.count
        }else{
            return ongoingReviews.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var oneReview : Review!
        if sel_type == 0{
            oneReview = allReviews[indexPath.row]
        }else if sel_type == 1{
            oneReview = completeReviews [indexPath.row]
        }else {
            oneReview = ongoingReviews[indexPath.row]
        }
        
        if(oneReview.status == "complete"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReviewListCell
            cell.mainView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.userImg.sd_setImage(with: URL(string: Global.baseUrl + oneReview.avatar), completed: nil)
            cell.nameTxt.text = oneReview.firstname + " " + oneReview.lastname
            cell.dateTxt.text = oneReview.rdate
            cell.reviewRating.rating = Double(oneReview.rmark) ?? 0.0
            cell.reviewRating.text = oneReview.rmark
            cell.reviewTxt.text = oneReview.review
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellgo", for: indexPath) as! HistoryGoListCell
            cell.mainView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.userImg.sd_setImage(with: URL(string: Global.baseUrl + oneReview.avatar), completed: nil)
            cell.nameTxt.text = oneReview.firstname + " " + oneReview.lastname
            cell.dateTxt.text = oneReview.rdate
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.subcategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "subcategoryVC") as? SubCategoryVC
//        self.subcategoryVC.modalPresentationStyle = .fullScreen
//        self.present(self.subcategoryVC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(allReviews[indexPath.row].status == "complete"){
            let height = self.getRowHeightFromText(strText: allReviews[indexPath.row].review)
            return height
        }else{
            return 100
        }
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
    @IBAction func onBtnAll(_ sender: Any) {
        sel_type = 0
        allBtn.backgroundColor = UIColor(named: "MajorColor")
        goonBtn.backgroundColor = UIColor(named: "lightMajor")
        completeBtn.backgroundColor = UIColor(named: "lightMajor")
        historyTB.reloadData()
    }
    
    @IBAction func onBtnOngoing(_ sender: Any) {
        sel_type = 2
        allBtn.backgroundColor = UIColor(named: "lightMajor")
        goonBtn.backgroundColor = UIColor(named: "MajorColor")
        completeBtn.backgroundColor = UIColor(named: "lightMajor")
        historyTB.reloadData()
    }
    @IBAction func onBtnComplete(_ sender: Any) {
        sel_type = 1
        allBtn.backgroundColor = UIColor(named: "lightMajor")
        goonBtn.backgroundColor = UIColor(named: "lightMajor")
        completeBtn.backgroundColor = UIColor(named: "MajorColor")
        historyTB.reloadData()
    }
    @IBAction func onChatBtn(_ sender: Any) {
        self.schatVC = self.storyboard?.instantiateViewController(withIdentifier: "schatVC") as? SChatVC
        self.schatVC.modalPresentationStyle = .fullScreen
        self.present(self.schatVC, animated: true, completion: nil)
    }
    
    @IBAction func onSettingBtn(_ sender: Any) {
        self.ssettingVC = self.storyboard?.instantiateViewController(withIdentifier: "ssettingVC") as? SSettingVC
        self.ssettingVC.modalPresentationStyle = .fullScreen
        self.present(self.ssettingVC, animated: true, completion: nil)
    }
}
