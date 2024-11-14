//  DropDown.swift

/* ---- TO USE THIS :
 
 anyTextField.actionBlock {
 DropDownHandler.shared.showDropDownWithItems(self.uiview, ["item-1", "item-2"])
 DropDownHandler.shared.itemPickedBlock = { (index, item) in
 print("selected item is :::  ", item)
 }
 DropDownHandler.shared.cancelActionBlock = {
 print("cancelActionBlock")
 }
 DropDownHandler.shared.willShowActionBlock = {
 print("willShowActionBlock")
 }
 }*/

import Foundation
import UIKit
import DropDown

class DropDownHandler: NSObject{
    
    //MARK: - Shared Instance
    static let shared = DropDownHandler()
    
    //MARK: - Variables
    let buttonDropDown = DropDown()
    
    //MARK: - Internal Properties
    var itemPickedBlock: ((Int, String) -> Void)?
    var cancelActionBlock : (() -> Void)?
    var willShowActionBlock : (() -> Void)?
    
    //MARK: - Show DropDown with Arrow Image
    func showDropDownWithItems(_ sender: UIView, _ items: [String], _ arrowImg: UIImageView, _ message: String) {
        // -- DropDown
        buttonDropDown.dataSource = items
        buttonDropDown.anchorView = sender
        
        if items.count == 0 {
            arrowImg.image = Images.upArrow.name
            let okBtn = [ButtonText.ok.text]
            UIAlertController.showAlert(EMPTY_STR, message: message, buttons: okBtn) { alert, index in
                if index == 0 {
                    arrowImg.image = Images.downArrow.name
                }
            }
        } else {
            arrowImg.image = Images.upArrow.name
        }
        buttonDropDown.backgroundColor = Colors.offWhite.value
        buttonDropDown.animationduration = 0.5
        buttonDropDown.selectionBackgroundColor = Colors.green.value
        buttonDropDown.selectedTextColor = .white
        buttonDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        
        UIDevice.current.userInterfaceIdiom == .phone
        ? (buttonDropDown.textFont = UIFont(name: Fonts.nunitoSansRegular.name, size: 15)!)
        : (buttonDropDown.textFont = UIFont(name: Fonts.nunitoSansRegular.name, size: 19)!)
        
        buttonDropDown.show()
        buttonDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        buttonDropDown.selectionAction = { (index: Int, item: String) in
            self.itemPickedBlock?(index, item)
        }
        
        buttonDropDown.cancelAction = { [unowned self] in
            self.cancelActionBlock?()
        }
        
        buttonDropDown.willShowAction = { [unowned self] in
            self.willShowActionBlock?()
        }
    }
    
    //MARK: - Show DropDown without Arrow Image
    func showDropDownWithOutIcon(_ sender: UIView, _ items: [String], _ mainView: UIView) {
        // -- DropDown
        buttonDropDown.dataSource = items
        buttonDropDown.anchorView = mainView
        buttonDropDown.backgroundColor = Colors.offWhite.value
        buttonDropDown.animationduration = 0.5
        buttonDropDown.selectionBackgroundColor = Colors.green.value
        buttonDropDown.selectedTextColor = .white
        buttonDropDown.bottomOffset = CGPoint(x: 0, y: mainView.frame.size.height)
        
        UIDevice.current.userInterfaceIdiom == .phone
        ? (buttonDropDown.textFont = UIFont(name: Fonts.nunitoSansRegular.name, size: 15)!)
        : (buttonDropDown.textFont = UIFont(name: Fonts.nunitoSansRegular.name, size: 19)!)
        
        buttonDropDown.show()
        buttonDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        buttonDropDown.selectionAction = { (index: Int, item: String) in
            self.itemPickedBlock?(index, item)
        }
        
        buttonDropDown.cancelAction = { [unowned self] in
            self.cancelActionBlock?()
        }
        
        buttonDropDown.willShowAction = { [unowned self] in
            self.willShowActionBlock?()
        }
    }
}
