//
//  ChatVC.swift
//  DreamApp
//
//  Created by bird on 3/14/21.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var chatListTB: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//        cell.mainView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.servicerVC = self.storyboard?.instantiateViewController(withIdentifier: "servicerVC") as? ServicerVC
//        self.servicerVC.modalPresentationStyle = .fullScreen
//        self.present(self.servicerVC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    

}
