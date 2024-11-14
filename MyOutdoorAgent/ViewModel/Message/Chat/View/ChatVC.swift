//  ChatVC.swift
//  MyOutdoorAgent
//  Created by CS on 12/08/22.

import UIKit
import IQKeyboardManager
import PKHUD

class ChatVC: UIViewController {
    
    // MARK: - Variables
    var productId: Int?
    var connectionID = ""
    var payloadArray = [String]()
    var selectedRluId = Int()
    var titleText = String()
    var userType = [String]()
    
    var timer : Timer?
    var isFetchingReq = false
    
    private var messageViewModel: MessageViewModel?
    
    // MARK: - Outlets
    @IBOutlet weak var customNavBar: CustomNavBar!
    @IBOutlet weak var sendBtn: UIImageView!
    @IBOutlet weak var tblChat: ChatDetailsTableView!
    @IBOutlet weak var txtMessage: UITextView!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        onViewAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // self.tblChat.scrollToBottom()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        onViewDidDisappear()
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        actionBlock()
    }
    
    private func onViewAppear() {
        let data = self.dataFromLastVC as! [String: Any]
        selectedRluId = data["selectedRluId"] as! Int
        titleText = data["productNo"] as! String
        
        tblChat.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        messageViewModel = MessageViewModel(self)
        setUI()
        getAllMessagesApi()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    private func onViewDidDisappear() {
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    private func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    private func getAllMessagesApi() {
        self.messageViewModel?.getAllMessageApi(self.view, tblChat, selectedRluId, completion: { responseModel in
            self.tblChat.configuartionTableView(responseModel)
        })
    }
    
    private func setUI() {
        showNavigationBar(false)
        setcustomNav(customView: customNavBar, titleIsHidden: false, titleText: titleText, navViewColor: Colors.grey.value, mainViewColor: Colors.grey.value, backImg: Images.back.name)
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        self.txtMessage.returnKeyType = .done
        self.txtMessage.delegate = self
    }
    func containsOnlySpaces(_ textField: UITextView) -> Bool {
        let text = textField.text ?? ""
        return text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    private func actionBlock() {
        // -- Send Button
        sendBtn.actionBlock {
            guard self.txtMessage.text.count > 0, self.txtMessage.text != CommonKeys.typeMessage.name ,self.txtMessage.text != "\t",self.containsOnlySpaces(self.txtMessage) == false  else {
                let okBtn = [ButtonText.ok.text]
                UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.typeMessage.localizedDescription, buttons: okBtn, completion: nil)
                self.txtMessage.text = nil
                self.txtMessage.resignFirstResponder()
                return
            }
            
            self.sendMessageApi()
            self.txtMessage.resignFirstResponder()
            self.txtMessage.text = nil
        }
    }
    
    private func sendMessageApi() {
        self.messageViewModel?.sendMessageApi(self.view, self.tblChat, self.selectedRluId, self.txtMessage.text!, completion: { responseModel in
        })
    }
    
    // MARK: - Objc Functions
    //-- Called every time interval from the timer
    @objc func timerAction() {
        if isFetchingReq == false {
            isFetchingReq = true
            //-- Get list after refreshing
            refreshApi()
        }
    }
}

// MARK: - UITextViewDelegate
extension ChatVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

// MARK: - MessageViewModelDelegate
extension ChatVC: MessageViewModelDelegate {
    func sendMessageSuccessCalled(_ tableView: UITableView) {
        HUD.hide()
        DispatchQueue.main.async {
            print("userMsgId=======", self.tblChat.userMsgId)
            print("userRoleID=======------", LocalStore.shared.userRoleID)
            self.refreshApi()
        }
    }
    func sendMessageErrorCalled() {
        HUD.hide()
    }
    func getMessageSuccessCalled(_ tableView: UITableView) {
        HUD.hide()
        tableView.reloadData()
    }
    func getMessageErrorCalled() {
        HUD.hide()
    }
}

// MARK: - Refresh Messages Api
extension ChatVC {
    private func refreshApi() {
        
        print("self.tblChat.userMsgId>>>>********", self.tblChat.userMsgId)
        
        self.messageViewModel?.refreshMessageApi(self.tblChat, self.tblChat.userMsgId, self.selectedRluId, completion: { responseModel in
            //  self.tblChat.configuartionTableView(responseModel)
            // Need to be remove this line after testing
            // self.tblChat.tempMessagesArr.removeAll()
            print("tempMessagesArr>>>>=====", self.tblChat.tempMessagesArr)
            
            for i in 0..<responseModel.count {
                
                
                print("--------------------------------------------------------------------------------------")
                print("--------------------------------------------------------------------------------------")
                
                print("self.tblChat.userMsgId----------> ", self.tblChat.userMsgId)
                print("responseModel[i].adMsgID!----------> ", responseModel[i].adMsgID!)
                print("responseModel[i].userMsgID!----------> ", responseModel[i].userMsgID!)
                print("LocalStore.shared.userRoleID----------> ", LocalStore.shared.userRoleID)
                print("LocalStore.shared.adminLastMsgId----------> ", LocalStore.shared.adminLastMsgId)
                print("LocalStore.shared.userLastMsgId----------> ", LocalStore.shared.userLastMsgId)
                
                print("--------------------------------------------------------------------------------------")
                print("--------------------------------------------------------------------------------------")
                
                
                if LocalStore.shared.userRoleID == "Admin" {
                    
                    if responseModel[i].userType == "User" {
                        if LocalStore.shared.userLastMsgId < responseModel[i].userMsgID! {
                            self.tblChat.tempMessagesArr.append(responseModel[i])
                        }
                        if self.tblChat.userMsgId < responseModel[i].userMsgID! {
                            self.tblChat.tempMessagesArr.append(responseModel[i])
                        }
                    }
                    
                    if self.tblChat.userMsgId < responseModel[i].adMsgID! {
                        self.tblChat.tempMessagesArr.append(responseModel[i])
                    }
                } else {
                    
                    if responseModel[i].userType == "Admin" {
                        if self.tblChat.userMsgId < responseModel[i].adMsgID! {
                            self.tblChat.tempMessagesArr.append(responseModel[i])
                        }
                    }
                    
                    if self.tblChat.userMsgId < responseModel[i].userMsgID! {
                        self.tblChat.tempMessagesArr.append(responseModel[i])
                    }
                }
            }
            
            if self.tblChat.tempMessagesArr.last?.userType == "Admin" {
                self.tblChat.userMsgId = (self.tblChat.tempMessagesArr.last?.adMsgID)!
            } else {
                self.tblChat.userMsgId = (self.tblChat.tempMessagesArr.last?.userMsgID)!
            }
            LocalStore.shared.userRoleID = (self.tblChat.tempMessagesArr.last?.userType)!
            
            print("tempMessagesArr>>>>=-=-=", self.tblChat.tempMessagesArr)
            
            self.tblChat.reloadData()
            
            if responseModel.count != 0 {
                self.tblChat.scrollToBottom()
            }
            self.isFetchingReq = false
        })
    }
}
