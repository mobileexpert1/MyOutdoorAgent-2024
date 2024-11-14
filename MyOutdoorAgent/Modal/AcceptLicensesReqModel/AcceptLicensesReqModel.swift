//  AcceptLicensesReqModel.swift
//  MyOutdoorAgent
//  Created by CS on 13/09/22.

import Foundation

// MARK: - AcceptLicensesReqModel
struct AcceptLicensesReqModel : Codable {
    let message : String?
    let model : String?
    let statusCode : Int?
}
