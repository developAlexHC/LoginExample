//
//  ViewController.swift
//  LoginExample
//
//  Created by Alex Hsieh on 2018/5/3.
//  Copyright © 2018年 Alex Hsieh. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class ViewController: UIViewController{
  

    @IBOutlet weak var googleSigninButton: GIDSignInButton!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["public_profile", "email"]
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }

}

extension ViewController:GIDSignInDelegate, GIDSignInUIDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print("Failed to log into Google:\(error)")
        }
        guard let authentication = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("Failed to create a firebase User with Google account:\(error!)")
                return
            }
           
            print("Successfully logged in with Google...")
            //let detailController = DetailViewController()
            //detailController.fetchUser()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}




extension ViewController:FBSDKLoginButtonDelegate{
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Error:\(error)")
            return
        }
        fbToFireBase()
    }

    func fbToFireBase(){
        
        let fbAccessToken = FBSDKAccessToken.current()
        guard let accessTokenString = fbAccessToken?.tokenString else {return}
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("credentials error")
                return
            }
            
            print("Successfully logged in with facebook...")
            let detailController = DetailViewController()
            detailController.fetchUser()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
//    func fetchUser() {
//        let parameters = ["fields": "id, name, email"]
//
//        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
//            if error != nil {
//                print("failed to start graph request:\(error!)")
//            }
//        }
//    }
    
}

