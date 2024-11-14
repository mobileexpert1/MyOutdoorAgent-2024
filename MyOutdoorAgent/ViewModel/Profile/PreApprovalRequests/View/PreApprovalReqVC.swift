//  PreApprovalReqVC.swift
//  MyOutdoorAgent
//  Created by CS on 08/08/22.

import UIKit
import PKHUD

class PreApprovalReqVC: UIViewController {
    
    // MARK: - Objects
    private var preApprovalReqViewModel: PreApprovalReqViewModel?
    var cell = PreApprovalCVCell()
    
    // MARK: - Outlets
    @IBOutlet weak var customView: CustomNavBar!
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var noPreReqLbl: UILabel!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewAppear()
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
        registerCell()
    }
    
    private func onViewAppear() {
        setPreApprovalApi()
    }
    
    private func setPreApprovalApi() {
        collectionV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.preApprovalReqViewModel?.preApprovalReqApi(self.view, self.collectionV) { responseModel in
            self.cell.setUpCollectionCell(self.collectionV, responseModel)
        }
    }
    
    private func setUI() {
        showNavigationBar(false)
        cell.delegate = self
        setcustomNav(customView: customView, titleIsHidden: false, titleText: NavigationTitle.preApprovalRequests.name, navViewColor: Colors.grey.value, mainViewColor: Colors.grey.value, backImg: Images.back.name)
        preApprovalReqViewModel = PreApprovalReqViewModel(self)
    }
    
    private func registerCell() {
        collectionV.register(UINib(nibName: CustomCells.preApprovalCell.name, bundle: nil), forCellWithReuseIdentifier: CustomCells.preApprovalCell.name)
    }
}

// MARK: - ViewWillLayoutSubviews
extension PreApprovalReqVC {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        PreApprovalLayout().setLayout(collectionV)
    }
}

// MARK: - PreApprovalReqModelDelegate
extension PreApprovalReqVC: PreApprovalReqModelDelegate {
    func successCalled(_ collectionView: UICollectionView) {
        self.noPreReqLbl.isHidden = true
        HUD.hide()
        collectionView.reloadData()
    }
    func errorCalled() {
        HUD.hide()
        self.noPreReqLbl.isHidden = false
        cell.preApprovalReqArr.removeAll()
        collectionV.reloadData()
    }
}

// MARK: - PreApprovalCVCellDelegate
extension PreApprovalReqVC : PreApprovalCVCellDelegate {
    func returnCancelCompletion(_ listCount: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            listCount == 0
            ? (self.noPreReqLbl.isHidden = false)
            : (self.noPreReqLbl.isHidden = true)
        }
    }
}
