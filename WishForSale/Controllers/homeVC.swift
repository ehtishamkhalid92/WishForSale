//
//  homeVC.swift
//  WishForSale
//
//  Created by Ehtisham Khalid on 26/11/2020.
//

import UIKit
import Firebase
class homeVC: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    //MARK:- Variables
    var productArray = [productModal]()
    var categoryArray = [categoryModel]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getProductDataFromDatabase()
        setupViews()
    }
    
    //MARK:- Action
    @IBAction func logoutBtn(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            showSwiftMessageWithParams(theme: .success, title: "Sucessfully Logout", body: "")
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = redViewController
        } catch {
            print("Sign out error")
        }
        
    }
    
    //MARK:- Functions
    private func getProductDataFromDatabase() {
        let ref = Database.database().reference()
        ref.child("Products").observe(.childAdded) { (snapshot) in
            var data = productModal()
            let dict  = snapshot.value as? NSDictionary
            data.Brand = dict?["Brand"] as? String ?? ""
            data.currency = dict?["currency"] as? String ?? ""
            data.details = dict?["details"] as? String ?? ""
            data.imageUrl = dict?["imageUrl"] as? String ?? ""
            data.location = dict?["location"] as? String ?? ""
            data.price = dict?["price"] as? String ?? ""
            data.productId = dict?["productId"] as? String ?? ""
            data.size = dict?["size"] as? String ?? ""
            data.title = dict?["title"] as? String ?? ""
            data.userID = dict?["userID"] as? String ?? ""
            self.productArray.append(data)
            print(self.productArray)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
//                print(self.productArray)
            }
        }
    }
    
    private func setupViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryArray = [
            categoryModel(name: "All", image: #imageLiteral(resourceName: "all")),
            categoryModel(name: "Clothes", image: #imageLiteral(resourceName: "tshirt")),
            categoryModel(name: "Shoes", image: #imageLiteral(resourceName: "shoes")),
            categoryModel(name: "Mobile", image: #imageLiteral(resourceName: "phone")),
            categoryModel(name: "Tablets", image: #imageLiteral(resourceName: "ipad")),
            categoryModel(name: "Computer", image: #imageLiteral(resourceName: "monitor")),
            categoryModel(name: "Vehicle", image: #imageLiteral(resourceName: "car")),
            categoryModel(name: "Music", image: #imageLiteral(resourceName: "music-note"))
        ]
    }
   
    
    
}
extension homeVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categoryArray.count
        }else {
            return productArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! categoryCollectionViewCell
            guard indexPath.row < categoryArray.count else {return cell}
            let data = categoryArray[indexPath.row]
            cell.itemImage.image = data.image
            cell.nameLbl.text = data.name
            if data.selected == true {
                cell.nameLbl.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            }else {
                cell.nameLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! productCollectionViewCell
            cell.cardView.layer.cornerRadius = 5
            cell.cardView.shadowView()
            cell.itemImage.layer.cornerRadius = 5
            guard indexPath.row < productArray.count else {return cell}
            let data = productArray[indexPath.row]
            cell.itemImage.loadImageUsingCacheWithURLString(data.imageUrl, placeHolder: #imageLiteral(resourceName: "imageView"))
            cell.priceLbl.text = "  \(data.price) \(data.currency)"
            cell.nameLbl.text = data.title
            cell.locationLbl.text = data.location
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize(width: 80, height: 80)
        }else {
            let padding: CGFloat =  0
            let collectionViewSize = collectionView.frame.size.width - padding

            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
        }
            
        }
    
    private func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
    }
    
    
}

