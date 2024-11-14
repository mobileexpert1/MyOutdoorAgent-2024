//  HomeView.swift
//  MyOutdoorAgent
//  Created by CS on 29/08/22.

import UIKit
import DropDown
import PKHUD
import IQKeyboardManager
import SafariServices

var amenitiesSearchArr = [String]()

class HomeView: UIViewController, SFSafariViewControllerDelegate {
    
    // MARK: - Objects
    var homeViewModelArr: HomeViewModel?
    var searchAutoFillModelArr = [SearchAutoFillModelClass]()
    var getAllAmenitiesModelArr = [GetAllAmenitiesModelClass]()
    var rluRegionModelArr = [SelectRegionWisePropertiesModelClass]()
    
    // MARK: - Variables
    let dropDown = DropDown()
    var amenitiesArr = [String]()
    var searchesAutoFillArr = [String]()
    var searchesAutoFillTypeArr = [String]()
    var searchName = String()
    var searchIndex = Int()
    
    // var selectedFilter = CommonKeys.west.name
    var selectedFilter = String()
    var regionArr = [String]()
    
    // MARK: - Outlets
    @IBOutlet weak var mainTopViewHeight: NSLayoutConstraint!
    @IBOutlet var homeTopV: [HomeTopView]!
    @IBOutlet weak var mainTopViewInScrollV: NSLayoutConstraint!
    @IBOutlet weak var titleCollectionV: UICollectionView!
    @IBOutlet weak var listCollectionV: UICollectionView!
    @IBOutlet weak var landOwnerV: UIView!
    @IBOutlet weak var advantureSeekerV: UIView!
    @IBOutlet weak var landOwner: UILabel!
    @IBOutlet weak var customizeOwner: UILabel!
    @IBOutlet weak var manageOwner: UILabel!
    @IBOutlet weak var landSeeker: UILabel!
    @IBOutlet weak var customizeSeeker: UILabel!
    @IBOutlet weak var manageSeeker: UILabel!
    @IBOutlet weak var noPropertyLbl: UILabel!
    @IBOutlet weak var collectionVHeight: NSLayoutConstraint!
    @IBOutlet weak var homeScrollV: UIScrollView!
    @IBOutlet weak var landOwnerImgV: UIImageView!
    @IBOutlet weak var adventureImgV: UIImageView!
    @IBOutlet weak var adventureSeekerHeight: NSLayoutConstraint!
    @IBOutlet weak var landOwnerHeight: NSLayoutConstraint!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LocalStore.shared.navigationScreen == "My Active License(s)" {
            self.tabBarController?.selectedIndex = 3
            LocalStore.shared.navigationScreen = ""
        }
        onViewAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.searchName = EMPTY_STR
    }
    
    // MARK: - UIStatusBarStyle
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.homeTopV[0].cornerView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
            self.homeTopV[1].cornerView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.setTopView()
        }
        
        HomeLayout().setLayoutListCV(listCollectionV)
        HomeLayout().setLayoutTitleCV(titleCollectionV)
    }
    
    // MARK: - UIStatusBarStyle
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        showNavigationBar(false)
    }
    
    private func onViewAppear() {
        homeScrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        titleCollectionV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        listCollectionV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        setUI()
        setDelegates()
        getAllAmenitiesApi()
        setViewUI()
        setSelectRegionApi()
        setViewAction()
        setImages()
    }
    
    private func setDelegates() {
        homeViewModelArr = HomeViewModel(self)
    }
    
    private func setUI() {
        //setTopView()
        setHeaderUI()
    }
    
    private func setImages() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            landOwnerImgV.contentMode = .scaleAspectFill
            adventureImgV.contentMode = .scaleAspectFill
        } else {
            landOwnerImgV.contentMode = .scaleAspectFill
            adventureImgV.contentMode = .scaleAspectFill
        }
    }
    
    
    private func setHeaderUI() {
        homeTopV[0].searchTxtF.text = EMPTY_STR
        homeTopV[1].searchTxtF.text = EMPTY_STR
        homeTopV[0].selectAmenityLbl.text = CommonKeys.selectAmenity.name
        homeTopV[0].selectAmenityLbl.textColor = .lightGray
        homeTopV[1].selectAmenityLbl.text = CommonKeys.selectAmenity.name
        homeTopV[1].selectAmenityLbl.textColor = .lightGray
    }
    
    private func setTopView() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let orientation = self.view.window?.windowScene?.interfaceOrientation {
                if orientation == .landscapeLeft || orientation == .landscapeRight {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.mainTopViewInScrollV.constant = 0
                        self.mainTopViewHeight.constant = 400
                        self.landOwnerHeight.constant = 220
                        self.adventureSeekerHeight.constant = 220
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.mainTopViewInScrollV.constant = 0
                        self.mainTopViewHeight.constant = 400
                        self.landOwnerHeight.constant = 280
                        self.adventureSeekerHeight.constant = 280
                    }
                }
            }
            
            
        } else {
            if let orientation = self.view.window?.windowScene?.interfaceOrientation {
                if orientation == .landscapeLeft || orientation == .landscapeRight {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.mainTopViewInScrollV.constant = 370
                        self.homeTopV[1].userNameTop.constant = 30
                        self.homeTopV[1].homeTopVHeight.constant = 140
                        self.mainTopViewHeight.constant = 0
                        self.landOwnerHeight.constant = 150
                        self.adventureSeekerHeight.constant = 150
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.mainTopViewInScrollV.constant = 0
                        self.mainTopViewHeight.constant = 400
                        self.landOwnerHeight.constant = 240
                        self.adventureSeekerHeight.constant = 240
                    }
                }
            }
            
            
            
            //            if (UIDevice.current.orientation.isLandscape) {
            //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            //                    self.mainTopViewInScrollV.constant = 370
            //                    self.homeTopV[1].userNameTop.constant = 30
            //                    self.homeTopV[1].homeTopVHeight.constant = 140
            //                    self.mainTopViewHeight.constant = 0
            //                }
            //            } else {
            //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            //                    self.mainTopViewInScrollV.constant = 0
            //                    self.mainTopViewHeight.constant = 400
            //                }
            //            }
        }
    }
    
    private func registerCell() {
        self.titleCollectionV.register(UINib.init(nibName: CustomCells.homeTitleCollVCell.name, bundle: nil), forCellWithReuseIdentifier: CustomCells.homeTitleCollVCell.name)
        self.listCollectionV.register(UINib.init(nibName: CustomCells.homeListCVCell.name, bundle: nil), forCellWithReuseIdentifier: CustomCells.homeListCVCell.name)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    private func setViewAction() {
        // -- Landowner
        landOwnerV.actionBlock {
            //let url = URL(string: "https://demov2.myoutdooragent.com/#/app/listyourproperty?reload=true")!
            //            let url = URL(string: "https://myoutdooragent.com/#/app/listyourproperty")!
            //            let controller = SFSafariViewController(url: url)
            //            self.present(controller, animated: true, completion: nil)
            //            controller.delegate = self
            self.pushOnly(Storyboards.choosePlanView.name, Controllers.choosePlanVC.name, true)
        }
        
        // -- Adventure Seekers
        advantureSeekerV.actionBlock {
            self.pushOnly(Storyboards.faqView.name, Controllers.faq.name, true)
        }
        
        homeTopV[0].searchTxtF.delegate = self
        homeTopV[1].searchTxtF.delegate = self
        
        // -- Set User Name
        if LocalStore.shared.name == "" {
            homeTopV[0].userNameLbl.text = "Guest"
            homeTopV[1].userNameLbl.text = "Guest"
        } else {
            homeTopV[0].userNameLbl.text = LocalStore.shared.name
            homeTopV[1].userNameLbl.text = LocalStore.shared.name
        }
        
        // -- Select an Item View
        homeTopV[0].selectAmenityV.actionBlock {
            self.homeTopV[0].searchTxtF.resignFirstResponder()
            
            DropDownHandler.shared.showDropDownWithItems(self.homeTopV[0].selectAmenityV, self.amenitiesArr, self.homeTopV[0].selectAmenityImgV, "No Amenity Available")
            DropDownHandler.shared.itemPickedBlock = { (index, item) in
                
                self.homeTopV[0].selectAmenityImgV.image = Images.downArrow.name
                self.homeTopV[0].selectAmenityLbl.text = item
                self.homeTopV[0].selectAmenityLbl.textColor = .black
            }
            
            DropDownHandler.shared.cancelActionBlock = {
                self.homeTopV[0].selectAmenityImgV.image = Images.downArrow.name
            }
        }
        
        homeTopV[1].selectAmenityV.actionBlock {
            self.homeTopV[1].searchTxtF.resignFirstResponder()
            
            DropDownHandler.shared.showDropDownWithItems(self.homeTopV[1].selectAmenityV, self.amenitiesArr, self.homeTopV[1].selectAmenityImgV, "No Amenity Available")
            DropDownHandler.shared.itemPickedBlock = { (index, item) in
                self.homeTopV[1].selectAmenityImgV.image = Images.downArrow.name
                self.homeTopV[1].selectAmenityLbl.text = item
                self.homeTopV[1].selectAmenityLbl.textColor = .black
            }
            
            DropDownHandler.shared.cancelActionBlock = {
                self.homeTopV[1].selectAmenityImgV.image = Images.downArrow.name
            }
        }
        
        // -- Search Button
        homeTopV[0].searchView.actionBlock {
            if self.homeTopV[0].selectAmenityLbl.text != CommonKeys.selectAmenity.name {
                amenitiesSearchArr.append(self.homeTopV[0].selectAmenityLbl.text!)
            }

            self.homeViewModelArr?.searchApi(self.view, stateName: [], regionName: [LocalStore.shared.regionSearchName], propertyName: [LocalStore.shared.rluSearchName], freeText: [LocalStore.shared.freeTextSearchName], county: [LocalStore.shared.countySearchName], rlu: [LocalStore.shared.rluSearchName], amenities: amenitiesSearchArr, rluAcresMin: 0, rluAcresMax: 0, priceMin: 0, priceMax: 0, productTypeId: 0, order: EMPTY_STR, sort: EMPTY_STR, pageNumber: 1, completion: { responseModel in
            })
        }
        
        // -- Search Button
        homeTopV[1].searchView.actionBlock {
            if self.homeTopV[1].selectAmenityLbl.text != CommonKeys.selectAmenity.name {
                amenitiesSearchArr.append(self.homeTopV[1].selectAmenityLbl.text!)
            }
            
            self.homeViewModelArr?.searchApi(self.view, stateName: [], regionName: [LocalStore.shared.regionSearchName], propertyName: [LocalStore.shared.rluSearchName], freeText: [LocalStore.shared.freeTextSearchName], county: [LocalStore.shared.countySearchName], rlu: [LocalStore.shared.rluSearchName], amenities: amenitiesSearchArr, rluAcresMin: 0, rluAcresMax: 0, priceMin: 0, priceMax: 0, productTypeId: 0, order: EMPTY_STR, sort: EMPTY_STR, pageNumber: 1, completion: { responseModel in
            })
        }
    }
    
    // MARK: - Observer
    // -- Add observer to set collectionView height according to content
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observedObject = object as? UICollectionView, observedObject == self.listCollectionV {
            if self.rluRegionModelArr[titleCollectionV.tag].rLURegionModel?.count == 0 {
                collectionVHeight.constant = 100
                self.noPropertyLbl.isHidden = false
                self.noPropertyLbl.text = "There is no property in this region"
            } else {
                self.noPropertyLbl.isHidden = true
                self.collectionVHeight.constant = self.listCollectionV.contentSize.height
            }
            self.listCollectionV?.removeObserver(self, forKeyPath: CommonKeys.contentSize.name)
        }
    }
    
    private func setViewUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.landOwner.attributedText = self.getAttributedBoldString(str : CommonKeys.landStr.name, boldTxt : CommonKeys.listYourLandBold.name)
            self.customizeOwner.attributedText = self.getAttributedBoldString(str: CommonKeys.customizeStr.name, boldTxt: CommonKeys.customizeBold.name)
            self.manageOwner.attributedText = self.getAttributedBoldString(str: CommonKeys.manageStr.name, boldTxt: CommonKeys.manageBold.name)
            self.landSeeker.attributedText = self.getAttributedBoldString(str : CommonKeys.findReserveSeekerStr.name, boldTxt : CommonKeys.findReserveSeekerBold.name)
            self.customizeSeeker.attributedText = self.getAttributedBoldString(str: CommonKeys.customizeSeekerStr.name, boldTxt: CommonKeys.customizeBold.name)
            self.manageSeeker.attributedText = self.getAttributedBoldString(str: CommonKeys.manageSeekerStr.name, boldTxt: CommonKeys.manageBold.name)
        }
    }
    
    private func getAttributedBoldString(str : String, boldTxt : String) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString.init(string: str)
        let boldedRange = NSRange(str.range(of: boldTxt)!, in: str)
        
        UIDevice.current.userInterfaceIdiom == .phone
        ? attrStr.addAttributes([NSAttributedString.Key.font: UIFont(name: Fonts.nunitoSansBold.name, size:12)!], range: boldedRange)
        : attrStr.addAttributes([NSAttributedString.Key.font: UIFont(name: Fonts.nunitoSansBold.name, size:18)!], range: boldedRange)
        
        return attrStr
    }
    
    private func setSelectRegionApi() {
        self.homeViewModelArr?.selectRegionwiseProperties(self.view, completion: { responseModel in
            print(responseModel)
            
            self.rluRegionModelArr = responseModel
            
            if responseModel.count != 0 {
                self.regionArr.removeAll()
                for i in 0..<responseModel.count {
                    self.regionArr.append(self.rluRegionModelArr[i].regionName!)
                }
                self.titleCollectionV.dataSource = self
                self.titleCollectionV.delegate = self
                self.listCollectionV.delegate = self
                self.listCollectionV.dataSource = self
                self.registerCell()
                self.listCollectionV.reloadData()
                self.titleCollectionV.reloadData()
                self.selectedFilter = self.regionArr[0]
                self.titleCollectionV.tag = 0
                self.listCollectionV?.addObserver(self, forKeyPath: CommonKeys.contentSize.name, options: NSKeyValueObservingOptions.new, context: nil)
            }
        })
    }
    
    // MARK: - Web Service
    func getAllAmenitiesApi() {
        self.homeViewModelArr?.getAllAmenitiesApi(self.view, completion: { responseModel in
            self.getAllAmenitiesModelArr = responseModel
            self.amenitiesArr.removeAll()
            for i in 0..<self.getAllAmenitiesModelArr.count {
                self.amenitiesArr.append(self.getAllAmenitiesModelArr[i].amenityName!)
            }
        })
    }
}

