//  FaqModel.swift
//  MyOutdoorAgent
//  Created by CS on 14/09/22.

import UIKit

// MARK: - Section
public struct Section {
    var name: String
    var expand: Bool
    var quesCategory: [QuesCategory]
    
    public init(name: String, expand: Bool = false, quesCategory: [QuesCategory]) {
        self.name = name
        self.expand = expand
        self.quesCategory = quesCategory
    }
}

// MARK: - Question Category
public struct QuesCategory {
    var name: String
    var expand: Bool
    var ansCategory: AnsCategory
    
    public init(name: String, expand: Bool = false, ansCategory: AnsCategory) {
        self.name = name
        self.expand = expand
        self.ansCategory = ansCategory
    }
}

// MARK: - Answer Category
public struct AnsCategory {
    var name: String
    
    public init(name: String) {
        self.name = name
    }
}
