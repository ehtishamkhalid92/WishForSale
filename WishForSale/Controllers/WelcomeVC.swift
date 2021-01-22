//
//  ViewController.swift
//  WishForSale
//
//  Created by Ehtisham Khalid on 26/11/2020.
//

import UIKit
import Foundation

class WelcomeVC: UIViewController {
    
    //MARK:- Outlets and Properties
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK:- Variables.
    
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = true
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
//    }
    
    // MARK:-  Actions
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard.init(name: "Main", bundle: nil)
        let VC = SB.instantiateViewController(identifier: "RegisterVC") as! RegisterVC
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard.init(name: "Main", bundle: nil)
        let VC = SB.instantiateViewController(identifier: "LoginVC") as! LoginVC
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
    }
    
    
    //MARK:- Funstions
    
    private func setupViews() {
        registerBtn.shadowView()
        loginBtn.shadowView()
    }
    
    
}