// MARK: - ViewWillTransition
extension HomeView {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard tabBarController?.selectedIndex == 0 else { return }
        homeScrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        setViewUI()
        self.listCollectionV?.addObserver(self, forKeyPath: CommonKeys.contentSize.name, options: NSKeyValueObservingOptions.new, context: nil)
        setTableViewSize(size)
    }
    
    private func setTableViewSize(_ size: CGSize) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            if (UIDevice.current.orientation == .landscapeLeft) || (UIDevice.current.orientation == .landscapeRight) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.mainTopViewInScrollV.constant = 0
                    self.mainTopViewHeight.constant = 400
                    self.landOwnerHeight.constant = 220
                    self.adventureSeekerHeight.constant = 220
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.mainTopViewInScrollV.constant = 0
                    self.mainTopViewHeight.constant = 400
                    self.landOwnerHeight.constant = 280
                    self.adventureSeekerHeight.constant = 280
                }
            }
            
            
        } else {
            if (UIDevice.current.orientation == .landscapeLeft) || (UIDevice.current.orientation == .landscapeRight) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.mainTopViewInScrollV.constant = 370
                    self.homeTopV[1].userNameTop.constant = 30
                    self.homeTopV[1].homeTopVHeight.constant = 140
                    self.mainTopViewHeight.constant = 0
                    self.landOwnerHeight.constant = 150
                    self.adventureSeekerHeight.constant = 150
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.mainTopViewInScrollV.constant = 0
                    self.mainTopViewHeight.constant = 400
                    self.landOwnerHeight.constant = 240
                    self.adventureSeekerHeight.constant = 240
                }
            }
            
            self.homeTopV[0].searchTxtF.text = EMPTY_STR
            self.homeTopV[1].searchTxtF.text = EMPTY_STR
        }
    }
}

