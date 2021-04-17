//
//  SettingVC.swift
//  DreamApp
//
//  Created by bird on 4/8/21.
//

import UIKit

class SettingVC: UIViewController {
    var homeVC : HomeVC!
    var historyVC : HistoryVC!
    var favoriteVC : FavoriteVC!
    var chatVC : ChatVC!
    var changepasswordVC : ChangePasswordVC!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onChangePasswordBtn(_ sender: Any) {
        self.changepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "changepasswordVC") as? ChangePasswordVC
        self.changepasswordVC.modalPresentationStyle = .fullScreen
        self.present(self.changepasswordVC, animated: true, completion: nil)
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
    
    @IBAction func onChatBtn(_ sender: Any) {
        self.chatVC = self.storyboard?.instantiateViewController(withIdentifier: "chatVC") as? ChatVC
        self.chatVC.modalPresentationStyle = .fullScreen
        self.present(self.chatVC, animated: true, completion: nil)
    }
}
