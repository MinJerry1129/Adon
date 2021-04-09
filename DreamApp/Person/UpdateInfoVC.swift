//
//  UpdateInfoVC.swift
//  DreamApp
//
//  Created by bird on 4/8/21.
//

import UIKit
import Alamofire
import SDWebImage
import JTMaterialSpinner
import Toast_Swift
import GooglePlaces

class UpdateInfoVC: UIViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var txtInfo: UITextView!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    
    var spinnerView = JTMaterialSpinner()
    var imagePicker = UIImagePickerController()
    var avatarImage : UIImage!
    
    var user_uid : String!
    var verify_status : String!
    var firstname : String!
    var lastname : String!
    var location : String!
    var latitude : String!
    var longitude : String!
    var info : String!
    var avatarImg : String!
    var imgsel = "no"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_uid = AppDelegate.shared().user_uid
        let imageTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.selClinicImg))
        imgAvatar.isUserInteractionEnabled = true
        imgAvatar.addGestureRecognizer(imageTapGesture)
        getUserData()
    }
    func getUserData(){
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["uid": user_uid!]
        AF.request(Global.baseUrl + "api/getuserdata", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let userinfo = value["userInfo"] as? [String: AnyObject]
                self.avatarImg = userinfo!["avatar"] as? String
                self.firstname = userinfo!["firstname"] as? String
                self.lastname = userinfo!["lastname"] as? String
                self.location = userinfo!["location"] as? String
                self.latitude = userinfo!["latitude"] as? String
                self.longitude = userinfo!["longitude"] as? String
                self.info = userinfo!["information"] as? String
                self.verify_status = userinfo!["status"] as? String
                self.setReady()
            }
        }
    }
    func setReady(){
        self.imgAvatar.sd_setImage(with: URL(string: Global.baseUrl + avatarImg), completed: nil)
        txtFirstname.text = firstname
        txtLastname.text = lastname
        txtInfo.text = info
        txtLocation.text = location
    }
    
    @objc func selClinicImg(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                    self.openCamera()
                }))
                
                alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
                    self.openGallary()
                }))
                
                alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                
                //If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash in iPad
                
                self.present(alert, animated: true, completion: nil)
        
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func isValid() -> Bool {
        if firstname == ""{
            self.view.makeToast("Input First name")
            return false
        }
        if lastname == ""{
            self.view.makeToast("Input Second name")
            return false
        }
        if location == ""{
            self.view.makeToast("Input Location")
            return false
        }
        
        return true
    }
    
    @IBAction func onLocationSet(_ sender: Any) {
        txtLocation.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func onBtnUpdate(_ sender: Any) {
        firstname = txtFirstname.text!
        lastname = txtLastname.text!
        location = txtLocation.text!
        info = txtInfo.text!
        if !isValid(){
            return
        }
        spinnerView.beginRefreshing()
        var strBase64 = ""
        if imgsel == "yes"{
            let data = avatarImage.jpegData(compressionQuality: 0.6)
            strBase64 = data!.base64EncodedString(options: .lineLength64Characters)
        }
        let parameters: Parameters = ["uid": user_uid!, "firstname": firstname!, "lastname": lastname!, "location": location!,"latitude": latitude!, "longitude": longitude!,  "info": info!,"isChange": imgsel, "avatar": strBase64]
        AF.request(Global.baseUrl + "api/updateUserinfo", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                self.view.makeToast("Update Success!")
            }
        }
        
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension UpdateInfoVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            print(editedImage)
            avatarImage = editedImage
            imgsel = "yes"
            self.imgAvatar.image = editedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
extension UpdateInfoVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    // Get the place name from 'GMSAutocompleteViewController'
    // Then display the name in textField
        txtLocation.text = place.formattedAddress
        latitude = "\(place.coordinate.latitude)"
        longitude = "\(place.coordinate.longitude)"
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}
