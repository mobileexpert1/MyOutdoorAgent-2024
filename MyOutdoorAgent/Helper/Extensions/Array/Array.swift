//  Array.swift
//  MyOutdoorAgent
//  Created by CS on 21/09/22.

import Foundation

extension Array {
    mutating func remove(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            remove(at: index)
        }
    }
}
