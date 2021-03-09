//
//  ViewController.swift
//  DreamApp
//
//  Created by bird on 1/8/21.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgNotification: UIImageView!
    let formatter = DateFormatter()
    var personVC : PersonVC!
    let datePicker = UIDatePicker()
    let datePicker1 = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        createDatePicker()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    @IBAction func openPersonInfo(_ sender: Any) {
        self.personVC = self.storyboard?.instantiateViewController(withIdentifier: "personVC") as? PersonVC
        self.personVC.modalPresentationStyle = .fullScreen
        self.present(self.personVC, animated: true, completion: nil)
    }
    func createDatePicker(){
        txtStartDate.text = formatter.string(from: Date())
        txtEndDate.text = formatter.string(from: Date())
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        txtStartDate.inputAccessoryView = toolbar
        txtStartDate.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        
        let toolbar1 = UIToolbar()
        toolbar1.sizeToFit()
        let doneBtn1 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed1))
        toolbar1.setItems([doneBtn1], animated: true)
        txtEndDate.inputAccessoryView = toolbar1
        txtEndDate.inputView = datePicker1
        datePicker1.datePickerMode = .date
        datePicker.minimumDate = Date()
        
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        txtStartDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func donePressed1(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        txtEndDate.text = formatter.string(from: datePicker1.date)
        self.view.endEditing(true)
    }
}
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "cell"), for: indexPath) as! HouseCell
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height * 0.9, height: collectionView.bounds.height * 0.9)
//        return CGSize(width:50, height:50)
    }
}

