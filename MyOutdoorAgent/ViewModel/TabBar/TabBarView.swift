//  TabBarView.swift
//  MyOutdoorAgent
//  Created by CS on 04/08/22.

import UIKit

class TabBarView: UITabBarController {
    
    // MARK: - Variables
    var tabBarTitle =  [CommonKeys.home.name, CommonKeys.search.name, CommonKeys.message.name, CommonKeys.myAccount.name]
    var selectedImgArr = [Images.homeSelected.name, Images.searchSelected.name, Images.chatSelected.name, Images.profileSelected.name]
    var unselectedImgArr = [Images.homeUnselected.name, Images.searchUnselected.name, Images.chatUnselected.name, Images.profileUnselected.name]
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let data = dataFromLastVC as? [String:Any]
        let title = data?["title"] as? String
        print("title",title)
        if title == "My Active License(s)"{
            LocalStore.shared.navigationScreen = title ?? ""
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                if let tabBarController = self.tabBarController,
//                   tabBarController.selectedIndex == 0,  // Check if the current selected index is 0
//                   let navController = tabBarController.viewControllers?[0] as? UINavigationController {
//                    navController.popToRootViewController(animated: false)
//                }
//            //    self.tabBarController?.selectedIndex = 1
//                
//                self.tabBarController?.selectedIndex = 1
//            }
        }
        setTabBar()
       
    }
    
    // MARK: - Set TabBar
    private func setTabBar() {
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.tintColor = Colors.bgGreenColor.value
        self.tabBar.barTintColor = .white
        self.tabBar.backgroundColor = .white
        
        self.tabBarItem.image = Images.homeSelected.name
        self.tabBarItem.selectedImage = Images.homeSelected.name
        
        // -- Set image for each tab
        for i in 0..<selectedImgArr.count {
            tabBar.items?[i].title = tabBarTitle[i]
            self.tabBar.items?[i].image = unselectedImgArr[i].withRenderingMode(.alwaysOriginal)
            tabBar.items?[i].selectedImage = selectedImgArr[i].withRenderingMode(.alwaysOriginal)
            tabBar.items?[i].imageInsets = UIEdgeInsets(top: 2 , left: 2, bottom: 2, right: 2)
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarView: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (tabBar.items)![2] {
            LocalStore.shared.userId == EMPTY_STR
            ? (self.loginAlert())
            : (self.tabBarController?.selectedIndex = 2)
        }
        else if item == (tabBar.items)![3] {
            LocalStore.shared.userId == EMPTY_STR
            ? (self.loginAlert())
            : (self.tabBarController?.selectedIndex = 3)
        }
    }
    
    func loginAlert() {
        let btns = [ButtonText.login.text]
        UIAlertController.showAlert(AppAlerts.authReq.title, message: AppAlerts.loginFirst.title, buttons: btns) { alert, index in
            if index == 0 {
                self.pushOnly(Storyboards.main.name,  Controllers.form.name, true)
            }
        }
    }
}
