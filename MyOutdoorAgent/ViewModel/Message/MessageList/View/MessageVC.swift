//  MessageView.swift
//  MyOutdoorAgent
//  Created by CS on 01/08/22.

import UIKit
import PKHUD

class MessageVC: UIViewController {
    
    // MARK: - Objects
    var cell = MessageListCell()
    private var messageViewModel: MessageListViewModel?
    
    // MARK: - Outlets
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var noPropertyFoundLbl: UILabel!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        onViewAppear()
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
        setDelegates()
    }
    
    private func onViewAppear() {
        setTableV()
    }
    
    private func setUI() {
        showNavigationBar(false)
    }
    
    private func setDelegates() {
        messageViewModel = MessageListViewModel(self)
    }
    
    private func setTableV() {
        tableV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.messageViewModel?.myConversationsApi(view, tableV, completion: { responseModel in
            self.cell.setTableViewCell(self.tableV, responseModel)
        })
    }
}

// MARK: - MessageViewModelDelegate
extension MessageVC: MessageListViewModelDelegate {
    func successCalled(_ tableView: UITableView) {
        HUD.hide()
        tableView.reloadData()
    }
    func errorCalled() {
        HUD.hide()
        cell.myConversationsArr.count == 0
        ? (noPropertyFoundLbl.isHidden = false)
        : (noPropertyFoundLbl.isHidden = true)
    }
}
