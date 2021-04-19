//
//  SChatVC.swift
//  DreamApp
//
//  Created by bird on 4/17/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import SDWebImage
import Toast_Swift

class SChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var ssettingVC : SSettingVC!
    var shistoryVC : SHistoryVC!
    var personVC : PersonVC!
    var schatdetailVC : SChatDetailVC!
    
    var spinnerView = JTMaterialSpinner()
    
    @IBOutlet weak var chatListTB: UITableView!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    var loginStatus = "no"
    var user_uid : String!
    var allChatList = [Chat]()
    
    @IBOutlet weak var footerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chatListTB.isUserInteractionEnabled = false
        chatListTB.rowHeight = UITableView.automaticDimension
        chatListTB.delegate = self
        chatListTB.dataSource = self
        chatListTB.backgroundColor = UIColor(hexString: "E4DDD6")
        chatListTB.tableFooterView = UIView()
        chatListTB.register(UINib(nibName: "ChatListViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loginStatus = UserDefaults.standard.string(forKey: "loginstatus") ?? "no"
        user_uid = UserDefaults.standard.string(forKey: "useruid")!
        AppDelegate.shared().loginStatus = loginStatus
        AppDelegate.shared().user_uid = user_uid
        getUserData()
        getChatData()        
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
    func getChatData(){
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        let parameters: Parameters = ["uid": user_uid!]
        AF.request(Global.baseUrl + "api/getServicerChatList", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            self.spinnerView.endRefreshing()
            print(response)
            self.allChatList = []
            
            if let value = response.value as? [String: AnyObject] {
                let chatlist = value["chatlist"] as? [[String: AnyObject]]
                if chatlist!.count > 0{
                    for i in 0 ... (chatlist!.count)-1 {
                        let id = chatlist![i]["id"] as! String
                        let jobtitle = chatlist![i]["jobtitle"] as! String
                        let sendername = chatlist![i]["sendername"] as! String
                        let avatar = chatlist![i]["avatar"] as! String
                        let status = chatlist![i]["status"] as! String
                        let cuid = chatlist![i]["cuid"] as! String
                        let chatuid = chatlist![i]["chatuid"] as! String
//
                        let chatCell = Chat(id: id, jobtitle: jobtitle, avatar: avatar, sendername: sendername, status: status, suid: cuid, chatuid: chatuid)
                        self.allChatList.append(chatCell)
                    }
                }
            }
            self.chatListTB.isHidden = false
            self.chatListTB.reloadData()
            self.chatListTB.isUserInteractionEnabled = true
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allChatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatListViewCell
        cell.configure(chat: allChatList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.shared().clientuser_uid = allChatList[indexPath.row].suid
        AppDelegate.shared().chatid = allChatList[indexPath.row].id
        AppDelegate.shared().chat_uid = allChatList[indexPath.row].chatuid
        
        self.schatdetailVC = self.storyboard?.instantiateViewController(withIdentifier: "schatdetailVC") as? SChatDetailVC
        
        self.schatdetailVC.modalPresentationStyle = .fullScreen
        self.present(self.schatdetailVC, animated: true, completion: nil)
    }
    
    @IBAction func onAvatarBtn(_ sender: Any) {
        self.personVC = self.storyboard?.instantiateViewController(withIdentifier: "personVC") as? PersonVC
        self.personVC.modalPresentationStyle = .fullScreen
        self.present(self.personVC, animated: true, completion: nil)
    }
    @IBAction func onHistoryBtn(_ sender: Any) {
        self.shistoryVC = self.storyboard?.instantiateViewController(withIdentifier: "shistoryVC") as? SHistoryVC
        self.shistoryVC.modalPresentationStyle = .fullScreen
        self.present(self.shistoryVC, animated: true, completion: nil)
    }
    
    @IBAction func onSettingBtn(_ sender: Any) {
        self.ssettingVC = self.storyboard?.instantiateViewController(withIdentifier: "ssettingVC") as? SSettingVC
        self.ssettingVC.modalPresentationStyle = .fullScreen
        self.present(self.ssettingVC, animated: true, completion: nil)
    }
    
}
