//
//  FavoriteVC.swift
//  DreamApp
//
//  Created by bird on 3/14/21.
//

import UIKit

class FavoriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var favoriteTable: UITableView!
    
    
    var servicerVC : ServicerVC!
    var homeVC : HomeVC!
    var historyVC : HistoryVC!
    var chatVC : ChatVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTable.delegate = self
        favoriteTable.dataSource = self
        favoriteTable.register(UINib(nibName: "ServicerListCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServicerListCell
        cell.mainView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
