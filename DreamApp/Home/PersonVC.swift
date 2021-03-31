//
//  PersonVC.swift
//  DreamApp
//
//  Created by bird on 1/10/21.
//

import UIKit
import Firebase
class PersonVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignout(_ sender: Any) {
        try! Auth.auth().signOut()
        AppDelegate.shared().loginStatus = "no"
        UserDefaults.standard.set("no", forKey: "loginstatus")
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func openHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
