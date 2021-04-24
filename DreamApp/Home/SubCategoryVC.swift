//
//  SubCategoryVC.swift
//  DreamApp
//
//  Created by bird on 3/9/21.
//
import GoogleMobileAds
import UIKit
import Alamofire
import SDWebImage
import Toast_Swift
import JTMaterialSpinner
class SubCategoryVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var txtJobTitle: UILabel!
    @IBOutlet weak var JobListCV: UICollectionView!
    
    var servicerlistVC : ServicerListVC!
    
    var spinnerView = JTMaterialSpinner()
    var allServices = [Service]()
    private let banner : GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = Global.admobID
        banner.load(GADRequest())
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JobListCV.delegate = self
        JobListCV.dataSource = self
        JobListCV.register(UINib(nibName: "JobListCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        banner.rootViewController = self
        adsView.addSubview(banner)
        setReady()
        getData()        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: 0, y: 0, width: adsView.frame.size.width, height: adsView.frame.size.height)
        
    }
    func setReady(){
        txtJobTitle.text = AppDelegate.shared().categoryName        
    }
    func getData(){
        allServices = []
        //
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        let parameters: Parameters = ["id": AppDelegate.shared().categoryID!]
        AF.request(Global.baseUrl + "api/getServiceInfo", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let serviceInfos = value["serviceInfo"] as? [[String: AnyObject]]
                if serviceInfos!.count > 0{
                    for i in 0 ... (serviceInfos!.count)-1 {
                        let id = serviceInfos![i]["id"] as! String
                        let categoryid = serviceInfos![i]["categoryid"] as! String
                        let name = serviceInfos![i]["name"] as! String
                        let url = serviceInfos![i]["url"] as! String
                        
                        let serviceCell = Service(id: id, categoryid: categoryid, name: name, url: url)
                        self.allServices.append(serviceCell)
                    }
                }
                
                self.JobListCV.reloadData()
            }
        }
    }

    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let oneService: Service
        oneService =  allServices[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "cell"), for: indexPath) as! JobListCell
        cell.imgJob.sd_setImage(with: URL(string: Global.baseUrl + oneService.url), completed: nil)
        cell.txtTitle.text = oneService.name
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AppDelegate.shared().serviceID = allServices[indexPath.row].id
        AppDelegate.shared().serviceName = allServices[indexPath.row].name
        self.servicerlistVC = self.storyboard?.instantiateViewController(withIdentifier: "servicerlistVC") as? ServicerListVC
        self.servicerlistVC.modalPresentationStyle = .fullScreen
        self.present(self.servicerlistVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width-30) * 0.3, height: (collectionView.bounds.width - 20) * 0.35)
    }
    
}
