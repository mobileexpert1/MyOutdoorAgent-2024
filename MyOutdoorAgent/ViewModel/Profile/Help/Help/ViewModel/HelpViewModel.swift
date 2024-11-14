//  HelpViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import UIKit

protocol HelpViewModelDelegate : AnyObject {
}

class HelpViewModel {
    
    weak var delegate: HelpViewModelDelegate?
}

