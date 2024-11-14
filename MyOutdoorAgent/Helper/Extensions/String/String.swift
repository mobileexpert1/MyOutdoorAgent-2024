//  String.swift
//  MyOutdoorAgent
//  Created by CS on 02/09/22.

import UIKit

extension String {
    
    func date(_ format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = Calendar.current
     //   dateFormatter.timeZone = TimeZone.current // Assuming you have a case called utc in your TimeZone enum
        return dateFormatter.date(from: self)!
    }
    
    static func isNilOrEmpty(_ string:String?) -> Bool { //  returns false if passed string is nil or empty
        if string == nil {
            return true
        }
        return string!.isEmpty
    }
    
    // -- Display date in "st" , "nd", "rd" and "th" format
    func setDateFormat(_ dateStr: String, _ month: String, _ day: String, _ year: String) -> String {
        if dateStr == "" || dateStr == nil {
            
        } else {
            let date = dateStr
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let convertDate = dateFormatter.date(from: date as String)
            
            // Use this to add st, nd, th, to the day
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .ordinal
            numberFormatter.locale = Locale.current
            
            // Set month
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = month
            
            // Set day
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = day
            
            // Set year
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = year
            
            if convertDate != nil {
                let dayString = dayFormatter.string(from: convertDate!)
                let monthString = monthFormatter.string(from: convertDate!)
                let yearString = yearFormatter.string(from: convertDate!)
                
                // Add the suffix to the day
                let dayNumber = NSNumber(value: Int(dayString)!)
                let day = numberFormatter.string(from: dayNumber)!
                
                return "\(monthString) \(day) \(yearString)"
            }
            
            return ""
        }
        return ""
    }
    
    // -- Display date without "st" , "nd", "rd" and "th" format  //2022-11-24 01:27:00.870
    func setDate(_ dateStr: String, _ dateFormat: String, _ oldDateFormat: String) -> String {
        if dateStr == "" || dateStr == nil {
            
        } else {
            let date = dateStr
            print(dateStr)
           
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = oldDateFormat
            dateFormatter.locale = Locale(identifier: "en_EN")
            let convertDate = dateFormatter.date(from: date as String)
            
            // Set month
            let convertDateFormatter = DateFormatter()
            convertDateFormatter.dateFormat = dateFormat
            convertDateFormatter.locale = Locale(identifier: "en_EN")
            
            if convertDate != nil {
                print("convertDate>>==", convertDate)
                let dateString = convertDateFormatter.string(from: convertDate!)
                print("dateString>>===", dateString)
                return "\(dateString)"
            }
            return ""
        }
        return ""
    }
    
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
}

/*
 //======================  FORMATS ======================//
 
 7/5/2022 6:42:49 AM
 
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
