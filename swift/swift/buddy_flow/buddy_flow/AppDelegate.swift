//
//  AppDelegate.swift
//  practice
//
//  Created by Eunji Kim on 12/19/24.
//

import UIKit
import FirebaseCore
import Firebase
import GoogleSignIn
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        //checkUser()
        return true
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey:Any]=[:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

//    func checkUser(){
//        if let user = Auth.auth().currentUser{
//            print("User is already signed in")
//            showHomeScreen()
//        } else {
//            showLoignScreen()
//        }
//    }
//    func showHomeScreen(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "home") as! ViewController }
//
//    func showLoignScreen(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let loginViewController = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController }
    
}

