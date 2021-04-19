//
//  SHistoryVC.swift
//  DreamApp
//
//  Created by bird on 4/17/21.
//

import UIKit

class SHistoryVC: UIViewController {

    @IBOutlet weak var footerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
}
