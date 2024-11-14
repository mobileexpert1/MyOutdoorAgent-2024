//  SubmitPreApprovalReqModel.swift
//  MyOutdoorAgent
//  Created by CS on 26/10/22.

import Foundation

// MARK: - SubmitPreApprovalReqModel
struct SubmitPreApprovalReqModel : Codable {
    let message : String?
    let model : String?
    let statusCode : Int?
}
