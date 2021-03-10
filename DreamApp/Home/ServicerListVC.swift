//
//  ServicerListVC.swift
//  DreamApp
//
//  Created by bird on 3/9/21.
//

import UIKit

class ServicerListVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var txtCategoryTitle: UILabel!
    @IBOutlet weak var ServicerListTable: UITableView!
    var servicermapVC : ServicerMapVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        ServicerListTable.delegate = self
        ServicerListTable.dataSource = self
        ServicerListTable.register(UINib(nibName: "ServicerListCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServicerListCell
        cell.mainView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    @IBAction func onMapBtn(_ sender: Any) {
        self.servicermapVC = self.storyboard?.instantiateViewController(withIdentifier: "servicermapVC") as? ServicerMapVC
        self.servicermapVC.modalPresentationStyle = .fullScreen
        self.present(self.servicermapVC, animated: true, completion: nil)
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
