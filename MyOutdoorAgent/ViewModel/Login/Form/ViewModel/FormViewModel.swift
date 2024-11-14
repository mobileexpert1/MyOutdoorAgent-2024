//  FormViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 23/08/22.

import UIKit

protocol FormViewModelDelegate : AnyObject {
}

class FormViewModel {
    
    weak var delegate: FormViewModelDelegate?
}
