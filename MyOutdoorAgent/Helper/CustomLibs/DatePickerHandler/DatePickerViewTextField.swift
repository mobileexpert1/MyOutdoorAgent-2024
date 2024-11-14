//  DatePickerViewTextField.swift

import Foundation
import UIKit

class DatePickerField: UITextField {
    
    // Date Picker
    let datePickerView:UIDatePicker = UIDatePicker()
    
    // ==================
    //              DATE
    // ==================
    
    func setDatePicker() {
        // Adding Date Picker
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        //        let calendar = Calendar(identifier: .gregorian)
        //        let currentDate = NSDate()
        //        let dateComponents = NSDateComponents()
        //        dateComponents.year = -5
        //        let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date)
        //        datePickerView.maximumDate = maxDate
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
        datePickerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        datePickerView.setValue(UIColor.black, forKey: "textColor")
        datePickerView.setValue(false, forKey: "highlightsToday")
        self.inputView = datePickerView
        // Adding Button ToolBar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        toolBar.backgroundColor = .clear
        toolBar.barTintColor = #colorLiteral(red: 0.1294117647, green: 0.6823529412, blue: 0.4235294118, alpha: 1)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.datePickerDone))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelBtnTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.inputAccessoryView = toolBar
    }
    // Done Button
    @objc func datePickerDone() {
        setDate()
        self.resignFirstResponder()
    }
    // Cancel button
    @objc func cancelBtnTapped() {
        self.resignFirstResponder()
    }
    // Slider Value for date
    @objc func datePickerValueChanged() {
        setDate()
    }
    // Set Date To TextField
    func setDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: datePickerView.date)
        self.text = dateStr.uppercased()
    }
}

/*
 //======================  FORMATS ======================//
 
 Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
 09/12/2018                        --> MM/dd/yyyy
 09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
 Sep 12, 2:11 PM                   --> MMM d, h:mm a
 September 2018                    --> MMMM yyyy
 Sep 12, 2018                      --> MMM d, yyyy
 Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
 2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
 12.09.18                          --> dd.MM.yy
 10:41:02.112                      --> HH:mm:ss.SSS
 10:41 AM                          --> hh:mm a
 
 //======================================================//
 */
