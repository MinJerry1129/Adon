//
//  SSettingVC.swift
//  DreamApp
//
//  Created by bird on 4/17/21.
//

import UIKit

class SSettingVC: UIViewController {
    var schatVC : SChatVC!
    var shistoryVC : SHistoryVC!
    var homeVC : HomeVC!
    var changepasswordVC : ChangePasswordVC!
    
    
    @IBOutlet weak var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    @IBAction func onClientModeBtn(_ sender: Any) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.homeVC.modalPresentationStyle = .fullScreen
        self.present(self.homeVC, animated: true, completion: nil)
    }
    
    @IBAction func onChangePasswordBtn(_ sender: Any) {
        self.changepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "changepasswordVC") as? ChangePasswordVC
        self.changepasswordVC.modalPresentationStyle = .fullScreen
        self.present(self.changepasswordVC, animated: true, completion: nil)
    }
    
    @IBAction func onHistoryBtn(_ sender: Any) {
        self.shistoryVC = self.storyboard?.instantiateViewController(withIdentifier: "shistoryVC") as? SHistoryVC
        self.shistoryVC.modalPresentationStyle = .fullScreen
        self.present(self.shistoryVC, animated: true, completion: nil)
        
    }
    @IBAction func onChatBtn(_ sender: Any) {
        self.schatVC = self.storyboard?.instantiateViewController(withIdentifier: "schatVC") as? SChatVC
        self.schatVC.modalPresentationStyle = .fullScreen
        self.present(self.schatVC, animated: true, completion: nil)
    }
}
