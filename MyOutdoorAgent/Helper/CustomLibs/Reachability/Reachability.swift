//  Reachability.swift
//  MyOutdoorAgent
//  Created by CS on 22/08/22.

import UIKit
import Alamofire

class Reachability {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
