//
//  SignupEmailVC.swift
//  DreamApp
//
//  Created by bird on 3/2/21.
//

import UIKit
import Toast_Swift

class SignupEmailVC: UIViewController {
    var signupinfoVC : SignupInfoVC!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func onsingupinfo(){
//        let user = Auth.auth().currentUser
//        var user_uuid = user?.uid
//        print(user_uuid)
    }

    @IBAction func onBtnSignin(_ sender: Any) {
        if !isValid(){
            return
        }
        print("valide")
        
//        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { authResult, error in
//            if error != nil{
//                print("\(error)")
//                print("error")
//                return
//            }
//            print("created")
//            self.signin()
//        }
    }
    func isValid() -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//
//        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return true
    }
    
    func signin(){
//        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!){(authResult, error) in
//            if let authResult = authResult{
//                let user = authResult.user
//                print("User has signed in")
//                self.onsingupinfo()
////                if user.isEmailVerified{
////                    print("verified")test123
////                }else{
////                    user.sendEmailVerification{(error) in
////                        if error != nil{
////                            print("\(error)")
////                            print("error verify")
////                        }else{
////                            print("user email verification sent")
////                        }
////                    }
////                    print("not verified")
////                }
//            }
//            if let error = error{
//                print("\(error)")
//                print("Can't sign in user")
//            }
//
//        }
    }
    
    @IBAction func onBtnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
