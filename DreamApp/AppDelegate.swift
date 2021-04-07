//
//  AppDelegate.swift
//  DreamApp
//
//  Created by bird on 1/8/21.
//
import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let googleApiKey = "AIzaSyDlHehSkS1jY6ZXAg_vUUZcZ22rKYhbgtE"

    var categoryID : String!
    var serviceID : String!
    var categoryName : String!
    var serviceName : String!
    var loginStatus = "no"
    var userID : String!
    var user_uid : String!    
    var seluser_uid : String!
    var chatid : String!
    var chat_uid : String!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(googleApiKey)
        IQKeyboardManager.shared.enable = true
        
        GMSPlacesClient.provideAPIKey("AIzaSyDlHehSkS1jY6ZXAg_vUUZcZ22rKYhbgtE")
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    static func shared() -> AppDelegate {
       return UIApplication.shared.delegate as! AppDelegate
   }


}

