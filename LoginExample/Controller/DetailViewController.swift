//
//  DetailViewController.swift
//  LoginExample
//
//  Created by Alex Hsieh on 2018/5/3.
//  Copyright © 2018年 Alex Hsieh. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class DetailViewController: UIViewController {

    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    
    var name = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.current()) == nil{
            performSegue(withIdentifier: "Loginsegue", sender: self)
        }
        fetchUser()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func logout(_ sender: Any) {
        FBSDKLoginManager().logOut()
        GIDSignIn.sharedInstance().signOut()
        performSegue(withIdentifier: "Loginsegue", sender: self)
    }
    
    func fetchUser() {
        let parameters = ["fields": "id, name, email,gender"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                print("failed to start graph request:\(error!)")
            }
            
            guard let newResult = result as? [String:Any] else {return}
            print(newResult)
            self.name = newResult["name"] as! String
        }
        
    }
    

    
}
