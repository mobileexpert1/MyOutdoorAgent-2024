//  UIViewController.swift
//  MyOutdoorAgent
//  Created by CS on 01/08/22.

import UIKit

let textViewForAlert = UITextView(frame: CGRect.zero)

extension UIViewController {
    
    func setcustomNav(customView: CustomNavBar, titleIsHidden: Bool = true, titleText: String = EMPTY_STR, navViewColor: UIColor, mainViewColor: UIColor, backImg: UIImage) {
        customView.titleLbl.isHidden = titleIsHidden
        customView.titleLbl.text = titleText
        customView.backBtn.image = backImg
        customView.backBtn.actionBlock {
            if titleText == "My Active License(s)" {
                var data = [String: Any]()
                data["title"] = "My Active License(s)"
                self.pushWithData("Main", "TabBarView",data)
                //self.pushOnly("Main", "TabBarView", true)
            } else{
                self.popOnly()
            }
          //  self.popOnly()
        }
        customView.navView.backgroundColor = navViewColor
        customView.mainView.backgroundColor = mainViewColor
    }
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    func isPresentedModally() -> Bool {
        return self.presentingViewController?.presentedViewController == self
    }
    
    func pushControl(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func showNavigationBar(_ show: Bool, animated: Bool = false) {
        navigationController?.setNavigationBarHidden(!show, animated: animated)
    }
    
    func findContentViewControllerRecursively() -> UIViewController {
        var childViewController: UIViewController?
        if (self is UITabBarController) {
            childViewController = (self as? UITabBarController)?.selectedViewController
        }
        else if (self is UINavigationController) {
            childViewController = (self as? UINavigationController)?.topViewController
        }
        else if (self is UISplitViewController) {
            childViewController = (self as? UISplitViewController)?.viewControllers.last
        }
        else if (self.presentedViewController != nil) {
            childViewController = self.presentedViewController
        }
        let shouldContinueSearch: Bool = (childViewController != nil) && !((childViewController?.isKind(of: UIAlertController.self))!)
        return shouldContinueSearch ? childViewController!.findContentViewControllerRecursively() : self
    }
    
    func customAddChildViewController(_ child: UIViewController) {
        self.customAddChildViewController(child, toSubview: self.view)
    }
    
    func customAddChildViewController(_ child: UIViewController, toSubview subview: UIView) {
        self.addChild(child)
        subview.addSubview(child.view)
        //child.view.addConstraintToFillSuperview()
        child.didMove(toParent: self)
    }
    
    func customRemoveFromParentViewController() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    func customRemoveAllChildViewControllers() {
        for control: UIViewController in self.children {
            control.customRemoveFromParentViewController()
        }
    }
    
    func popOrDismissViewController(_ animated: Bool) {
        if self.isPresentedModally() {
            self.dismiss(animated: animated, completion:nil)
        } else if (self.navigationController != nil) {
            _ = self.navigationController?.popViewController(animated: animated)
        }
    }
    
    func pushOnly(_ storyboardName: String, _ controllerId: String, _ animation: Bool) {
        let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: controllerId)
        self.navigationController?.pushViewController(vc, animated: animation)
    }
    
    func presentOnly(_ controllerId: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: controllerId)
        vc?.modalPresentationStyle = .currentContext
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    func popOnly() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func popToAnotherVC(_ controller: UIViewController) {
        self.navigationController?.popToViewController(controller, animated: true)
    }
    
    func popToSpecificVC(_ storyboardName: String, _ controllerId: String){
        
            let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: controllerId)
            self.navigationController?.popToViewController(vc, animated: true)
        
    }
    
    func pushWithData<T>(_ storyboardName: String, _ controllerId:String, _ data:T) {
        let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: controllerId)
        vc.dataFromLastVC = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popToSpecificVCs(_ controllerId: String) {
        
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
               
                if viewController.restorationIdentifier == controllerId {
                    self.navigationController?.popToViewController(viewController, animated: true)
                    return
                }
            }
        }
    
        print("ViewController with identifier \(controllerId) not found in the navigation stack.")
    }

    
    struct DataHolder {
        static var data:Any!
    }
    
    var dataFromLastVC:Any {
        get {
            return DataHolder.data as Any
        }
        set(newValue) {
            DataHolder.data = newValue
        }
    }
    
    func getVC(_ id:String) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: id)
    }
    
    func sendFeedback(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Feedback \n\n\n\n\n", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default) { (action) in
            alertController.view.removeObserver(self, forKeyPath: "bounds")
        }
        alertController.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            _ = textViewForAlert.text
            alertController.view.removeObserver(self, forKeyPath: "bounds")
        }
        alertController.addAction(saveAction)
        
        alertController.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
        textViewForAlert.backgroundColor = UIColor.white
        textViewForAlert.textContainerInset = UIEdgeInsets.init(top: 8, left: 5, bottom: 8, right: 5)
        alertController.view.addSubview(textViewForAlert)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds"{
            if let rect = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue {
                let margin: CGFloat = 8
                let xPos = rect.origin.x + margin
                let yPos = rect.origin.y + 54
                let width = rect.width - 2 * margin
                let height: CGFloat = 90
                
                textViewForAlert.frame = CGRect.init(x: xPos, y: yPos, width: width, height: height)
            }
        }
    }
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height-100, width: self.view.frame.size.width, height: 35))
        toastLabel.backgroundColor = .red
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        //toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    // MARK: - Custom Methods
    func add(asChildViewController viewController: UIViewController, _ view: UIView) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    //----------------------------------------------------------------
    
    func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
}



