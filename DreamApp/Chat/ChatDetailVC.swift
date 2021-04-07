//
//  ChatDetailVC.swift
//  DreamApp
//
//  Created by bird on 3/25/21.
//

import UIKit
import Alamofire
import SDWebImage
import JTMaterialSpinner
import Toast_Swift
import Firebase


class ChatDetailVC: UIViewController {

    @IBOutlet weak var chatTB: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    
    var chat_uid : String!
    var user_uid : String!
    var s_uid : String!
    var chat_id : String!
    
    var allMsg = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_uid = AppDelegate.shared().user_uid
        s_uid = AppDelegate.shared().seluser_uid
        chat_uid = AppDelegate.shared().chat_uid
        chat_id = AppDelegate.shared().chatid
        
        setupTable()
    }
    
    override func viewDidLayoutSubviews() {
//        chatTB.scrollToBottom()
    }
    
    func setupTable() {
        // config tableView
        chatTB.rowHeight = UITableView.automaticDimension
        chatTB.dataSource = self
        chatTB.backgroundColor = UIColor(hexString: "E4DDD6")
        chatTB.tableFooterView = UIView()
        // cell setup
        chatTB.register(UINib(nibName: "RightViewCell", bundle: nil), forCellReuseIdentifier: "RightViewCell")
        chatTB.register(UINib(nibName: "LeftViewCell", bundle: nil), forCellReuseIdentifier: "LeftViewCell")
        fetchData()
    }
    
    func fetchData() {
        let database = Database.database().reference()
        database.child("chat").child(user_uid).child(chat_uid).child(s_uid).observe(.childAdded) { (snapshot) in
            
            database.child("chat").child(self.user_uid).child(self.chat_uid).updateChildValues(["status" : "no"])
            
            print("\(snapshot)")
            guard let value = snapshot.value as? [String: Any] else{
                return
            }
            let onemsg : Message!
            let mdate = value["date"] as! Int
            let msg_date = self.intToDate(datevalue: mdate)
            let msg = value["message"] as! String
            let status = value["status"] as! String
            
            if status == "send"{
                onemsg = Message(text: msg, date: msg_date, side: .send)
            }else{
                onemsg = Message(text: msg, date: msg_date, side: .receive)
            }
            
            self.allMsg.append(onemsg)
            self.chatTB.reloadData()
            self.chatTB.scrollToBottom()
            
        }
    }
    
    func intToDate(datevalue : Int) -> String {
        let exactDate = NSDate.init(timeIntervalSince1970: TimeInterval(datevalue))
        let dateFormatt = DateFormatter();
        dateFormatt.dateFormat = "yyyy-MM-dd hh:mm"
        let formattedString = dateFormatt.string(from: exactDate as Date)
        return formattedString
    }
    func getCurrentTimeStamp() -> Int {
            return Int(NSDate().timeIntervalSince1970)
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.allMsg.count - 1, section: 0)
            self.chatTB.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func onSentMsg(_ sender: Any) {
        if (txtMessage.text == "" || txtMessage.text == " ") {
            let alert = UIAlertController(title: "Alert", message: "Please type a Message", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let database = Database.database().reference()
            let time_interval = getCurrentTimeStamp()
            database.child("chat").child(user_uid).child(chat_uid).child(s_uid).child("\(time_interval)").updateChildValues(["message" : txtMessage.text!, "status" : "send" , "date" : time_interval])
            
            database.child("chat").child(s_uid).child(chat_uid).child(user_uid).child("\(time_interval)").updateChildValues(["message" : txtMessage.text!, "status" : "send" , "date" : time_interval])
            
            database.child("chat").child(s_uid).child(chat_uid).updateChildValues(["status" : "yes"])
            self.chatTB.reloadData()
            txtMessage.text = ""
        }
    }
    @IBAction func onAccept(_ sender: Any) {
//        chatTB.scrollToBottom()
    }
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension ChatDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMsg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = allMsg[indexPath.row]
        if message.side == .receive {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftViewCell") as! LeftViewCell
            cell.configureCell(message: message)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightViewCell") as! RightViewCell
            cell.configureCell(message: message)
            return cell
        }
    }
    
}

