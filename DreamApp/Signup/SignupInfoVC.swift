//
//  SignupInfoVC.swift
//  DreamApp
//
//  Created by bird on 3/2/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import Toast_Swift
import GooglePlaces
class SignupInfoVC: UIViewController {
    var loginhomeVC : LoginHomeVC!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtInfo: UITextView!
    
    var spinnerView = JTMaterialSpinner()
    var imagePicker = UIImagePickerController()
    var avatarImage : UIImage!
    
    var user_uid : String!
    var firstname : String!
    var lastname : String!
    var phone : String!
    var location : String!
    var info : String!
    var latitude : String!
    var longitude : String!
    var imgsel = "no"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_uid = AppDelegate.shared().user_uid
        let imageTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.selClinicImg))
        imgAvatar.isUserInteractionEnabled = true
        imgAvatar.addGestureRecognizer(imageTapGesture)
        
    }
    
    @IBAction func onLocationSet(_ sender: Any) {
        txtLocation.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
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
    
    @IBAction func onSignupBtn(_ sender: Any) {
        firstname = txtFirstname.text!
        lastname = txtLastname.text!
        phone = txtPhone.text!
        location = txtLocation.text!
        info = txtInfo.text!
        if !isValid(){
            return
        }
        let data = avatarImage.jpegData(compressionQuality: 0.8)
        let strBase64 = data!.base64EncodedString(options: .lineLength64Characters)
        
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        let parameters: Parameters = ["uid": user_uid!, "firstname": firstname!, "lastname": lastname!, "phone": phone!, "location": location!, "latitude": latitude! , "longitude": longitude!, "info": info!, "avatar" : strBase64]
        
        AF.request(Global.baseUrl + "api/updateinfouser", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let status = value["status"] as? String
                if status == "ok"{
                    let alert = UIAlertController(title: "Signup Result", message: "Signup success, Please Login", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "O K", style: .default, handler: { _ in
                        self.onHomePage()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }else {
                    self.view.makeToast("Signup Fail")
                }
            }
        }
    }
    func onHomePage(){
        self.loginhomeVC = self.storyboard?.instantiateViewController(withIdentifier: "loginhomeVC") as? LoginHomeVC
        self.loginhomeVC.modalPresentationStyle = .fullScreen
        self.present(self.loginhomeVC, animated: true, completion: nil)
    }
    
    func isValid() -> Bool {
        if imgsel == "no"{
            self.view.makeToast("Select Avatar image")
            return false
        }
        if firstname == ""{
            self.view.makeToast("Input First name")
            return false
        }
        if lastname == ""{
            self.view.makeToast("Input Second name")
            return false
        }
        if phone == ""{
            self.view.makeToast("Input phonenumber")
            return false
        }else{
            let phoneRegEx = "[+]+[0-9]{10,17}"
            let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
            if !phonePred.evaluate(with: phone){
                self.view.makeToast("Input correct phonenumber")
                return false
            }
        }
        if location == ""{
            self.view.makeToast("Input Location")
            return false
        }
        
        return true
    }
}
extension SignupInfoVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
        imgsel = "no"
        self.dismiss(animated: true, completion: nil)
    }
}

extension SignupInfoVC: GMSAutocompleteViewControllerDelegate {
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