//MARK: - Optional Delegates Defination
extension HomeView: HomeViewModelDelegate {
    func allAmenitiesSuccessCalled() {
        HUD.hide()
    }
    func allAmenitiesErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    func searchSuccessCalled() {
        HUD.hide()
        
        //        print("searchName>>>", self.searchName)
        //
        //        if self.searchName != "" {
        //            print("searchIndex>>>", self.searchIndex)
        //            if self.searchesAutoFillTypeArr[self.searchIndex] == "County" {
        //                LocalStore.shared.countySearchName = self.searchName
        //            } else if self.searchesAutoFillTypeArr[self.searchIndex] == "RLU" {
        //                LocalStore.shared.rluSearchName = self.searchName
        //            } else if self.searchesAutoFillTypeArr[self.searchIndex] == "Region"{
        //                LocalStore.shared.regionSearchName = self.searchName
        //            } else {
        //                LocalStore.shared.propertySearchName = self.searchName
        //            }
        //        }
        //
        //        self.homeTopV[0].searchTxtF.resignFirstResponder()
        //        self.homeTopV[1].searchTxtF.resignFirstResponder()
        tabBarController?.selectedIndex = 1
    }
    func searchErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    func searchAutoSuccessCalled() {
        HUD.hide()
    }
    func searchAutoErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    func regionSuccessCalled() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            HUD.hide()
            self.titleCollectionV.reloadData()
            self.listCollectionV.reloadData()
        }
    }
    func regionErrorCalled() {
        HUD.hide()
    }
}

