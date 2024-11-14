//  MessageViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 11/10/22.

import UIKit

protocol MessageViewModelDelegate : AnyObject {
    func sendMessageSuccessCalled(_ tableView: UITableView)
    func sendMessageErrorCalled()
    func getMessageSuccessCalled(_ tableView: UITableView)
    func getMessageErrorCalled()
}

class MessageViewModel {
    
    weak var delegate: MessageViewModelDelegate?
    var messagesArr : SendMessageModel?
    var getMessagesArr = [GetAllMessagesModelClass]()
    
    init(_ delegate: MessageViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Send Message Api
    func sendMessageApi(_ view: UIView, _ tableView: UITableView, _ productID: Int, _ messageText: String, completion : @escaping(SendMessageModel) -> Void) {
        ApiStore.shared.sendMessageApi(view, productID, messageText) { responseModel in
            print(responseModel)
            if responseModel?.model != nil {
                self.messagesArr = responseModel
                self.delegate?.sendMessageSuccessCalled(tableView)
                completion(self.messagesArr!)
            } else {
                self.delegate?.sendMessageErrorCalled()
            }
        }
    }
    
    // MARK: - Get All Message Api
    func getAllMessageApi(_ view: UIView, _ tableView: UITableView, _ productID: Int, completion : @escaping([GetAllMessagesModelClass]) -> Void) {
        ApiStore.shared.getAllMessageApi(view, productID) { responseModel in
            if responseModel.model != nil {
                self.getMessagesArr = responseModel.model!
                self.delegate?.getMessageSuccessCalled(tableView)
                completion(self.getMessagesArr)
            } else {
                self.delegate?.getMessageErrorCalled()
            }
        }
    }
    
    // MARK: - Refresh Message Api
    func refreshMessageApi(_ tableView: UITableView, _ userMsgID: Int, _ productID: Int, completion : @escaping([GetAllMessagesModelClass]) -> Void) {
        ApiStore.shared.refreshMessageApi(userMsgID, productID) { responseModel in
            if responseModel.model != nil {
                self.getMessagesArr = responseModel.model!
                self.delegate?.getMessageSuccessCalled(tableView)
                print(responseModel.model?.last)
                completion(self.getMessagesArr)
            } else {
                self.delegate?.getMessageErrorCalled()
            }
        }
    }
}

//MARK: - Optional Delegates Defination
extension MessageViewModelDelegate {
    func sendMessageSuccessCalled(_ tableView: UITableView) {
    }
    func sendMessageErrorCalled() {
    }
    func getMessageSuccessCalled(_ tableView: UITableView) {
    }
    func getMessageErrorCalled() {
    }
}
