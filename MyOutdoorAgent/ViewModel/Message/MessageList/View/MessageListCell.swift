//  MessageListCell.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import UIKit
import PKHUD

class MessageListCell: UITableViewCell {
    
    // MARK: - Objects
    var myConversationsArr = [MyConversationsModelClass]()
    
    // MARK: - Outlets
    @IBOutlet weak var productNoLbl: UILabel!
    @IBOutlet weak var postedDateLbl: UILabel!
    @IBOutlet weak var unReadCountV: UIView!
    @IBOutlet weak var unReadMsgLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Functions
    // -- Set up delegates and datasource
    func setTableViewCell(_ tableView : UITableView, _ responseModel : [MyConversationsModelClass]) {
        tableView.delegate = self
        tableView.dataSource = self
        myConversationsArr = responseModel
    }
}

// MARK: - UITableView Datasource
extension MessageListCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myConversationsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(tableView, indexPath)
        return cell
    }
}

// MARK: - UITableView Delegates
extension MessageListCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data = [String: Any]()
        data["productNo"] = myConversationsArr[indexPath.row].productNo
        data["selectedRluId"] = myConversationsArr[indexPath.row].productID
        UIApplication.visibleViewController.pushWithData(Storyboards.chatView.name, Controllers.chat.name, data)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100
        }
        return 85
    }
}

// MARK: - ConfigureCell
extension MessageListCell {
    func configureCell(_ tableView : UITableView, _ indexPath : IndexPath) -> UITableViewCell {
        let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.messageCell.name, for: indexPath)
        guard let cell = dequeCell as? MessageListCell else { return UITableViewCell() }
        setMessageTV(cell, indexPath)
        return cell
    }
    
    func setMessageTV(_ cell :MessageListCell, _ indexPath : IndexPath) {
        cell.productNoLbl.text = myConversationsArr[indexPath.row].productNo
        cell.postedDateLbl.text = myConversationsArr[indexPath.row].postedDate
        
        if (myConversationsArr[indexPath.row].unreadCount == 0) || (myConversationsArr[indexPath.row].unreadCount == nil){
            cell.unReadCountV.isHidden = true
            cell.unReadMsgLbl.isHidden = true
        } else {
            cell.unReadCountV.isHidden = false
            cell.unReadMsgLbl.isHidden = false
            cell.unReadMsgLbl.text = String(myConversationsArr[indexPath.row].unreadCount!)
        }
    }
}
