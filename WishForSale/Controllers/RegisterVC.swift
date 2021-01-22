//
//  RegisterVC.swift
//  WishForSale
//
//  Created by Ehtisham Khalid on 26/11/2020.
//

import UIKit
import Firebase


class RegisterVC: UIViewController {

    //MARK:- Properties.
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    //MARK:- Variables.
    var ref: DatabaseReference!
    let progressHUD = ProgressHUD(text: "Please wait...")
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Actions.
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        if firstNameTextField.text == ""{
            firstNameTextField.becomeFirstResponder()
            self.view.makeToast("Please enter first name", duration: 3.0, position: .top)
        }else if lastNameTextField.text == "" {
            lastNameTextField.becomeFirstResponder()
            self.view.makeToast("Please last first name", duration: 3.0, position: .top)
        }else if countryTextField.text == ""{
            countryTextField.becomeFirstResponder()
            self.view.makeToast("Please select country name", duration: 3.0, position: .top)
        }else if emailTextField.text == "" {
            emailTextField.becomeFirstResponder()
            self.view.makeToast("Please enter your email address", duration: 3.0, position: .top)
        }else if mobileTextField.text == "" {
            mobileTextField.becomeFirstResponder()
            self.view.makeToast( "Please enter your mobile number", duration: 3.0, position: .top)
        }else if passwordTextField.text == "" {
            passwordTextField.becomeFirstResponder()
            self.view.makeToast("Please enter your password", duration: 3.0, position: .top)
        }else{
            saveDataTofirebaseAuth()
        }
        
    }
    @IBAction func termAndConditionBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        let SB = UIStoryboard.init(name: "Main", bundle: nil)
        let VC = SB.instantiateViewController(identifier: "LoginVC") as! LoginVC
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
    }
    
    //MARK:- Functions.
    private func setupViews(){
        registerBtn.shadowView()
    }
    
    private func saveDataTofirebaseAuth(){
        self.view.addSubview(progressHUD)
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
            self.progressHUD.removeFromSuperview()
            switch AuthErrorCode(rawValue: error.code) {
            case .operationNotAllowed:
              // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                showSwiftMessageWithParams(theme: .info, title: "Information", body: "The email address is already in use by another account.")
                break
            case .emailAlreadyInUse:
                // Error: The email address is already in use by another account.
                showSwiftMessageWithParams(theme: .info, title: "Information", body: "The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section")
                break
            case .invalidEmail:
              // Error: The email address is badly formatted.
                showSwiftMessageWithParams(theme: .info, title: "Information", body: "The email address is badly formatted")
                break
            case .weakPassword:
              // Error: The password must be 6 characters long or more.
                showSwiftMessageWithParams(theme: .info, title: "Information", body: "The email address is badly formatted")
                break
            default:
                print("Error: \(error.localizedDescription)")
                showSwiftMessageWithParams(theme: .error, title: "Error", body: "\(error.localizedDescription)")
            }
          } else {
            self.saveDataToFirebaseRelatimeDatabase()
//            let newUserInfo = Auth.auth().currentUser
//            let email = newUserInfo?.email
          }
        }
    }
    
    private func saveDataToFirebaseRelatimeDatabase(){
        let uid = Auth.auth().currentUser?.uid ?? ""
        let dict : [String: Any] = ["name": "\(firstNameTextField.text!) \(lastNameTextField.text!)","country": countryTextField.text!,"email":emailTextField.text!,"mobile":mobileTextField.text!,"password":passwordTextField.text!]
        self.ref.child("Users").child(uid).setValue(dict) { (err, dbRef) in
            if err == nil {
                showSwiftMessageWithParams(theme: .success, title: "User register sucessfully", body: "Welcome to Wish For Sale")
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "tabBar")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = redViewController
            }else{
                showSwiftMessageWithParams(theme: .error, title: "Error", body: "\(String(describing: err?.localizedDescription))")
            }
            
        }
        
    }
    
    
}
