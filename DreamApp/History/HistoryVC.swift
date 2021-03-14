//
//  HistoryVC.swift
//  DreamApp
//
//  Created by bird on 3/14/21.
//

import UIKit

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var goonBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var historyTB: UITableView!
    
    var homeVC : HomeVC!
    var favoriteVC : FavoriteVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTB.delegate = self
        historyTB.dataSource = self
        historyTB.register(UINib(nibName: "ReviewListCell", bundle: nil), forCellReuseIdentifier: "cell")
        historyTB.register(UINib(nibName: "HistoryGoListCell", bundle: nil), forCellReuseIdentifier: "cellgo")
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row % 2 == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReviewListCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellgo", for: indexPath) as! HistoryGoListCell
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.subcategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "subcategoryVC") as? SubCategoryVC
//        self.subcategoryVC.modalPresentationStyle = .fullScreen
//        self.present(self.subcategoryVC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row % 2 == 0){
            return 150
        }else{
            return 100
        }
    }
    
    @IBAction func onHomeBtn(_ sender: Any) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.homeVC.modalPresentationStyle = .fullScreen
        self.present(self.homeVC, animated: true, completion: nil)
    }
    
    @IBAction func onFavoriteBtn(_ sender: Any) {
        self.favoriteVC = self.storyboard?.instantiateViewController(withIdentifier: "favoriteVC") as? FavoriteVC
        self.favoriteVC.modalPresentationStyle = .fullScreen
        self.present(self.favoriteVC, animated: true, completion: nil)
    }
    
}
