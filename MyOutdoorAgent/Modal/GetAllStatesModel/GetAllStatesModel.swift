//  GetAllStatesModel.swift
//  MyOutdoorAgent
//  Created by CS on 22/09/22.

import Foundation

// MARK: - GetAllStatesModel
struct GetAllStatesModel : Codable {
    let message : String?
    let model : [GetAllStatesModelClass]?
    let statusCode : Int?
}

// MARK: - GetAllStatesModelClass
struct GetAllStatesModelClass: Codable {
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
