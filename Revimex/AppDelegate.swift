//
//  AppDelegate.swift
//  Revimex
//
//  Created by Seifer on 30/10/17.
//  Copyright © 2017 Revimex. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

var incioSesionBtn = UIButton()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isFirstTime = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        var logged = false
        if let loggedIn = UserDefaults.standard.object(forKey: "loggedIn") as? Bool{
            logged = loggedIn
        }
        if logged {
            logIn()
        }
        
        GMSServices.provideAPIKey("AIzaSyBuwBiNaQQcYb6yXDoxEDBASvrtjWgc03Q")
        GMSPlacesClient.provideAPIKey("AIzaSyBuwBiNaQQcYb6yXDoxEDBASvrtjWgc03Q")
        
        
        if let firstTime = UserDefaults.standard.object(forKey: "isFirstTime") as? Bool{
            isFirstTime = firstTime
        }
        
        if isFirstTime == false {
            self.window = UIWindow(frame: UIScreen.main.bounds)
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "navigationManager")
        
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func logIn(){
        
        var usuario = ""
        var contraseña = ""
        var userId = ""
        
        if let us = UserDefaults.standard.object(forKey: "usuario") as? String{
            usuario = us
        }
        if let pass = UserDefaults.standard.object(forKey: "contraseña") as? String{
            contraseña = pass
        }
        if let id = UserDefaults.standard.object(forKey: "userId") as? String{
            userId = id
        }
        
        
        let urlRequestFiltros = "http://18.221.106.92/api/public/user/login"
        
        let parameters: [String:Any] = [
            "email" : usuario,
            "password" : contraseña
        ]
        
        guard let url = URL(string: urlRequestFiltros) else { return }
        
        var request = URLRequest (url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let session  = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject (with: data) as! [String:Any?]
                    
                    print(json)
                    print(json["status"] as! Int)
                    print(json["mensaje"] as! String)
                    
                    switch (json["status"] as! Int) {
                        case 1:
                            UserDefaults.standard.set(true, forKey: "loggedIn")
                            UserDefaults.standard.set(usuario, forKey: "usuario")
                            UserDefaults.standard.set(contraseña, forKey: "contraseña")
                            if let userId = (json["user_id"] as? String){
                                UserDefaults.standard.set(userId, forKey: "userId")
                            }
                        default:
                            UserDefaults.standard.set(false, forKey: "loggedIn")
                    }
                    
                } catch {
                    print("El error es: ")
                    print(error)
                }
                
                
            }
        }.resume()
            
    
        
    }


}

