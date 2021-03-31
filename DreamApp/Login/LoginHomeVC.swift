//
//  LoginHomeVC.swift
//  DreamApp
//
//  Created by bird on 3/2/21.
//

import UIKit

class LoginHomeVC: UIViewController {
    var signuphomeVC : SignupHomeVC!
    var loginemailVC : LoginEmailVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onBtnFaceBook(_ sender: Any) {
    }
    
    @IBAction func onBtnGoogle(_ sender: Any) {
        
    }
    
    @IBAction func onBtnEmail(_ sender: Any) {
        self.loginemailVC = self.storyboard?.instantiateViewController(withIdentifier: "loginemailVC") as? LoginEmailVC
        self.loginemailVC.modalPresentationStyle = .fullScreen
        self.present(self.loginemailVC, animated: true, completion: nil)
        
    }
    
    @IBAction func onBtnSignUp(_ sender: Any) {
        
        self.signuphomeVC = self.storyboard?.instantiateViewController(withIdentifier: "signuphomeVC") as? SignupHomeVC
        self.signuphomeVC.modalPresentationStyle = .fullScreen
        self.present(self.signuphomeVC, animated: true, completion: nil)
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
