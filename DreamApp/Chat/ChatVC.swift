//
//  ChatVC.swift
//  DreamApp
//
//  Created by bird on 3/14/21.
//

import UIKit
import Alamofire
import SDWebImage
import JTMaterialSpinner
import Toast_Swift

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var chatListTB: UITableView!
    var spinnerView = JTMaterialSpinner()
    
    var chatdetailVC : ChatDetailVC!
    var homeVC : HomeVC!
    var historyVC : HistoryVC!
    var favoriteVC : FavoriteVC!
    var settingVC : SettingVC!
    
    var allChatList = [Chat]()
    var user_uid : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatListTB.isUserInteractionEnabled = false
        chatListTB.rowHeight = UITableView.automaticDimension
        chatListTB.delegate = self
        chatListTB.dataSource = self
        chatListTB.backgroundColor = UIColor(hexString: "E4DDD6")
        chatListTB.tableFooterView = UIView()
        chatListTB.register(UINib(nibName: "ChatListViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        user_uid = AppDelegate.shared().user_uid
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        chatListTB.isHidden = true
        getUserData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    func getUserData(){
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        let parameters: Parameters = ["uid": user_uid!]
        AF.request(Global.baseUrl + "api/getClientChatList", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
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
                        let suid = chatlist![i]["suid"] as! String
                        let chatuid = chatlist![i]["chatuid"] as! String
//                        
                        let chatCell = Chat(id: id, jobtitle: jobtitle, avatar: avatar, sendername: sendername, status: status, suid: suid, chatuid: chatuid)
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
        AppDelegate.shared().seluser_uid = allChatList[indexPath.row].suid
        AppDelegate.shared().chatid = allChatList[indexPath.row].id
        AppDelegate.shared().chat_uid = allChatList[indexPath.row].chatuid
        
        self.chatdetailVC = self.storyboard?.instantiateViewController(withIdentifier: "chatdetailVC") as? ChatDetailVC
        self.chatdetailVC.modalPresentationStyle = .fullScreen
        self.present(self.chatdetailVC, animated: true, completion: nil)
    }
    
    @IBAction func onHistoryBtn(_ sender: Any) {
        self.historyVC = self.storyboard?.instantiateViewController(withIdentifier: "historyVC") as? HistoryVC
        self.historyVC.modalPresentationStyle = .fullScreen
        self.present(self.historyVC, animated: true, completion: nil)
    }
    
    @IBAction func onFavoriteBtn(_ sender: Any) {
        self.favoriteVC = self.storyboard?.instantiateViewController(withIdentifier: "favoriteVC") as? FavoriteVC
        self.favoriteVC.modalPresentationStyle = .fullScreen
        self.present(self.favoriteVC, animated: true, completion: nil)
    }
    @IBAction func onHomeBtn(_ sender: Any) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.homeVC.modalPresentationStyle = .fullScreen
        self.present(self.homeVC, animated: true, completion: nil)
    }
    
    @IBAction func onSettingBtn(_ sender: Any) {
        self.settingVC = self.storyboard?.instantiateViewController(withIdentifier: "settingVC") as? SettingVC
        self.settingVC.modalPresentationStyle = .fullScreen
        self.present(self.settingVC, animated: true, completion: nil)
    }
}
