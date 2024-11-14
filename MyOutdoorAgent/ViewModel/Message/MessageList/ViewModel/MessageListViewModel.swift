//  MessageListViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import UIKit

protocol MessageListViewModelDelegate : AnyObject {
    func successCalled(_ tableView: UITableView)
    func errorCalled()
}

class MessageListViewModel {
    
    weak var delegate: MessageListViewModelDelegate?
    var myConversationsArr = [MyConversationsModelClass]()
    
    init(_ delegate: MessageListViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - My conversations Api
    func myConversationsApi(_ view: UIView, _ tableView: UITableView, completion : @escaping([MyConversationsModelClass]) -> Void) {
        ApiStore.shared.myConversationsApi(view) { responseModel in
            print(responseModel)
            if responseModel.model != nil {
                self.myConversationsArr = responseModel.model!
                self.delegate?.successCalled(tableView)
                completion(self.myConversationsArr)
            } else {
                self.delegate?.errorCalled()
            }
        }
    }
}

//MARK: - Optional Delegates Defination
extension MessageListViewModelDelegate {
    func successCalled(_ tableView: UITableView) {
    }
    func errorCalled() {
    }
}
