//
//  SubCategoryVC.swift
//  DreamApp
//
//  Created by bird on 3/9/21.
//

import UIKit

class SubCategoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var txtJobTitle: UILabel!
    @IBOutlet weak var JobListTable: UITableView!
    
    var servicerlistVC : ServicerListVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        JobListTable.delegate = self
        JobListTable.dataSource = self
        JobListTable.register(UINib(nibName: "JobCategoryCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JobCategoryCell
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.servicerlistVC = self.storyboard?.instantiateViewController(withIdentifier: "servicerlistVC") as? ServicerListVC
        self.servicerlistVC.modalPresentationStyle = .fullScreen
        self.present(self.servicerlistVC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