// MARK: - UICollectionView DataSource
extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == titleCollectionV {
            return regionArr.count
        } else {
            return self.rluRegionModelArr[titleCollectionV.tag].rLURegionModel!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == titleCollectionV {
            let titleCell = configureTitleCell(collectionView, indexPath)
            return titleCell
        } else {
            let listCell = configureListCell(collectionView, indexPath)
            return listCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == titleCollectionV {
            selectedFilter = regionArr[indexPath.row]
            titleCollectionV.tag = indexPath.row
            titleCollectionV.reloadData()
            listCollectionV.reloadData()
            HomeLayout().setLayoutListCV(listCollectionV)
            HomeLayout().setLayoutTitleCV(titleCollectionV)
            self.listCollectionV?.addObserver(self, forKeyPath: CommonKeys.contentSize.name, options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    
    private func configureTitleCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let dequeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCells.homeTitleCollVCell.name, for: indexPath)
        guard let cell = dequeCell as? HomeTitleCollVCell else { return UICollectionViewCell() }
        setTitleViewAction(cell, indexPath)
        return cell
    }
    
    private func configureListCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let dequeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCells.homeListCVCell.name, for: indexPath)
        guard let cell = dequeCell as? HomeListCVCell else { return UICollectionViewCell() }
        setListViewAction(cell, indexPath)
        return cell
    }
    
    private func setTitleViewAction(_ cell: HomeTitleCollVCell, _ indexPath: IndexPath) {
        cell.titleLbl.text = regionArr[indexPath.row]
        if regionArr[indexPath.row] == selectedFilter {
            cell.contentView.backgroundColor = Colors.green.value
            cell.titleLbl.textColor = .white
        } else {
            cell.contentView.backgroundColor = .white
            cell.titleLbl.textColor = .black
        }
    }
    
    private func setListViewAction(_ cell: HomeListCVCell, _ indexPath: IndexPath) {
        cell.displayNameLbl.text = self.rluRegionModelArr[titleCollectionV.tag].rLURegionModel![indexPath.row].displayName
        
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            switch UIDevice.current.orientation {
//            case .landscapeLeft, .landscapeRight:
//                cell.regionNameHeight.constant = 15
//            default:
//                cell.regionNameHeight.constant = 30
//            }
//        } else {
//            cell.regionNameHeight.constant = 15
//        }
        
        cell.locationLbl.text = self.rluRegionModelArr[titleCollectionV.tag].rLURegionModel![indexPath.row].location
        // -- Set Image
        if self.rluRegionModelArr[titleCollectionV.tag].rLURegionModel![indexPath.row].imageFileName == nil {
            cell.regionImgV.image = Images.logoImg.name
        } else {
            var str = (Apis.rluImageUrl) + self.rluRegionModelArr[titleCollectionV.tag].rLURegionModel![indexPath.row].imageFileName!
            if let dotRange = str.range(of: "?") {
                str.removeSubrange(dotRange.lowerBound..<str.endIndex)
                
                str.contains(" ")
                ? cell.regionImgV.setNetworkImage(cell.regionImgV, str.replacingOccurrences(of: " ", with: "%20"))
                : cell.regionImgV.setNetworkImage(cell.regionImgV, str)
                
            } else {
                str.contains(" ")
                ? cell.regionImgV.setNetworkImage(cell.regionImgV, str.replacingOccurrences(of: " ", with: "%20"))
                : cell.regionImgV.setNetworkImage(cell.regionImgV, str)
            }
        }
        
        // -- View Details Button
        cell.viewDetailsV.actionBlock {
            var data = [String: Any]()
            data["publicKey"] = self.rluRegionModelArr[self.titleCollectionV.tag].rLURegionModel![indexPath.row].publicKey
            data["id"] = self.rluRegionModelArr[self.titleCollectionV.tag].rLURegionModel![indexPath.row].productID
            LocalStore.shared.selectedPropertyIndex = self.tabBarController!.selectedIndex
            isComingFrom = "other"
            UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
        }
    }
}

