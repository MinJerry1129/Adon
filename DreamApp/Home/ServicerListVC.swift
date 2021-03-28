//
//  ServicerListVC.swift
//  DreamApp
//
//  Created by bird on 3/9/21.
//
import GoogleMobileAds
import UIKit

class ServicerListVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var txtCategoryTitle: UILabel!
    @IBOutlet weak var ServicerListTable: UITableView!
    var servicermapVC : ServicerMapVC!
    var servicerVC: ServicerVC!
    @IBOutlet weak var adsView: UIView!
    private let banner : GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-8064612229280440/6686469025"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        ServicerListTable.delegate = self
        ServicerListTable.dataSource = self
        ServicerListTable.register(UINib(nibName: "ServicerListCell", bundle: nil), forCellReuseIdentifier: "cell")
        banner.rootViewController = self
        adsView.addSubview(banner)
        setReady()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: 0, y: 0, width: adsView.frame.size.width, height: adsView.frame.height)
    }
    func setReady(){
        txtCategoryTitle.text = AppDelegate.shared().serviceName
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServicerListCell
        cell.mainView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.servicerVC = self.storyboard?.instantiateViewController(withIdentifier: "servicerVC") as? ServicerVC
        self.servicerVC.modalPresentationStyle = .fullScreen
        self.present(self.servicerVC, animated: true, completion: nil)
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
