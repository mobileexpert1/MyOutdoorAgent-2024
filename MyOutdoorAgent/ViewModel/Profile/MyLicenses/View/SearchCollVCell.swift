//  SearchCollVCell.swift
//  MyOutdoorAgent
//  Created by CS on 05/08/22.

import UIKit
import PKHUD

protocol ActiveLicenseCellDelegate : AnyObject {
    func returnActiveViewCompletion(_ agreementName: String, _ licenseContractID: Int)
    func returnPendingViewCompletion(_ agreementName: String, _ licenseContractID: Int, _ userAccountID: Int)
}

class SearchCollVCell: UICollectionViewCell {
    
    // MARK: - Objects
    private var myLicensesViewModel: MyLicensesViewModel?
    var activeLicensesArr = [ActiveMemeberPendindCombimeModelClass]()
    var memberLicensesArr = [ActiveMemeberPendindCombimeModelClass]()
    var pendingLicensesArr = [ActiveMemeberPendindCombimeModelClass]()
    var expiredLicensesArr = [ExpiredLicensesModelClass]()
    var viewTag = Int()
    var acceptLicenseView = AcceptLicensePDFView()
    weak var delegate : ActiveLicenseCellDelegate?
    var allLicense = [ActiveMemeberPendindCombimeModelClass]()
    
    // MARK: - Outlets
    @IBOutlet weak var topHeaderV: UIImageView!
    @IBOutlet weak var mainImgV: UIImageView!
    @IBOutlet weak var mainBtn: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var licenseLbl: UILabel!
    @IBOutlet weak var acreLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var mainBtnView: UIView!
    @IBOutlet weak var contactLblHeight: NSLayoutConstraint!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLblHeight: NSLayoutConstraint!
    @IBOutlet weak var topImgWidth: NSLayoutConstraint!
    @IBOutlet weak var topImgHeight: NSLayoutConstraint!
    @IBOutlet weak var topImgLeading: NSLayoutConstraint!
    @IBOutlet weak var topImgTop: NSLayoutConstraint!
    @IBOutlet weak var titleLblHeight: NSLayoutConstraint!
    @IBOutlet weak var descLblHeight: NSLayoutConstraint!
    @IBOutlet weak var dateHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Functions
    // -- Set up delegates and datasource
    func setUpActiveCollectionCell(_ collection : UICollectionView, _ responseModel : [ActiveMemeberPendindCombimeModelClass], _ tag : Int) {
        
        allLicense.removeAll()
        allLicense.append(contentsOf: responseModel)
        activeLicensesArr = responseModel
//        collection.delegate = self
//        collection.dataSource = self
        viewTag = 1
    }
    
    func setUpMemberCollectionCell(_ collection : UICollectionView, _ responseModel : [ActiveMemeberPendindCombimeModelClass], _ tag : Int) {
        
        allLicense.append(contentsOf: responseModel)
        memberLicensesArr = responseModel
//        collection.delegate = self
//        collection.dataSource = self
        viewTag = 1
    }
    
    func setUpPendingCollectionCell(_ collection : UICollectionView, _ responseModel : [ActiveMemeberPendindCombimeModelClass], _ tag : Int) {
        
        allLicense.append(contentsOf: responseModel)
        pendingLicensesArr = responseModel
        collection.delegate = self
        collection.dataSource = self
        viewTag = 1
    }
    
    func setUpExpiredCollectionCell(_ collection : UICollectionView, _ responseModel : [ExpiredLicensesModelClass], _ tag : Int) {
        collection.delegate = self
        collection.dataSource = self
        expiredLicensesArr = responseModel
        viewTag = tag
    }
}

// MARK: - UICollectionViewDelegates and UICollectionViewDatasource
extension SearchCollVCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewTag {
//        case 0: // -- Active Licenses
//            return activeLicensesArr.count
        case 1:
            print("allLicense.count",allLicense.count)
            return allLicense.count
//        case 2:
//            return pendingLicensesArr.count
        default:
            return expiredLicensesArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = configureCell(collectionView, indexPath)
        return cell
    }
}

// MARK: - ConfigureCell
extension SearchCollVCell {
    func configureCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> UICollectionViewCell {
        let dequeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollVCell", for: indexPath)
        guard let cell = dequeCell as? SearchCollVCell else { return UICollectionViewCell() }
        
        cell.contactLbl.isHidden = true
        /*
         If productTypeID - 2 >>> PERMIT
         If productTypeID - 1 >>> RLU
         */
        switch viewTag {
            
     //   case 0: // -- Active Licenses
            
        case 1: // -- Member Licenses
          
                
            if indexPath.row <=  activeLicensesArr.count - 1 {
                setViews(cell, allLicense, indexPath)
            } else if indexPath.row <=  activeLicensesArr.count + memberLicensesArr.count - 1 {
                MemberLicensesCell().setView(cell, allLicense, indexPath)
            } else {
                setView(cell, allLicense, indexPath)
            }
             
           
        //case 2: // -- Pending Licenses
            
        default: // -- Expired Licenses
            ExpiredLicensesCell().setView(cell, expiredLicensesArr, indexPath)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchCollVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            print("running on iPhone")
            if UIDevice.current.orientation == .landscapeLeft {
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.height + 50)
            } else if UIDevice.current.orientation == .landscapeRight {
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.height + 50)
            } else if UIDevice.current.orientation == .portrait {
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2+100)
            } else if UIDevice.current.orientation == .portraitUpsideDown {
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2+100)
            } else {
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2+100)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            print("iPad")
            if UIDevice.current.orientation == .landscapeLeft {
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.height - 100)
            } else if UIDevice.current.orientation == .landscapeRight {
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.height - 100)
            } else if UIDevice.current.orientation == .portrait {
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2+60)
            } else if UIDevice.current.orientation == .portraitUpsideDown {
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2+60)
            } else {
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2+60)
            }
        }
        
        collectionViewLayout.invalidateLayout()
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
