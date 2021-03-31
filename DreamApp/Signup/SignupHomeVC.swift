//
//  SignupHomeVC.swift
//  DreamApp
//
//  Created by bird on 3/2/21.
//

import UIKit

class SignupHomeVC: UIViewController {
    var signupemailVC : SignupEmailVC!
    var signupphoneVC : SignupPhoneVC!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBtnFacebook(_ sender: Any) {
    }
    
    @IBAction func onBtnGoogle(_ sender: Any) {
        
    }
    
    @IBAction func onBtnEmail(_ sender: Any) {
        self.signupemailVC = self.storyboard?.instantiateViewController(withIdentifier: "signupemailVC") as? SignupEmailVC
        self.signupemailVC.modalPresentationStyle = .fullScreen
        self.present(self.signupemailVC, animated: true, completion: nil)
    }
    
    @IBAction func onBtnPhone(_ sender: Any) {
        self.signupphoneVC = self.storyboard?.instantiateViewController(withIdentifier: "signupphoneVC") as? SignupPhoneVC
        self.signupphoneVC.modalPresentationStyle = .fullScreen
        self.present(self.signupphoneVC, animated: true, completion: nil)
    }
    
    @IBAction func onBtnSignin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
