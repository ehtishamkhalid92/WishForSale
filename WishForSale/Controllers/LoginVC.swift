//
//  LoginVC.swift
//  WishForSale
//
//  Created by Ehtisham Khalid on 26/11/2020.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK:- Variables.
    let progressHUD = ProgressHUD(text: "Please wait...")
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    //MARK:- Actions.
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        if emailTextField.text == ""{
            emailTextField.becomeFirstResponder()
            self.view.makeToast("Please enter email", duration: 3.0, position: .top)
        }else if passwordTextField.text == "" {
            passwordTextField.becomeFirstResponder()
            self.view.makeToast("Please enter your password", duration: 3.0, position: .top)
        }else {
            authenticateAndLoggedInUserToApp()
        }
    }
    
    @IBAction func forgotPasswordBtn(_ sender: UIButton) {
        let SB = UIStoryboard.init(name: "Main", bundle: nil)
        let VC = SB.instantiateViewController(identifier: "ResetPasswordVC") as! ResetPasswordVC
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
        let SB = UIStoryboard.init(name: "Main", bundle: nil)
        let VC = SB.instantiateViewController(identifier: "RegisterVC") as! RegisterVC
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
        
    }
    
    //MARK:- Actions
    
    private func setupViews(){
        loginBtn.shadowView()
    }
    
    private func authenticateAndLoggedInUserToApp(){
        let email = emailTextField.text!
        let password = passwordTextField.text!
        self.view.addSubview(progressHUD)
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error as NSError? {
                self.progressHUD.removeFromSuperview()
                switch AuthErrorCode(rawValue: error.code) {
                case .tooManyRequests:
                    showSwiftMessageWithParams(theme: .info, title: "Information", body: "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.")
                    break
                case .operationNotAllowed:
                    // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                    showSwiftMessageWithParams(theme: .info, title: "Information", body: "Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.")
                    break
                case .userDisabled:
                    // Error: The user account has been disabled by an administrator.
                    showSwiftMessageWithParams(theme: .info, title: "Information", body: "The user account has been disabled by an administrator.")
                    break
                case .wrongPassword:
                    // Error: The password is invalid or the user does not have a password.
                    showSwiftMessageWithParams(theme: .info, title: "Information", body: "The password is invalid or the user does not have a password.")
                    break
                case .invalidEmail:
                    // Error: Indicates the email address is malformed.
                    showSwiftMessageWithParams(theme: .info, title: "Information", body: "Indicates the email address is malformed")
                    break
                default:
                    print("Error: \(error.localizedDescription)")
                    showSwiftMessageWithParams(theme: .info, title: "Information", body: "\(error.localizedDescription)")
                }
            } else {
                print("User signs in successfully")
//                let userInfo = Auth.auth().currentUser
//                let email = userInfo?.email ?? ""
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "tabBar")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = redViewController
                showSwiftMessageWithParams(theme: .success, title: "Successfully Login", body: "Welcome To Wish For Sale")
            }
        }
    }
    
}
