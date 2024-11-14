//  ChatCell.swift
//  MyOutdoorAgent
//  Created by CS on 11/10/22.

import UIKit

class ChatDetailsTableView: UITableView {
    
    // MARK: - Objects
    var getMessagesArr = [GetAllMessagesModelClass]()
    var tempMessagesArr = [GetAllMessagesModelClass]()
    
    // MARK: - Variables
    var userMsgId = Int()
    
    // MARK: - AwakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Configure TableView
    func configuartionTableView(_ responseModel : [GetAllMessagesModelClass]) {
        self.register(UINib(nibName: CustomCells.messageSendTableViewCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.messageSendTableViewCell.name)
        self.register(UINib(nibName: CustomCells.messageTableViewCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.messageTableViewCell.name)
        self.dataSource = self
        self.delegate = self
        getMessagesArr = responseModel
        
        tempMessagesArr = getMessagesArr
        
        getMessagesArr.last?.userMsgID == 0
        ? (userMsgId = (getMessagesArr.last?.adMsgID)!)
        : (userMsgId = (getMessagesArr.last?.userMsgID)!)
        
        var tempAdminMsgIds = [Int]()
        for msg in getMessagesArr where msg.userType == "Admin" {
            tempAdminMsgIds.append(msg.adMsgID!)
        }
        LocalStore.shared.adminLastMsgId = tempAdminMsgIds.last ?? 0
        
        var tempUserMsgIds = [Int]()
        for msg in getMessagesArr where msg.userType == "User" {
            tempUserMsgIds.append(msg.userMsgID!)
        }
        LocalStore.shared.userLastMsgId = tempUserMsgIds.last ?? 0
        
        LocalStore.shared.userRoleID = (getMessagesArr.last?.userType!)!
        
        self.estimatedRowHeight = 44
        self.rowHeight = UITableView.automaticDimension
        self.reloadData()
        self.scrollToBottom()
    }
}

// MARK: - UITableView Datasource
extension ChatDetailsTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempMessagesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tempMessagesArr[indexPath.row].userType != "Admin" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCells.messageSendTableViewCell.name) as? MessageSendTableViewCell else {
                return UITableView.emptyCell()
            }
            setUserTV(cell, indexPath)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCells.messageTableViewCell.name) as? MessageTableViewCell else {
                return UITableView.emptyCell()
            }
            setAdminTV(cell, indexPath)
            return cell
        }
    }
    
    func setUserTV(_ cell: MessageSendTableViewCell, _ indexPath: IndexPath) {
        if tempMessagesArr[indexPath.row].messageText != nil {
            cell.lblMessage.text = tempMessagesArr[indexPath.row].messageText!
        }
        let postedUserDate = (cell.lblDate.text?.setDate(tempMessagesArr[indexPath.row].postedDate!, "dd MMM yyyy, h:mm", "M/d/yyyy h:mm:ss a"))! //24 Nov 2022, 1:30
        cell.lblDate.text = postedUserDate
    }
    
    func setAdminTV(_ cell: MessageTableViewCell, _ indexPath: IndexPath) {
        if tempMessagesArr[indexPath.row].messageText != nil {
            cell.lblMessage.text = tempMessagesArr[indexPath.row].messageText!
        }
        let postedAdminDate = (cell.lblDate.text?.setDate(tempMessagesArr[indexPath.row].postedDate!, "dd MMM yyyy, h:mm", "M/d/yyyy h:mm:ss a"))!
        cell.lblDate.text = postedAdminDate
    }
}

// MARK: - UITableView Delegate
extension ChatDetailsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
