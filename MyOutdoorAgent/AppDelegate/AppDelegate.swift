//  AppDelegate.swift
//  MyOutdoorAgent
//  Created by CS on 01/08/22.

import UIKit
import DropDown
import Firebase
import IQKeyboardManager
import GoogleSignIn
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared().isEnabled = true
        DropDown.startListeningToKeyboard()
        executeVC(Storyboards.main.name, Navigation.homeNav.name)
        FirebaseApp.configure()
        GMSServices.provideAPIKey(googleKey)
        return true
    }
    
    // MARK: - GoogleSignIn Delegates
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        // Handle other custom URL types.
        // If not handled by this app, return false.
        return false
    }
    
    //MARK: - Execute Root View Controller
    func executeVC(_ storyBoardName: String, _ className: String) {
        let vC = UIStoryboard(name: storyBoardName, bundle: Bundle.main).instantiateViewController(withIdentifier: className)
        window?.rootViewController = vC
        window?.makeKeyAndVisible()
    }
    func applicationWillTerminate(_ application: UIApplication) {
        print("KILL")
    }
}

/*
         if LocalStore.shared.userId == EMPTY_STR {
             executeVC(Storyboards.main.name, Navigation.loginNav.name)   // -- If userId is empty, execute login page
         } else {
             if LocalStore.shared.isSocialHandler == "google" {
                 // Initialize Google sign-in
                 GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                     if error != nil || user == nil {
                         // Show the app's signed-out state.
                         self.executeVC(Storyboards.main.name, Navigation.loginNav.name)
                     } else {
                         // Show the app's signed-in state.
                         self.executeVC(Storyboards.main.name, Navigation.homeNav.name)
                     }
                 }
             } else {
                 executeVC(Storyboards.main.name, Navigation.homeNav.name)    // -- If userId is not empty, execute home page
             }
         }
 */
