//
//  ResetPasswordVC.swift
//  WishForSale
//
//  Created by Ehtisham Khalid on 30.11.20.
//

import UIKit
import Firebase

class ResetPasswordVC: UIViewController {

    //MARK:- Properties
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var resetPasswordTextField: UITextField!
    
    //MARK:- Variables
    let progressHUD = ProgressHUD(text: "Please wait...")
    
    //MARK: View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().languageCode = "en"
        sendBtn.shadowView()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Action
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        if resetPasswordTextField.text == "" {
            resetPasswordTextField.becomeFirstResponder()
            self.view.makeToast("Please enter your email", position: .top)
        }else {
            self.view.addSubview(progressHUD)
            Auth.auth().sendPasswordReset(withEmail: resetPasswordTextField.text!) { (error) in
                self.progressHUD.removeFromSuperview()
                if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .userNotFound:
                  // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                    showSwiftMessageWithParams(theme: .info, title: "Information", body: "The email address is already in use by another account.")
                    break
                case .invalidEmail:
                  // Error: The email address is badly formatted.
                    showSwiftMessageWithParams(theme: .info, title: "Information", body: "The email address is already in use by another account.")
                    break
                case .invalidRecipientEmail:
                  // Error: Indicates an invalid recipient email was sent in the request.
                    showSwiftMessageWithParams(theme: .info, title: "Information", body: "The email address is already in use by another account.")
                    break
                case .invalidSender:
                  // Error: Indicates an invalid sender email is set in the console for this action.
                    showSwiftMessageWithParams(theme: .info, title: "Information", body: "Indicates an invalid sender email is set in the console for this action.")
                    break
                case .invalidMessagePayload:
                  // Error: Indicates an invalid email template for sending update email.
                    showSwiftMessageWithParams(theme: .info, title: "Information", body: "Indicates an invalid email template for sending update email.")
                    break
                default:
                  print("Error message: \(error.localizedDescription)")
                    showSwiftMessageWithParams(theme: .error, title: "Error", body: "\(error.localizedDescription)")
                }
              } else {
                print("Reset password email has been successfully sent")
                showSwiftMessageWithParams(theme: .success, title: "Email Send", body: "Reset password email has been successfully sent")
                self.resetPasswordTextField.text = ""
              }
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
