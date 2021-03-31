//
//  LoginEmailVC.swift
//  DreamApp
//
//  Created by bird on 3/2/21.
//

import UIKit
import Firebase
import Toast_Swift
import JTMaterialSpinner

class LoginEmailVC: UIViewController {
    var homeVC : HomeVC!

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var spinnerView = JTMaterialSpinner()
    
    var email : String!
    var password : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSigninBtn(_ sender: Any) {
        email = txtEmail.text!
        password = txtPassword.text!
        if !isValid(){
            return
        }
        signinfirebase()
        
    }
    func signinfirebase(){
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!){(authResult, error) in
            self.spinnerView.endRefreshing()
            if let authResult = authResult{
                let user = authResult.user
                print("User has signed in")
                AppDelegate.shared().user_uid = user.uid
                AppDelegate.shared().loginStatus = "yes"
                UserDefaults.standard.set(user.uid, forKey: "useruid")
                UserDefaults.standard.set("yes", forKey: "loginstatus")
                self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
                self.homeVC.modalPresentationStyle = .fullScreen
                self.present(self.homeVC, animated: true, completion: nil)
            }
            if let error = error{
                print("\(error)")
                self.view.makeToast("You are not registered.")
            }

        }
    }
    
    func isValid() -> Bool {
        if email == ""{
            self.view.makeToast("Input Email Address")
            return false
        }else{
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailPred.evaluate(with: email){
                self.view.makeToast("Input correct email address")
                return false
            }
        }
        if password == ""{
            self.view.makeToast("Input password")
            return false
        }
        return true
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
