//
//  ViewController.swift
//  DreamApp
//
//  Created by bird on 1/8/21.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var JobListTable: UITableView!
    @IBOutlet weak var avatarView: UIView!
    
    var subcategoryVC : SubCategoryVC!
    var personVC : PersonVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JobListTable.delegate = self
        JobListTable.dataSource = self
        JobListTable.register(UINib(nibName: "JobCategoryCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    @IBAction func onAvatarBtn(_ sender: Any) {
        self.personVC = self.storyboard?.instantiateViewController(withIdentifier: "personVC") as? PersonVC
        self.personVC.modalPresentationStyle = .fullScreen
        self.present(self.personVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JobCategoryCell
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.subcategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "subcategoryVC") as? SubCategoryVC
        self.subcategoryVC.modalPresentationStyle = .fullScreen
        self.present(self.subcategoryVC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

