//  GetAvailableCountyByStatesModel.swift
//  MyOutdoorAgent
//  Created by CS on 29/10/22.

import Foundation

// MARK: - GetAvailableCountyByStatesModel
struct GetAvailableCountyByStatesModel: Codable {
    let statusCode: Int
    let message: String
    let model: [GetAvailableCountyByStatesClass]
}

// MARK: - GetAvailableCountyByStatesClass
struct GetAvailableCountyByStatesClass: Codable {
    let countyID: Int
    let countyName: String
    let countyNameLSAD, stateName, state, stateAbbrev: String?
    let ctfips: String
    let regionName, countyNames: String?
}
