//
//  ChatVC.swift
//  DreamApp
//
//  Created by bird on 3/14/21.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var chatListTB: UITableView!
    
    var chatdetailVC : ChatDetailVC!
    
    var homeVC : HomeVC!
    var historyVC : HistoryVC!
    var favoriteVC : FavoriteVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatListTB.rowHeight = UITableView.automaticDimension
        chatListTB.delegate = self
        chatListTB.dataSource = self
        chatListTB.backgroundColor = UIColor(hexString: "E4DDD6")
        chatListTB.tableFooterView = UIView()
       
        chatListTB.register(UINib(nibName: "ChatListViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatListViewCell
//        cell.mainView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
}