// MARK: - UICollectionView Delegates
extension HomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - UICollectionView Delegate FlowLayout
extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == titleCollectionV {
            let size = HomeLayout().setTitleCollectionLayout(collectionView, collectionViewLayout)
            return size
        }
        let listSize = HomeLayout().setListCollectionLayout(collectionView, collectionViewLayout)
        return listSize
    }
}

// MARK: - UITextFieldDelegate
extension HomeView:  UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Verify all the conditions
        if let sdcTextField = textField as? TextFieldInset {
            return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
        }
        
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            
            LocalStore.shared.rluSearchName = EMPTY_STR
            LocalStore.shared.countySearchName = EMPTY_STR
            LocalStore.shared.regionSearchName = EMPTY_STR
            LocalStore.shared.propertySearchName = EMPTY_STR
            LocalStore.shared.freeTextSearchName = EMPTY_STR
            amenitiesSearchArr.removeAll()
            
            if ((txtAfterUpdate) != EMPTY_STR) {
                self.homeViewModelArr?.searchAutoFillApi(self.view, txtAfterUpdate, completion: { responseModel in
                    self.searchAutoFillModelArr = responseModel
                    
                    self.searchesAutoFillArr.removeAll()
                    self.searchesAutoFillTypeArr.removeAll()
                    for i in 0..<self.searchAutoFillModelArr.count {
                        self.searchesAutoFillArr.append(self.searchAutoFillModelArr[i].searchResult!)
                        self.searchesAutoFillTypeArr.append(self.searchAutoFillModelArr[i].type!)
                    }
                    
                    LocalStore.shared.freeTextSearchName = txtAfterUpdate
                    
                    if self.mainTopViewHeight.constant != 0 {
                        self.setSearchTxtF(textField)
                    }
                    
                    if self.mainTopViewInScrollV.constant != 0 {
                        self.setSearchTxtFinScrollV(textField)
                    }
                })
            }
        }
        return true
    }
    
    private func setSearchTxtF(_ textField: UITextField) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            DropDownHandler.shared.cancelActionBlock = {
            }
            
            DropDownHandler.shared.showDropDownWithOutIcon(self.homeTopV[0].searchTxtV, self.searchesAutoFillArr, self.homeTopV[0].searchTxtV)
            DropDownHandler.shared.itemPickedBlock = { (index, item) in
                textField.text = item
                //self.searchName = item
                //self.searchIndex = index
                //                if self.searchName != "" {
                //                    textField.text = self.searchName
                //                }
                LocalStore.shared.freeTextSearchName = EMPTY_STR
                
                if self.searchesAutoFillTypeArr[index] == "County" {
                    LocalStore.shared.countySearchName = textField.text!
                } else if self.searchesAutoFillTypeArr[index] == "RLU" {
                    LocalStore.shared.rluSearchName = textField.text!
                } else if self.searchesAutoFillTypeArr[index] == "Region"{
                    LocalStore.shared.regionSearchName = textField.text!
                } else {
                    LocalStore.shared.propertySearchName = textField.text!
                }
                
                self.homeTopV[0].searchTxtF.resignFirstResponder()
            }
        }
    }
    
    private func setSearchTxtFinScrollV(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            DropDownHandler.shared.cancelActionBlock = {
            }
            DropDownHandler.shared.showDropDownWithOutIcon(self.homeTopV[1].searchTxtV, self.searchesAutoFillArr, self.homeTopV[1].searchTxtV)
            DropDownHandler.shared.itemPickedBlock = { (index, item) in
                textField.text = item
                //  self.searchName = item
                //  if self.searchName != "" {
                //      textField.text = self.searchName
                //  }
                LocalStore.shared.freeTextSearchName = EMPTY_STR
                
                if self.searchesAutoFillTypeArr[index] == "County" {
                    LocalStore.shared.countySearchName = textField.text!
                } else if self.searchesAutoFillTypeArr[index] == "RLU" {
                    LocalStore.shared.rluSearchName = textField.text!
                } else if self.searchesAutoFillTypeArr[index] == "Region"{
                    LocalStore.shared.regionSearchName = textField.text!
                } else {
                    LocalStore.shared.propertySearchName = textField.text!
                }
                
                self.homeTopV[1].searchTxtF.resignFirstResponder()
            }
        }
    }
}

