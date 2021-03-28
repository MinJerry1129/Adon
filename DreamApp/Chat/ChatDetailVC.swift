//
//  ChatDetailVC.swift
//  DreamApp
//
//  Created by bird on 3/25/21.
//

import UIKit

class ChatDetailVC: UIViewController {

    @IBOutlet weak var chatTB: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        fetchData()
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
        
        
    }
    
    func fetchData() {
        chatTB.reloadData()
        chatTB.scrollToBottom()        
    }
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension ChatDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let message = messages[indexPath.row]
        if indexPath.row % 2 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftViewCell") as! LeftViewCell
//            cell.configureCell(message: message)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightViewCell") as! RightViewCell
//            cell.configureCell(message: message)
            return cell
        }
    }
    
}

