//
//  AppDelegate.swift
//  Shopping Pro
//
//  Created by AKIL KUMAR THOTA on 6/25/17.
//  Copyright © 2017 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import KRProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {

    var window: UIWindow?
    var firstLoad:Bool?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        Database.database().isPersistenceEnabled = true
        
        
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.4257492554, green: 0.7296381597, blue: 1, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        
        loadUserDefaults()
        
        
        Auth.auth().addStateDidChangeListener { (auth:Auth, user:User?) in
            
            if user != nil {
                if (auth.currentUser?.isEmailVerified)! {
                    if userDefaults.object(forKey: kCURRENTUSER) != nil {
                        self.goToApp()                        
                    }
                    
                }else if userDefaults.object(forKey: "google") as! Bool == true {
                    if userDefaults.object(forKey: kCURRENTUSER) != nil {
                        self.goToApp()
                    }
                }
            }
        }
        
        return true
    }
    
    func loadUserDefaults() {
        
        firstLoad = userDefaults.bool(forKey: kFIRSTRUN)
        
        if !firstLoad! {
            userDefaults.set(true, forKey: kFIRSTRUN)
            userDefaults.set("$", forKey: kCURRENCY)
            userDefaults.set(false, forKey: "google")
            userDefaults.synchronize()
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            KRProgressHUD.showError(withMessage: err.localizedDescription)
        }else{
            
            guard let idToken = user.authentication.idToken else {return}
            guard let accessToken = user.authentication.accessToken else {return}
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            Auth.auth().signIn(with: credentials, completion: { (user:User?, error:Error?) in
                
                if let err = error {
                    KRProgressHUD.showError(withMessage: err.localizedDescription)
                    return
                }
                if let user = user {
                    
                    let name = user.displayName ?? ""
                    
                    let fUser = FUser(objectId: user.uid, createdAt: Date(), email: user.email!, firstName: name, lastName: "")
                    userDefaults.set(true, forKey: "google")
                    userDefaults.synchronize()
                    // saving to user defaults
                    saveUserlocally(user: fUser)
                    // saving to firebase also
                    saveUserToFirebase(user: fUser)
                    self.goToApp()
                }
                
            })
        }
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
    
    func goToApp() {
        
        let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        vc.selectedIndex = 0
        
        self.window = UIWindow(frame:UIScreen.main.bounds)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }


}

