//  ForgotPassView.swift
//  MyOutdoorAgent
//  Created by CS on 04/08/22.

import UIKit
import PKHUD
import Alamofire

class ForgotPassView: UIViewController {
    
    // MARK: - Objects
    private var forgotPasswordViewModel: ForgotPasswordViewModel?
    
    // MARK: - Outlets
    @IBOutlet weak var emailTxtF: UITextField!
    @IBOutlet weak var sendResetLinkBtn: UIView!
    @IBOutlet weak var customNavBar: CustomNavBar!
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewAppear()
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
        actionBlock()
        setDelegates()
    }
    
    private func onViewAppear() {
        scrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    private func setUI() {
        showNavigationBar(false)
        setcustomNav(customView: customNavBar, titleIsHidden: true, titleText: EMPTY_STR, navViewColor: .white, mainViewColor: .white, backImg: Images.back.name)
    }
    
    private func setDelegates() {
        forgotPasswordViewModel = ForgotPasswordViewModel(self)
    }
    
    
    
    private func actionBlock() {
        // -- Reset Password Link
        sendResetLinkBtn.actionBlock {
            if self.emailTxtF.text != "" {
                if self.emailTxtF.text?.isEmailValid == true {
                    ApiStore.shared.forgotPasswordApiMoa(self.view, self.emailTxtF.text ?? "") { response in
                        if response.statusCode == 200 {
                            HUD.hide()
                            let vc = UIStoryboard(name: Storyboards.main.name, bundle: nil).instantiateViewController(withIdentifier: Controllers.GetVerificationCodeView.name) as! GetVerificationCodeView
                            vc.forgotModel = response
                            LocalStore.shared.PublicKey = response.model.publicKey ?? ""
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                } else {
                    Alerts().showAlert("Please enter a valid email")
                }
            } else {
                Alerts().showAlert("Enter an email")
            }
        }
    }
    
 
}


// MARK: - ForgotPasswordModelDelegate
extension ForgotPassView: ForgotPasswordModelDelegate {
    func successCalled(_ success: String) {
        DispatchQueue.main.async {
            HUD.hide()
            let okBtn = [ButtonText.ok.text]
            UIAlertController.showAlert(AppAlerts.alert.title, message: success, buttons: okBtn) { alert, index in
                if index == 0 {
                    UIApplication.visibleViewController.popOnly()
                }
            }
        }
    }
    
    func errorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    
    func accountNotExitCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
}



/*
 
 
 
    func postRequest(completion: @escaping ([String: Any]?, Error?) -> Void) {

        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["Email": emailTxtF.text]

        //create the url with NSURL
        let url = URL(string: "https://datav2.myoutdooragent.com/api/account/forgotpasswordv2")!

        //create the session object
        let session = URLSession.shared

        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }

        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                //create json object from data
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                print(json)
                completion(json, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
        })

        task.resume()
    }
 
 {
    // self.pushOnly(Storyboards.main.name, Controllers.GetVerificationCodeView.name, true)
    // self.forgotPasswordViewModel?.checkEmptyFields(self.view, self.emailTxtF.text!)
     self.emailTxtF.text =  "neha@yopmail.com"
     self.postRequest { data, error in
         print(data)
         var dd = NSDictionary()
         dd = data as! NSDictionary
         print(dd)
         print((dd["model"] as! NSDictionary) ["email"] ?? "")
         print((dd["model"] as! NSDictionary) ["phone"] ?? "")
         print((dd["model"] as! NSDictionary) ["publicKey"] ?? "")
         
        DispatchQueue.main.async {
             let vc = UIStoryboard(name: Storyboards.main.name, bundle: nil).instantiateViewController(withIdentifier: Controllers.GetVerificationCodeView.name) as! GetVerificationCodeView
             
             vc.userEmail = ((dd["model"] as! NSDictionary) ["email"] as! String)
             
             if vc.userPhone == ""{
                // vc.userPhone = ((dd["model"] as! NSDictionary) ["phone"])  as! String
                 debugPrint("sihsjajdkks")
                 vc.userPhone = "-"
             }
             else{
                 vc.userPhone = ((dd["model"] as! NSDictionary) ["phone"])  as! String
             }
            
             vc.userPublicKey = ((dd["model"] as! NSDictionary) ["publicKey"] as! String )
             print(vc.userPublicKey)
             self.navigationController?.pushViewController(vc, animated: true)
         }
         
     }

 }
 */
