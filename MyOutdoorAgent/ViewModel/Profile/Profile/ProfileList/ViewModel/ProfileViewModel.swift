//  ProfileViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 19/08/22.

import UIKit

protocol ProfileViewModelDelegate : AnyObject {
}
 
class ProfileViewModel {
    
    weak var delegate: ProfileViewModelDelegate?
}
