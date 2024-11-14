//  AvailableStatesModel.swift
//  MyOutdoorAgent
//  Created by CS on 28/09/22.

import Foundation

// MARK: - AvailableStatesModel
struct AvailableStatesModel: Codable {
    let statusCode: Int?
    let message: String?
    let model: [AvailableStatesModelClass]?
}

// MARK: - AvailableStatesModelClass
struct AvailableStatesModelClass: Codable {
    let countyID : Int?
    let countyName : String?
    let countyNameLSAD : String?
    let countyNames : String?
    let ctfips : String?
    let regionName : String?
    let state : String?
    let stateAbbrev : String?
    let stateName : String?
}
