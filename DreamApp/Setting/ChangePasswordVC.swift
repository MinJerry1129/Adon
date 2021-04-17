//
//  ChangePasswordVC.swift
//  DreamApp
//
//  Created by bird on 4/15/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import Toast_Swift
class ChangePasswordVC: UIViewController {

    @IBOutlet weak var cPasswordTxt: UITextField!
    @IBOutlet weak var newPasswordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onUpdatePasswordBtn(_ sender: Any) {
        
    }
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
