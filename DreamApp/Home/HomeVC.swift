//
//  ViewController.swift
//  DreamApp
//
//  Created by bird on 1/8/21.
//

import UIKit
import Alamofire
import SDWebImage
import JTMaterialSpinner
import Toast_Swift

class HomeVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var JobListCV: UICollectionView!
    
//    @IBOutlet weak var JobListTable: UITableView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    var subcategoryVC : SubCategoryVC!
    var personVC : PersonVC!
    var historyVC : HistoryVC!
    var favoriteVC : FavoriteVC!
    var chatVC : ChatVC!
    var settingVC : SettingVC!
    var loginhomeVC : LoginHomeVC!
    
    
    var spinnerView = JTMaterialSpinner()
    var allCategory = [Category]()
    var loginStatus = "no"
    var user_uid : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        JobListCV.delegate = self
        JobListCV.dataSource = self
        JobListCV.register(UINib(nibName: "JobListCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        getData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loginStatus = UserDefaults.standard.string(forKey: "loginstatus") ?? "no"
        if loginStatus == "no"{
            avatarView.isHidden = true
        }else{
            user_uid = UserDefaults.standard.string(forKey: "useruid")!
            AppDelegate.shared().loginStatus = loginStatus
            AppDelegate.shared().user_uid = user_uid
            getUserData()
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    func getUserData(){
        let parameters: Parameters = ["uid": user_uid!]
        AF.request(Global.baseUrl + "api/getuserdata", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            if let value = response.value as? [String: AnyObject] {
                let userinfo = value["userInfo"] as? [String: AnyObject]
                let avatarImage = userinfo!["avatar"] as! String
                self.imgAvatar.sd_setImage(with: URL(string: Global.baseUrl + avatarImage), completed: nil)
            }
            
        }
    }
    
    func getData(){
        allCategory = []
        //
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        AF.request(Global.baseUrl + "api/getHomeData", method: .post, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let categoryInfos = value["categorysInfo"] as? [[String: AnyObject]]
                if categoryInfos!.count > 0{
                    for i in 0 ... (categoryInfos!.count)-1 {
                        let id = categoryInfos![i]["id"] as! String
                        let name = categoryInfos![i]["name"] as! String
                        let url = categoryInfos![i]["url"] as! String                        
                        let categoryCell = Category(id: id, name: name, url: url)
                        self.allCategory.append(categoryCell)
                    }
                }
                self.JobListCV.reloadData()
            }
        }
    }
    
    
    @IBAction func onAvatarBtn(_ sender: Any) {
        if loginStatus == "no"{
            onGoLoginVC()
        }else{
            self.personVC = self.storyboard?.instantiateViewController(withIdentifier: "personVC") as? PersonVC
            self.personVC.modalPresentationStyle = .fullScreen
            self.present(self.personVC, animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let oneCategory: Category
        oneCategory =  allCategory[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "cell"), for: indexPath) as! JobListCell
        cell.imgJob.sd_setImage(with: URL(string: Global.baseUrl + oneCategory.url), completed: nil)
        cell.txtTitle.text = oneCategory.name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AppDelegate.shared().categoryID = allCategory[indexPath.row].id
        AppDelegate.shared().categoryName = allCategory[indexPath.row].name

        self.subcategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "subcategoryVC") as? SubCategoryVC
        self.subcategoryVC.modalPresentationStyle = .fullScreen
        self.present(self.subcategoryVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width-30) * 0.3, height: (collectionView.bounds.width - 20) * 0.35)
    }
    func onGoLoginVC(){
        self.loginhomeVC = self.storyboard?.instantiateViewController(withIdentifier: "loginhomeVC") as? LoginHomeVC
        self.loginhomeVC.modalPresentationStyle = .fullScreen
        self.present(self.loginhomeVC, animated: true, completion: nil)
    }
    @IBAction func onHistoryBtn(_ sender: Any) {
        if loginStatus == "no"{
            onGoLoginVC()
        }else{
            self.historyVC = self.storyboard?.instantiateViewController(withIdentifier: "historyVC") as? HistoryVC
            self.historyVC.modalPresentationStyle = .fullScreen
            self.present(self.historyVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func onFavoriteBtn(_ sender: Any) {
        if loginStatus == "no"{
            onGoLoginVC()
        }else{
            self.favoriteVC = self.storyboard?.instantiateViewController(withIdentifier: "favoriteVC") as? FavoriteVC
            self.favoriteVC.modalPresentationStyle = .fullScreen
            self.present(self.favoriteVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func onChatBtn(_ sender: Any) {
        if loginStatus == "no"{
            onGoLoginVC()
        }else{
            self.chatVC = self.storyboard?.instantiateViewController(withIdentifier: "chatVC") as? ChatVC
            self.chatVC.modalPresentationStyle = .fullScreen
            self.present(self.chatVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func onSettingBtn(_ sender: Any) {
        if loginStatus == "no"{
            onGoLoginVC()
        }else{
            self.settingVC = self.storyboard?.instantiateViewController(withIdentifier: "settingVC") as? SettingVC
            self.settingVC.modalPresentationStyle = .fullScreen
            self.present(self.settingVC, animated: true, completion: nil)
        }
    }
    
}
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

