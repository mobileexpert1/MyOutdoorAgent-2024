//  HelpVC.swift
//  MyOutdoorAgent
//  Created by CS on 05/08/22

import UIKit

class HelpVC: UIViewController {
    
    // MARK: - Objects
    var cell = HelpTblVCell()
    
    // MARK: - Outlets
    @IBOutlet weak var customNavBar: CustomNavBar!
    @IBOutlet weak var helpTblV: UITableView!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        helpTblV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        cell.setUpTableCell(helpTblV)
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
    }
    
    private func setUI() {
        showNavigationBar(false)
        setcustomNav(customView: customNavBar, titleIsHidden: false, titleText: NavigationTitle.help.name, navViewColor: Colors.grey.value, mainViewColor: Colors.grey.value, backImg: Images.back.name)
    }
}


