//
//  SignupEmailVC.swift
//  DreamApp
//
//  Created by bird on 3/2/21.
//

import UIKit
import Toast_Swift
import Firebase
import Alamofire
import JTMaterialSpinner
class SignupEmailVC: UIViewController {
    var signupinfoVC : SignupInfoVC!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var spinnerView = JTMaterialSpinner()
    
    var email : String!
    var password : String!
    var user_uid : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func onsingupinfo(){
//        let user = Auth.auth().currentUser
//        var user_uuid = user?.uid
//        print(user_uuid)
    }

    @IBAction func onBtnSignin(_ sender: Any) {
        email = txtEmail.text!
        password = txtPassword.text!
        if !isValid(){
            return
        }
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["email": email!]
        AF.request(Global.baseUrl + "api/checkexistemail", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let status = value["status"] as? String
                if status == "no"{
                    self.createuser()
                }else {
                    self.view.makeToast("This email already exist.")
                }
            }
        }
    }
    func createuser(){
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { authResult, error in
            if error != nil{
                self.view.makeToast("Check email and password")
                return
            }
            print("created")
            self.signinfirebase()
        }
    }
    
    func signinfirebase(){
        
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!){(authResult, error) in
            if let authResult = authResult{
                let user = authResult.user
                print("User has signed in")
                self.user_uid = user.uid
                self.signindatabase()
            }
            if let error = error{
                print("\(error)")
                print("Can't sign in user")
            }

        }
    }
    func signindatabase(){
        let parameters: Parameters = ["email": email!,"password": password!, "uid": user_uid!]
        AF.request(Global.baseUrl + "api/signupemail", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let status = value["status"] as? String
                if status == "ok"{
                    try! Auth.auth().signOut()
                    
                    AppDelegate.shared().user_uid = self.user_uid
                    self.signupinfoVC = self.storyboard?.instantiateViewController(withIdentifier: "signupinfoVC") as? SignupInfoVC
                    self.signupinfoVC.modalPresentationStyle = .fullScreen
                    self.present(self.signupinfoVC, animated: true, completion: nil)
                }else {
                    self.view.makeToast("Fail signup")
                }
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
        }else{
            if password.count < 8{
                self.view.makeToast("Input password more than 8 characters")
                return false
            }
        }
        return true
    }
    
    @IBAction func onBtnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
