//
//  sellVC.swift
//  WishForSale
//
//  Created by Ehtisham Khalid on 26/11/2020.
//

import UIKit
import Firebase
import FirebaseStorage
import CoreLocation

class sellVC: UIViewController, CLLocationManagerDelegate {
    
    //MARK:- Properties.
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    //MARK:- Variables.
    var progressBar = ProgressHUD(text: "Please wait...")
    var ref: DatabaseReference!
    let locationManager = CLLocationManager()
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupViews()
    }
    
    //MARK:- Functions.
    private func setupViews(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(SelectImageBtnTapped))
        selectImageView.addGestureRecognizer(tap)
        selectImageView.isUserInteractionEnabled = true
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    private func saveDataIntoDatabase(imageUrl: String,productId: String){
        let uid = Auth.auth().currentUser?.uid ?? ""
        let dict : [String: Any] = [
            "title": "\(titleTextField.text!)",
            "Brand": brandTextField.text!,
            "size":sizeTextField.text!,
            "price":priceTextField.text!,
            "currency":currencyTextField.text!,
            "location":locationTextField.text!,
            "details":detailsTextField.text!,
            "imageUrl":imageUrl,
            "productId":productId,
            "userID":uid
        ]
        self.ref.child("Products").child(productId).setValue(dict) { (err, dbRef) in
            self.progressBar.removeFromSuperview()
            if err == nil {
                showSwiftMessageWithParams(theme: .success, title: "Sucessfully Posted", body: "Your Item in sucessfully posted")
//                self.titleTextField.text = ""
//                self.brandTextField.text = ""
//                self.sizeTextField.text = ""
//                self.priceTextField.text = ""
//                self.currencyTextField.text = ""
//                self.locationTextField.text = ""
//                self.detailsTextField.text = ""
//                self.selectImageView.image = nil
//                self.tabBarController?.selectedIndex = 0
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "tabBar")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = redViewController
            }else{
                showSwiftMessageWithParams (theme: .error, title: "Error", body: "\(String(describing: err?.localizedDescription))")
            }
        }
    }
    
    private func saveImageToDatabase(){
        let productID = UUID().uuidString
        if selectImageView.image != nil {
            let storgaeRef = Storage.storage().reference().child("ProductImages").child("\(productID).png")
            if let uploadData = selectImageView.image!.pngData(){
                self.view.addSubview(self.progressBar)
                storgaeRef.putData(uploadData, metadata: nil) { (metaData, error) in
                    self.progressBar.removeFromSuperview()
                    if error != nil {
                        showSwiftMessageWithParams(theme: .error, title: "Error", body: error?.localizedDescription ?? "")
                        return
                    }
                    storgaeRef.downloadURL { (url, err) in
                        if err != nil {
                            showSwiftMessageWithParams(theme: .error, title: "Error", body: err?.localizedDescription ?? "")
                            return
                        }
                        let storageUrl = "\(url!)"
                        self.saveDataIntoDatabase(imageUrl: storageUrl, productId: productID)
                    }
                }
            }
        }else{
            self.saveDataIntoDatabase(imageUrl: "", productId: productID)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        location.placemark { placemark, error in
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            print(placemark.postalAddressFormatted ?? "")
            self.locationTextField.text = "\(placemark.city ?? "") \(placemark.state ?? "") \(placemark.zipCode ?? "")"
        }
    }
    
    
    //MARK:- Actions
    @IBAction func postBtnTapped(_ sender: UIButton) {
        if titleTextField.text == ""{
            titleTextField.becomeFirstResponder()
            self.view.makeToast("Please enter Tile of the Product", duration: 3.0, position: .top)
        }else if brandTextField.text == "" {
            brandTextField.becomeFirstResponder()
            self.view.makeToast("Please last Brand name", duration: 3.0, position: .top)
        }else if sizeTextField.text == ""{
            sizeTextField.becomeFirstResponder()
            self.view.makeToast("Please select Size/Model", duration: 3.0, position: .top)
        }else if priceTextField.text == "" {
            priceTextField.becomeFirstResponder()
            self.view.makeToast("Please enter Price", duration: 3.0, position: .top)
        }else if currencyTextField.text == "" {
            currencyTextField.becomeFirstResponder()
            self.view.makeToast( "Please enter currency code of your country", duration: 3.0, position: .top)
        }else if locationTextField.text == "" {
            locationTextField.becomeFirstResponder()
            self.view.makeToast("Please enter your Address", duration: 3.0, position: .top)
        }else if detailsTextField.text == "" {
            detailsTextField.becomeFirstResponder()
            self.view.makeToast("Please enter little bit detail of the product", duration: 3.0, position: .top)
        }else if selectImageView.image == nil {
            selectImageView.shake()
            self.view.makeToast("Please select at least one picture", duration: 3.0, position: .top)
        }else{
            saveImageToDatabase()
        }
    }
    
    @objc func SelectImageBtnTapped() {
        ImagePickerManager().pickImage(self){ image in
            //here is the image
            self.selectImageView.image = image
            
        }
    }
    
}
