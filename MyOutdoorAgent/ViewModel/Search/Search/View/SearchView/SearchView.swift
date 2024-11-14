//  SearchView.swift
//  MyOutdoorAgent
//  Created by CS on 01/08/22.

import UIKit
import DropDown
import PKHUD
import GoogleMaps
import MapKit
import GoogleMapsUtils

var isComingFrom = String()

class SearchView: AbstractView {
    
    // MARK: - Objects
    var searchViewModelArr: SearchViewModel?
    var availableStatesModelArr = [AvailableStatesModelClass]()
    var searchAutoFillModelArr = [SearchAutoFillModelClass]()
    var cell = AmenitiesCVCell()
    
    // MARK: - Variables
    var debounceTimer: Timer?
    var statesArr = [String]()
    var statesAbbrArr = [String]()
    var countiesArr = [String]()
    var permitsHandler = false
    var rluHandler = false
    var updatedText = String()
    var selectedStatesArr = [String]()
    var selectedCountiesNameArr = [String]()
    var freeTextArr = [String]()
    var amenitiesArr = [String]()
    var searchesAutoFillArr = [String]()
    var searchesAutoFillTypeArr = [String]()
    var searchesRLUArr = [String]()
    var searchesCountyArr = [String]()
    var searchesRegionArr = [String]()
    var searchesPropertyArr = [String]()
    var rluAcresMin = 0
    var rluAcresMax = 0
    var minPrice = 0
    var maxPrice = 0
    var productTypeId = 0
    var selectedItem = "list"
    var locationManager = CLLocationManager()
    var centerMapCoordinate: CLLocationCoordinate2D!
    var listArr = [SearchHomeModelClass]()
    var amenityArr = [[String]]()
    var okBtn = [ButtonText.ok.text]
    var currentZoom: Float = 15
    let marker = GMSMarker()
    var coordinateMultiplygonArr = [Double]()
    var coordinatePointArr = [[Double]]()
    var accessPointArr = [[Double]]()
    var stateMapArr = [[[Double]]]()
    var accessPointGateTypeArr = [String]()
    var accessPointMarkers: [GMSMarker] = []
    var coordinatePolyArr = [[Coordinate]]()
    var isLicensedArr = [Int]()
    var isLicensedPolyArr = [Int]()
    var isLicensedMultiPolyArr = [Int]()
    var productNo = String()
    var isLicensed = Int()
    var zoom = true
    var latitude = Double()
    var longitude = Double()
    var clusterManager: GMUClusterManager!
    var lat = Double()
    var long = Double()
    var clusterArr = [[Double]]()
    var polyArr : PolyModel?
    var mapModel : PointModel?
    var acessPoint : AcessPointModel?
    var permitShapesData : PermitShapesModel?
    var nonMotorizedArr : NonMotorizedModel?
    let specificLabelMarker = GMSMarker()
    var isChanged = Bool()
    var isPositionChanged = Bool()
    var pageCount = 1
    var isLoadingList = false
    var allMarker: [GMSMarker] = []
    var pathLine = GMSMutablePath()
    var polygon: GMSPolygon!
    var linePolygon: GMSPolyline!
    var rectanglePath = GMSMutablePath()
    var polygons: [GMSPolyline] = []
    var multtipolygons: [GMSPolygon] = []
    var multtipolygons2: [GMSPolyline] = []
    var polygonsPermit: [GMSPolyline] = []
    var oneTime = 0
    var polygonPoints: [CLLocationCoordinate2D] = []
    let polygonLine = GMSPolyline()
    var labelMarkers: [GMSMarker] = []
    var labelMarkers2: [GMSMarker] = []
    var labelMarkersPermit: [GMSMarker] = []
    var hasCalledGenerateClusterItems = false
    var zoomChangeTimer: Timer?
    var lastZoomLevel: Float = 0
    var polygonData: [String: UIColor] = [:]
    var statesAbbrName = String()
    var addedMarkersCount = 0
    var isFirstClusterGeneration = true // Track if it's the first call
    
    
    // MARK: - Outlets
    @IBOutlet weak var filterPopUpV: FilterView!
    @IBOutlet weak var activitiesCV: UICollectionView!
    @IBOutlet weak var amenitiesCV: UICollectionView!
    @IBOutlet weak var searchTopView: SearchTopView!
    @IBOutlet weak var searchTopViewInScrollV: SearchTopView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapImgV: UIImageView!
    @IBOutlet weak var noPropertyLbl: UILabel!
    @IBOutlet weak var changeFilterLbl: UILabel!
    @IBOutlet weak var resetFilterLbl: UILabel!
    @IBOutlet weak var reloadBtn: UIImageView!
    @IBOutlet weak var mainTopViewInScrollVHeight: NSLayoutConstraint!
    @IBOutlet weak var mainTopViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchScrollV: UIScrollView!
    @IBOutlet weak var bottomV: UIView!
    @IBOutlet weak var searchTV: UITableView!
    @IBOutlet weak var tableVHeight: NSLayoutConstraint!
    @IBOutlet weak var mapV: UIView!
    @IBOutlet weak var hybridV: UIView!
    @IBOutlet weak var zoomInV: UILabel!
    @IBOutlet weak var zoomOutV: UILabel!
    @IBOutlet weak var mapHybridView: UIStackView!
    @IBOutlet weak var zoomView: UIView!
    @IBOutlet weak var hybridLbl: UILabel!
    @IBOutlet var mapDetailPopUpV: MapDetailPopUpView!
    @IBOutlet weak var mapLbl: UILabel!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageCount = 1
        print("LIST COUNT ",listArr.count)
   //     scrollToTop()
        print("cell.selectedAmenitiesArr",cell.selectedAmenitiesArr)
//        cell.selectedAmenitiesArr
       listArr.removeAll()
        searchTV.reloadData()
        onViewAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
   //     listArr.removeAll()
        onViewDidDisappear()
    }
    
    // MARK: - ViewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.searchTopView.cornerV.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20.0)
            self.searchTopViewInScrollV.cornerV.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20.0)
        }
        self.setTopView()
    }
    
    // MARK: - UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        HUD.show(.progress, onView: self.view)
        setUI()
        setDelegates()
        accessPintApiCall()
        permitShapesApiCall()
        nonMotorizedApiCall()
        setPointLayer()
    //  searchTV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        showNavigationBar(false)
    }
    
    private func onViewAppear() {
       // availableStatesApi()
        setViewWithoutScrollV()
        if isComingFrom == "map" {
            self.searchTopView.toggleBtn.image = Images.list.name
            self.selectedItem = "map"
            self.searchTV.isHidden = true
            self.noPropertyLbl.isHidden = true
            self.changeFilterLbl.isHidden = true
            self.resetFilterLbl.isHidden = true
            self.reloadBtn.isHidden = true
            self.mapView.isHidden = false
            self.zoomView.isHidden = false
            self.mapHybridView.isHidden = false
          //  self.setMapView()
            self.isChanged = true
            
            self.isPositionChanged = true
        } else {
            
            setListViewInScrollV()
            setListViewInMainV()
        }
        self.removeViewWithDuration(self.mapDetailPopUpV, 0.1)
        self.cell.selectedAmenitiesArr.removeAll()
        searchScrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        setUI()
        setDelegates()
        
        searchTV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        setViewWithScrollV()
        self.filterPopUpV.filterScrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        setMapActions()
        self.searchTV.rowHeight = UITableView.automaticDimension
        self.searchTV.estimatedRowHeight = 44
        
        
        DispatchQueue.main.async {
            self.listViewApi(stateName: [], regionName: [LocalStore.shared.regionSearchName], propertyName: [LocalStore.shared.rluSearchName], freeText: [LocalStore.shared.freeTextSearchName], county: [LocalStore.shared.countySearchName], rlu: [LocalStore.shared.rluSearchName], amenities: amenitiesSearchArr, rluAcresMin: 0, rluAcresMax: 0, priceMin: 0, priceMax: 0, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: 1)
        }
        setMapV()
//        accessPintApiCall()
//        permitShapesApiCall()
//        nonMotorizedApiCall()
//        setPointLayer()
    }
    
    private func setMapV() {
        self.mapView.mapType = .normal
        self.mapLbl.textColor = .black
        self.hybridLbl.textColor = .darkGray
    
           
    }
    
    private func onViewDidDisappear() {
        searchesRegionArr.removeAll()
        searchesPropertyArr.removeAll()
        freeTextArr.removeAll()
        searchesCountyArr.removeAll()
        searchesRLUArr.removeAll()
        amenitiesSearchArr.removeAll()
        listArr.removeAll()
    }
    
    private func setDelegates() {
        searchViewModelArr = SearchViewModel(self)
    }
    
    private func setUI() {
        setHeaderUI()
        setFilterV()
    }
    
    private func setFilterV() {
        self.filterPopUpV.maxAcresTxtF.text = EMPTY_STR
        self.filterPopUpV.minAcresTxtF.text = EMPTY_STR
        self.filterPopUpV.minPriceTxtF.text = EMPTY_STR
        self.filterPopUpV.maxPriceTxtF.text = EMPTY_STR
        self.activitiesCV.reloadData()
        self.amenitiesCV.reloadData()
    }
    
    private func setHeaderUI() {
        // -- Search View Without ScrollView
        searchTopView.searchTxtF.text = EMPTY_STR
        self.filterPopUpV.selectStateLbl.text = CommonKeys.selectState.name
        self.filterPopUpV.selectStateLbl.textColor = .lightGray
        self.filterPopUpV.selectCountyLbl.text = CommonKeys.selectCounty.name
        self.filterPopUpV.selectCountyLbl.textColor = .lightGray
        // -- Search View With ScrollView
        searchTopViewInScrollV.searchTxtF.text = EMPTY_STR
        setToggleBtn()
    }
    
    private func setToggleBtn() {
        if self.selectedItem == "list" {
            searchTopView.toggleBtn.image = Images.map.name
            searchTopViewInScrollV.toggleBtn.image = Images.map.name
        } else {
            searchTopView.toggleBtn.image = Images.list.name
            searchTopViewInScrollV.toggleBtn.image = Images.list.name
        }
        
        searchTopView.toggleBtn.actionBlock { [self] in
            if self.searchTopView.toggleBtn.image == Images.map.name {
                self.searchTopView.toggleBtn.image = Images.list.name
               // self.setPointLayer()
                self.selectedItem = "map"
                self.searchTV.isHidden = true
                self.noPropertyLbl.isHidden = true
                self.changeFilterLbl.isHidden = true
                self.resetFilterLbl.isHidden = true
                self.reloadBtn.isHidden = true
                self.mapView.isHidden = false
                self.zoomView.isHidden = false
                self.mapHybridView.isHidden = false
                self.setMapView()
                self.isChanged = true
                self.isPositionChanged = true
                 isFirstClusterGeneration = true
            } else {
                self.searchTopView.toggleBtn.image = Images.map.name
                self.setListViewInMainV()
            }
        }
        
        searchTopViewInScrollV.toggleBtn.actionBlock { [self] in
            if self.searchTopViewInScrollV.toggleBtn.image == Images.map.name {
                self.searchTopViewInScrollV.toggleBtn.image = Images.list.name
                self.selectedItem = "map"
              //  self.setPointLayer()
                self.searchTV.isHidden = true
                self.noPropertyLbl.isHidden = true
                self.changeFilterLbl.isHidden = true
                self.resetFilterLbl.isHidden = true
                self.reloadBtn.isHidden = true
                self.mapView.isHidden = false
                self.zoomView.isHidden = false
                self.mapHybridView.isHidden = false
                self.setMapView()
                 isFirstClusterGeneration = true
            } else {
                self.searchTopViewInScrollV.toggleBtn.image = Images.map.name
                self.setListViewInScrollV()
            }
        }
    }
    
    
    
    
    
    private func setView(_ scaleX: CGFloat, _ y: CGFloat) {
        self.searchTopViewInScrollV.toggleBtn.transform = CGAffineTransform(scaleX: scaleX, y: y)
        self.searchTopView.toggleBtn.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
    
    private func setTopView() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.searchTopViewInScrollV.isHidden = true
            self.mainTopViewInScrollVHeight.constant = 0
            self.mainTopViewHeight.constant = 150
        } else {
            if let orientation = self.view.window?.windowScene?.interfaceOrientation {
                if orientation == .landscapeLeft || orientation == .landscapeRight {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.searchTopViewInScrollV.isHidden = false
                        self.searchTopViewInScrollV.searchTopV.constant = 30
                        self.searchTopViewInScrollV.searchMainVHeight.constant = 100
                        self.mainTopViewInScrollVHeight.constant = 100
                        self.mainTopViewHeight.constant = 0
                    }
                } else {
                    self.mainTopViewInScrollVHeight.constant = 0
                    self.searchTopViewInScrollV.isHidden = true
                    self.mainTopViewHeight.constant = 140
                }
            }
        }
    }
    
    private func registerCell() {
        activitiesCV.register(UINib(nibName: CustomCells.amenitiesCVCell.name, bundle: nil), forCellWithReuseIdentifier: CustomCells.amenitiesCVCell.name)
        amenitiesCV.register(UINib(nibName: CustomCells.amenitiesCVCell.name, bundle: nil), forCellWithReuseIdentifier: CustomCells.amenitiesCVCell.name)
    }
    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        searchTV.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    // MARK: - Set Top View Without Scroll View
    func setViewWithoutScrollV() {
        searchTopView.searchTxtF.delegate = self
        
        // -- Select States
        self.filterPopUpV.selectStateV.actionBlock {
            self.searchTopView.searchTxtF.resignFirstResponder()
            self.selectedStatesArr.removeAll()
            self.selectedCountiesNameArr.removeAll()
            self.countiesArr.removeAll()
            self.filterPopUpV.selectCountyLbl.text = "Select County"
            self.filterPopUpV.selectCountyLbl.textColor = .lightGray
            
            DropDownHandler.shared.showDropDownWithItems(self.filterPopUpV.selectStateV, self.statesArr, self.filterPopUpV.selectStateArrowV, "No State Available")
            DropDownHandler.shared.itemPickedBlock = { [self] (index, item) in
                self.filterPopUpV.selectStateArrowV.image = Images.downArrow.name
                self.filterPopUpV.selectStateLbl.text = item
                print("statesAbbrArr",statesAbbrArr[index])
                statesAbbrName = statesAbbrArr[index]
                self.selectedStatesArr.append(item)
                self.filterPopUpV.selectStateLbl.textColor = .black
                
                self.searchViewModelArr?.getAvailableCountyByStateApi(self.view, stateAbbr: self.statesAbbrArr[index], completion: { responseModel in
                    // print(responseModel.model)
                    self.filterPopUpV.selectCountyLbl.text = "Select County"
                    self.filterPopUpV.selectCountyLbl.textColor = .lightGray
                    
                    if responseModel.model.count != 0 {
                        self.countiesArr.removeAll()
                        for i in 0..<responseModel.model.count {
                            self.countiesArr.append(responseModel.model[i].countyName)
                        }
                    }
                })
               
//                listArr.removeAll()
//                searchTV.reloadData()
//                listViewApi(stateName: self.selectedStatesArr, regionName: [], propertyName: [], freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
            }
            
            DropDownHandler.shared.cancelActionBlock = {
                self.filterPopUpV.selectStateArrowV.image = Images.downArrow.name
            }
        }
        
        // -- Select County
        self.filterPopUpV.selectCountyV.actionBlock {
            self.searchTopView.searchTxtF.resignFirstResponder()
            self.selectedCountiesNameArr.removeAll()
            
            DropDownHandler.shared.showDropDownWithItems(self.filterPopUpV.selectCountyV, self.countiesArr, self.filterPopUpV.countyArrowV, "No County Available")
            DropDownHandler.shared.itemPickedBlock = { [self] (index, item) in
                self.filterPopUpV.countyArrowV.image = Images.downArrow.name
                self.filterPopUpV.selectCountyLbl.text = item
                self.selectedCountiesNameArr.append(item)
                self.filterPopUpV.selectCountyLbl.textColor = .black
//                listArr.removeAll()
//                searchTV.reloadData()
//                self.listViewApi(stateName: self.selectedStatesArr, regionName: [], propertyName: [], freeText: [], county: self.selectedCountiesNameArr, rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
            }
            
            DropDownHandler.shared.cancelActionBlock = {
                self.filterPopUpV.countyArrowV.image = Images.downArrow.name
            }
        }
        
        self.searchTopView.sortByV.actionBlock {
            self.showSortByV(self.searchTopView.sortByV)
        }
        
        self.searchTopViewInScrollV.sortByV.actionBlock {
            self.showSortByV(self.searchTopViewInScrollV.sortByV)
        }
        
        // -- Filter
        self.searchTopView.filterView.actionBlock { [self] in
            print("cell.selectedAmenitiesArr",cell.selectedAmenitiesArr)
            
            availableStatesApi()
            
            self.viewTransition(self.filterPopUpV)
            self.setFilterView()
        }
        
        // -- Permit
        self.filterPopUpV.permitsImgV.actionBlock { [self] in
            self.searchViewModelArr?.handleCheckBox(handler: &(self.permitsHandler), checkBox: &(self.filterPopUpV.permitsImgV))
            
           
            
            self.removeView(self.filterPopUpV)
            
            if self.permitsHandler == false {
                listArr.removeAll()
                searchTV.reloadData()
                self.listViewApi(stateName: [], regionName: [], propertyName: [], freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                self.productTypeId = 0
            } else if ((self.permitsHandler == true) && (self.rluHandler == true)) || ((self.permitsHandler == false) && (self.rluHandler == false)) {
                listArr.removeAll()
                searchTV.reloadData()
                self.listViewApi(stateName: [], regionName: [], propertyName: [], freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                self.productTypeId = 0
            }
            else {
                listArr.removeAll()
                searchTV.reloadData()
                self.listViewApi(stateName: [], regionName: [], propertyName: [], freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 1, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                self.productTypeId = 1
            }
        }
        
        // -- RUL
        self.filterPopUpV.rulImgV.actionBlock { [self] in
            self.searchViewModelArr?.handleCheckBox(handler: &(self.rluHandler), checkBox: &(self.filterPopUpV.rulImgV))
            
          
            
            self.removeView(self.filterPopUpV)
            
            if self.rluHandler == false {
                listArr.removeAll()
                searchTV.reloadData()
                self.listViewApi(stateName: self.selectedStatesArr, regionName: [], propertyName: [], freeText: [], county: self.freeTextArr, rlu: [], amenities: self.cell.selectedAmenitiesArr, rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                self.productTypeId = 0
            } else if ((self.permitsHandler == true) && (self.rluHandler == true)) || ((self.permitsHandler == false) && (self.rluHandler == false)) {
                listArr.removeAll()
                searchTV.reloadData()
                self.listViewApi(stateName: [], regionName: [], propertyName: [], freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                self.productTypeId = 0
            } else {
                listArr.removeAll()
                searchTV.reloadData()
                self.listViewApi(stateName: self.selectedStatesArr, regionName: [], propertyName: [], freeText: [], county: self.freeTextArr, rlu: [], amenities: self.cell.selectedAmenitiesArr, rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 2, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                self.productTypeId = 2
            }
        }
    }
    
    func showSortByV(_ btn: UIView) {
        UIAlertController.showActionSheet(btn, "Sort By", cancelButtonTitle: "Cancel", destructiveButtonTitle: EMPTY_STR, otherButtonTitles: sortByArr) { [self] alert, index in
            if index == 1 {
                listArr.removeAll()
                searchTV.reloadData()
                self.listViewApi(stateName: self.selectedStatesArr, regionName: self.searchesRegionArr, propertyName: self.searchesPropertyArr, freeText: self.freeTextArr, county: self.searchesCountyArr, rlu: self.searchesRLUArr, amenities: self.cell.selectedAmenitiesArr, rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: self.productTypeId, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
            } else if index == 2 {
                listArr.removeAll()
                searchTV.reloadData()
                self.listViewApi(stateName: self.selectedStatesArr, regionName: self.searchesRegionArr, propertyName: self.searchesPropertyArr, freeText: self.freeTextArr, county: self.searchesCountyArr, rlu: self.searchesRLUArr, amenities: self.cell.selectedAmenitiesArr, rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: self.productTypeId, order: "desc", sort: "Price", pageNumber: pageCount)
            } else if index == 3 {
                listArr.removeAll()
                searchTV.reloadData()
                self.listViewApi(stateName: self.selectedStatesArr, regionName: self.searchesRegionArr, propertyName: self.searchesPropertyArr, freeText: self.freeTextArr, county: self.searchesCountyArr, rlu: self.searchesRLUArr, amenities: self.cell.selectedAmenitiesArr, rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: self.productTypeId, order: "asc", sort: "Price", pageNumber: pageCount)
            } else if index == 4 {
                listArr.removeAll()
                searchTV.reloadData()
                self.listViewApi(stateName: self.selectedStatesArr, regionName: self.searchesRegionArr, propertyName: self.searchesPropertyArr, freeText: self.freeTextArr, county: self.searchesCountyArr, rlu: self.searchesRLUArr, amenities: self.cell.selectedAmenitiesArr, rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: self.productTypeId, order: "desc", sort: "Acres", pageNumber: pageCount)
            } else if index == 5 {
                listArr.removeAll()
                searchTV.reloadData()
                self.listViewApi(stateName: self.selectedStatesArr, regionName: self.searchesRegionArr, propertyName: self.searchesPropertyArr, freeText: self.freeTextArr, county: self.searchesCountyArr, rlu: self.searchesRLUArr, amenities: self.cell.selectedAmenitiesArr, rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: self.productTypeId, order: "asc", sort: "Acres", pageNumber: pageCount)
            }
        }
    }
    
    // MARK: - Set Top View With Scroll View
    func setViewWithScrollV() {
        searchTopViewInScrollV.searchTxtF.delegate = self
        
        // -- Filter
        self.searchTopViewInScrollV.filterView.actionBlock {
            self.viewTransition(self.filterPopUpV)
            self.setFilterView()
        }
    }
    
    // MARK: - SetFilterView
    private func setFilterView() {
        // -- Check Empty Textfields
        if (self.filterPopUpV.minAcresTxtF.text!).isEmpty {
            self.rluAcresMin = 0
        } else {
            let acreMin = Int(self.filterPopUpV.minAcresTxtF.text!)
            if let text = acreMin {
                self.rluAcresMin = text
            }
        }
        
        if (self.filterPopUpV.maxAcresTxtF.text!).isEmpty {
            self.rluAcresMax = 0
        } else {
            let acreMax = Int(self.filterPopUpV.maxAcresTxtF.text!)
            if let text = acreMax {
                self.rluAcresMax = text
            }
        }
        
        if (self.filterPopUpV.minPriceTxtF.text!).isEmpty {
            self.minPrice = 0
        } else {
            let minPrice = Int(self.filterPopUpV.minPriceTxtF.text!)
            if let text = minPrice {
                self.minPrice = text
            }
        }
        
        if (self.filterPopUpV.maxPriceTxtF.text!).isEmpty {
            self.maxPrice = 0
        } else {
            let maxPrice = Int(self.filterPopUpV.maxPriceTxtF.text!)
            if let text = maxPrice {
                self.maxPrice = text
            }
        }
        
        self.filterPopUpV.crossBtn.actionBlock {
            self.setFilterV()
            self.removeView(self.filterPopUpV)
        }
        
//        self.filterPopUpV.saveSearchV.actionBlock { [self] in
//            if LocalStore.shared.userId == EMPTY_STR {
//                self.loginAlert()
//            } else {
//                if self.cell.selectedAmenitiesArr.count == 0 {
//                    UIAlertController.showAlert(AppAlerts.alert.title, message: AppAlerts.selectSearch.title, buttons: self.okBtn, completion: nil)
//                } else {
//                    self.searchViewModelArr?.saveSearchApi(self.view, self.selectedStatesArr, [], [], [], self.freeTextArr, [], self.cell.selectedAmenitiesArr, self.rluAcresMin , self.rluAcresMax, self.minPrice, self.maxPrice, LocalStore.shared.userAccountId, EMPTY_STR, EMPTY_STR, pageCount, EMPTY_STR, completion: { responseModel  in
//                    })
//                }
//            }
//        }
        
        self.filterPopUpV.searchV.actionBlock { [self] in
            setFilterView()
            print("productTypeId",productTypeId)
            if self.productTypeId == 1 {
                listArr.removeAll()
               // self.setMapView()
             

                self.searchViewModelArr?.selectedSateMap(self.view, rluName: statesAbbrName, completion: { [self] responseModel in
                    print("responseModel", responseModel)
                    stateMapArr.removeAll()
                    
                    responseModel.features?.forEach { feature in
                        if let coordinates = feature.geometry?.coordinates {
                            switch coordinates {
                            case .twoDimensional(let coords):
                                // Append the two-dimensional coordinates directly
                                stateMapArr.append(contentsOf: coords)
                                
                            case .fourDimensional(let coords):
                                // If you need to flatten or select a specific level of the four-dimensional coordinates
                                if let firstPolygon = coords.first {
                                    stateMapArr.append(contentsOf: firstPolygon)
                                }
                            }
                        }
                    }
                    
                    self.setStateZoom(coordinates: stateMapArr)
                })

               // searchTV.reloadData()
                self.listViewApi(stateName: self.selectedStatesArr, regionName: self.searchesRegionArr, propertyName: self.searchesPropertyArr, freeText: self.freeTextArr, county: self.selectedCountiesNameArr, rlu: self.searchesRLUArr, amenities: self.cell.selectedAmenitiesArr, rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: self.productTypeId, order: EMPTY_STR, sort: "New Releases", pageNumber: 1)
            } else if self.productTypeId == 2 {
                listArr.removeAll()
              //  self.setMapView()
                self.searchViewModelArr?.selectedSateMap(self.view, rluName: statesAbbrName, completion: { [self] responseModel in
                    print("responseModel", responseModel)
                    stateMapArr.removeAll()
                    
                    responseModel.features?.forEach { feature in
                        if let coordinates = feature.geometry?.coordinates {
                            switch coordinates {
                            case .twoDimensional(let coords):
                                // Append the two-dimensional coordinates directly
                                stateMapArr.append(contentsOf: coords)
                                
                            case .fourDimensional(let coords):
                                // If you need to flatten or select a specific level of the four-dimensional coordinates
                                if let firstPolygon = coords.first {
                                    stateMapArr.append(contentsOf: firstPolygon)
                                }
                            }
                        }
                    }
                    
                    self.setStateZoom(coordinates: stateMapArr)
                })

                //searchTV.reloadData()
                self.listViewApi(stateName: self.selectedStatesArr, regionName: self.searchesRegionArr, propertyName: self.searchesPropertyArr, freeText: self.freeTextArr, county: self.selectedCountiesNameArr, rlu: self.searchesRLUArr, amenities: self.cell.selectedAmenitiesArr, rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: self.productTypeId, order: EMPTY_STR, sort: "New Releases", pageNumber: 1)
            } else {
                listArr.removeAll()
              //  self.setMapView()
                self.searchViewModelArr?.selectedSateMap(self.view, rluName: statesAbbrName, completion: { [self] responseModel in
                    print("responseModel", responseModel)
                    stateMapArr.removeAll()
                    
                    responseModel.features?.forEach { feature in
                        if let coordinates = feature.geometry?.coordinates {
                            switch coordinates {
                            case .twoDimensional(let coords):
                                // Append the two-dimensional coordinates directly
                                stateMapArr.append(contentsOf: coords)
                                
                            case .fourDimensional(let coords):
                                // If you need to flatten or select a specific level of the four-dimensional coordinates
                                if let firstPolygon = coords.first {
                                    stateMapArr.append(contentsOf: firstPolygon)
                                }
                            }
                        }
                    }
                    
                    self.setStateZoom(coordinates: stateMapArr)
                })

                //searchTV.reloadData()
                print("minPrice",minPrice)
                print("maxPrice",maxPrice)
                print("rluAcresMax",rluAcresMax)
                print("rluAcresMin",rluAcresMin)
                self.listViewApi(stateName: self.selectedStatesArr, regionName: self.searchesRegionArr, propertyName: self.searchesPropertyArr, freeText: self.freeTextArr, county: self.selectedCountiesNameArr, rlu: self.searchesRLUArr, amenities: self.cell.selectedAmenitiesArr, rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: 1)
            }
        }
        
        self.filterPopUpV.reloadBtn.actionBlock { [self] in
            selectedStatesArr.removeAll()
            countiesArr.removeAll()
            self.filterPopUpV.maxAcresTxtF.text = EMPTY_STR
            self.filterPopUpV.minAcresTxtF.text = EMPTY_STR
            self.filterPopUpV.minPriceTxtF.text = EMPTY_STR
            self.filterPopUpV.maxPriceTxtF.text = EMPTY_STR
            self.filterPopUpV.selectStateLbl.text = "Select State"
            self.filterPopUpV.selectCountyLbl.text = "Select County"
            self.filterPopUpV.selectStateLbl.textColor = .lightGray
            self.filterPopUpV.selectCountyLbl.textColor = .lightGray
            statesAbbrName = ""
            
            self.cell.selectedAmenitiesArr.removeAll()
            self.listViewApi(stateName: [], regionName: [], propertyName: [], freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: 0, rluAcresMax: 0, priceMin: 0, priceMax: 0, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: 1)
            self.setFilterV()
        }
    }
    
    @objc func textFieldDidChangedInScrollV(_ textField: UITextField) {
        self.searchesRLUArr.removeAll()
        self.searchesPropertyArr.removeAll()
        self.searchesRegionArr.removeAll()
        self.searchesCountyArr.removeAll()
        self.freeTextArr.removeAll()
        if (textField.text) != EMPTY_STR {
            self.searchViewModelArr?.searchAutoFillApi(self.view, textField.text!, completion: { [self] responseModel in
                self.searchAutoFillModelArr = responseModel
                print("searchAutoFillModelArr",searchAutoFillModelArr)
                self.searchesAutoFillArr.removeAll()
                self.searchesAutoFillTypeArr.removeAll()
                for i in 0..<self.searchAutoFillModelArr.count {
                    self.searchesAutoFillArr.append(self.searchAutoFillModelArr[i].searchResult!)
                    self.searchesAutoFillTypeArr.append(self.searchAutoFillModelArr[i].type!)
                }
            })
            
            self.freeTextArr.append(textField.text!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                DropDownHandler.shared.showDropDownWithOutIcon(self.searchTopViewInScrollV.searchV, self.searchesAutoFillArr, self.searchTopViewInScrollV.searchMainV)
                DropDownHandler.shared.itemPickedBlock = { [self] (index, item) in
                    textField.text = item
                    if self.searchesAutoFillTypeArr[index] == "County" {
                        listArr.removeAll()
                        searchTV.reloadData()
                        self.searchesCountyArr.append(self.searchTopViewInScrollV.searchTxtF.text!)
                        self.listViewApi(stateName: [], regionName: [], propertyName: [], freeText: [], county: self.searchesCountyArr, rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: 1)
                    } else if self.searchesAutoFillTypeArr[index] == "RLU" {
                        listArr.removeAll()
                        searchTV.reloadData()
                        self.searchesRLUArr.append(self.searchTopViewInScrollV.searchTxtF.text!)
                        self.listViewApi(stateName: [], regionName: [], propertyName: [], freeText: [], county: [], rlu: self.searchesRLUArr, amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: 1)
                    } else if self.searchesAutoFillTypeArr[index] == "Region" {
                        listArr.removeAll()
                        searchTV.reloadData()
                        self.searchesRegionArr.append(self.searchTopViewInScrollV.searchTxtF.text!)
                        self.listViewApi(stateName: [], regionName: self.searchesRegionArr, propertyName: [], freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: 1)
                    } else {
                        listArr.removeAll()
                        searchTV.reloadData()
                        self.searchesPropertyArr.append(self.searchTopViewInScrollV.searchTxtF.text!)
                        self.listViewApi(stateName: [], regionName: [], propertyName: self.searchesPropertyArr, freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: 1)
                    }
                    self.searchTopView.searchTxtF.resignFirstResponder()
                }
            }
        }
    }
    
    // MARK: - Set ListView and MapView WithOut ScrollView
    func setListViewInMainV() {
        self.searchTopView.toggleBtn.image = Images.map.name
        self.selectedItem = "list"
        self.searchTV.isHidden = false
        self.mapView.isHidden = true
        self.zoomView.isHidden = true
        self.mapHybridView.isHidden = true
        
        if self.listArr.count != 0 {
            listViewApi(stateName: [], regionName: [LocalStore.shared.regionSearchName], propertyName: [LocalStore.shared.propertySearchName], freeText: [LocalStore.shared.freeTextSearchName], county: [LocalStore.shared.countySearchName], rlu: [LocalStore.shared.rluSearchName], amenities: amenitiesSearchArr, rluAcresMin: 0, rluAcresMax: 0, priceMin: 0, priceMax: 0, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
        }
        searchTV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func setListViewInScrollV() {
        self.selectedItem = "list"
        self.searchTV.isHidden = false
        self.mapView.isHidden = true
        self.zoomView.isHidden = true
        self.mapHybridView.isHidden = true
        self.searchTopViewInScrollV.toggleBtn.image = Images.map.name
        if self.listArr.count != 0 {
            listViewApi(stateName: [], regionName: [LocalStore.shared.regionSearchName], propertyName: [LocalStore.shared.propertySearchName], freeText: [LocalStore.shared.freeTextSearchName], county: [LocalStore.shared.countySearchName], rlu: [LocalStore.shared.rluSearchName], amenities: amenitiesSearchArr, rluAcresMin: 0, rluAcresMax: 0, priceMin: 0, priceMax: 0, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
        }
        searchTV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    // MARK: - Web Service
     func availableStatesApi() {
        self.searchViewModelArr?.availableStatesApi( self.view, completion: { responseModel in
            print("Available states",responseModel)
            self.availableStatesModelArr = responseModel
            self.statesArr.removeAll()
            self.statesAbbrArr.removeAll()
            for i in 0..<self.availableStatesModelArr.count {
                self.statesArr.append(self.availableStatesModelArr[i].stateName!)
                self.statesAbbrArr.append(self.availableStatesModelArr[i].stateAbbrev!)
            }
            
            DispatchQueue.main.async {
                self.setAmenitiesApi()
            }
        })
    }
  
    private func setAmenitiesApi() {
        self.searchViewModelArr?.getAllAmenitiesApi(self.view, completion: {responseModel in
            self.activitiesCV.allowsMultipleSelection = true
            self.amenitiesCV.allowsMultipleSelection = true
            self.cell.setUpActivitiesCollectionCell(self.activitiesCV, responseModel, 0, self.filterPopUpV.activitiesCVHeight)
            self.cell.setUpAmenitiesCollectionCell(self.amenitiesCV, responseModel, 1, self.filterPopUpV.amenitiesCVHeight)
        })
    }
    

    func listViewApi(stateName: [String], regionName: [String], propertyName: [String], freeText: [String], county: [String], rlu: [String], amenities: [String], rluAcresMin: Int, rluAcresMax: Int, priceMin: Int, priceMax: Int, productTypeId: Int, order: String, sort: String ,pageNumber :   Int) {
        self.searchViewModelArr?.searchApi(self.view, stateName: stateName, regionName: regionName, propertyName: propertyName, freeText: freeText, county: county, rlu: rlu, amenities: amenities, rluAcresMin: rluAcresMin, rluAcresMax: rluAcresMax, priceMin: priceMin, priceMax: priceMax, productTypeId: productTypeId, order: order, sort: sort, pageNumber: pageNumber, completion: { [self] responseModel in
            if pageCount >= 2 {
               
            } else {
                listArr.removeAll()
            }
            if !responseModel.isEmpty {
                self.listArr.append(contentsOf: responseModel)
            }
            
            self.amenityArr.removeAll()
            self.listArr.forEach { listItem in
                var listItemArr = [String]()
                listItem.amenitiyList?.forEach({ amenity in
                    listItemArr.append(amenity.amenityIcon ?? "")
                })
                self.amenityArr.append(listItemArr)
            }
            self.searchTV.register(UINib(nibName: "ListSearchTVCell", bundle: nil), forCellReuseIdentifier: "ListSearchTVCell")
            self.searchTV.delegate = self
            self.searchTV.dataSource = self
            registerCell()
            self.searchTV.reloadData()
            
            print("count>>>", self.listArr.count)
            
            if self.listArr.count == 0 {
                if self.selectedItem == "list" {
                    self.noPropertyLbl.isHidden = false
                    self.changeFilterLbl.isHidden = false
                    self.resetFilterLbl.isHidden = false
                    self.reloadBtn.isHidden = false
                    self.mapView.isHidden = true
                    self.zoomView.isHidden = true
                    self.mapHybridView.isHidden = true
                } else {
                    self.searchTV.isHidden = true
                    self.mapView.isHidden = false
                    self.zoomView.isHidden = false
                    self.mapHybridView.isHidden = false
                }
                
                // Reload Button Action
                self.reloadBtn.actionBlock { [self] in
                 
                
                    self.listViewApi(stateName: [], regionName: [], propertyName: [], freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: 0, rluAcresMax: 0, priceMin: 0, priceMax: 0, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                  
                }
            } else {
                print("selectedItem>>>", self.selectedItem)
                if self.selectedItem == "list" {
                    self.mapView.isHidden = true
                    self.zoomView.isHidden = true
                    self.mapHybridView.isHidden = true
                    self.noPropertyLbl.isHidden = true
                    self.changeFilterLbl.isHidden = true
                    self.resetFilterLbl.isHidden = true
                    self.reloadBtn.isHidden = true
                } else {
                    self.searchTV.isHidden = true
                    self.mapView.isHidden = false
                    self.zoomView.isHidden = false
                    self.mapHybridView.isHidden = false
                }
            }
            
            LocalStore.shared.rluSearchName = EMPTY_STR
            LocalStore.shared.countySearchName = EMPTY_STR
            LocalStore.shared.regionSearchName = EMPTY_STR
            LocalStore.shared.propertySearchName = EMPTY_STR
            LocalStore.shared.freeTextSearchName = EMPTY_STR
            amenitiesSearchArr.removeAll()
            
            HUD.hide()
        })
    }
}

// MARK: - ViewWillTransition
extension SearchView {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard tabBarController?.selectedIndex == 1 else { return }
        searchScrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        setTableViewSize(size)
    }
    
    private func setTableViewSize(_ size: CGSize) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.searchTopViewInScrollV.isHidden = true
            self.mainTopViewInScrollVHeight.constant = 0
            self.mainTopViewHeight.constant = 150
        } else {
            if (UIDevice.current.orientation == .landscapeLeft) || (UIDevice.current.orientation == .landscapeRight) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.searchTopViewInScrollV.isHidden = false
                    self.searchTopViewInScrollV.searchTopV.constant = 30
                    self.searchTopViewInScrollV.searchMainVHeight.constant = 100
                    self.mainTopViewInScrollVHeight.constant = 100
                    self.mainTopViewHeight.constant = 0
                    self.filterPopUpV.activitiesCVHeight.constant = CGFloat(10 + Int(90*self.cell.activitiesArr.count)/7)
                    self.filterPopUpV.amenitiesCVHeight.constant = CGFloat(20 + Int(90*self.cell.amenitiesArr.count)/7)
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.searchTopViewInScrollV.isHidden = true
                    self.mainTopViewInScrollVHeight.constant = 0
                    self.mainTopViewHeight.constant = 140
                    self.filterPopUpV.activitiesCVHeight.constant = CGFloat(10 + Int(90*self.cell.activitiesArr.count)/3)
                    self.filterPopUpV.amenitiesCVHeight.constant = CGFloat(10 + Int(90*self.cell.amenitiesArr.count)/3)
                }
            }
        }
        
        
        if self.selectedItem == "list" {
            searchTopView.toggleBtn.image = Images.map.name
            searchTopViewInScrollV.toggleBtn.image = Images.map.name
        } else {
            searchTopView.toggleBtn.image = Images.list.name
            searchTopViewInScrollV.toggleBtn.image = Images.list.name
        }
        
        HUD.hide()
    }
}

// MARK: - Optional Delegates Defination
extension SearchView: SearchViewModelDelegate {
    func nonMotorizedSuccessCalled() {
        HUD.hide()
    }
    
    func nonMotorizedErrorCalled() {
      
    }
    
    func selectedStaeMapSuccessCalled() {
        HUD.hide()
    }
    
    func selectedStaeMapErrorCalled() {
    }
    
    func multiPolygon2SuccessCalled() {
        HUD.hide()
    }
    
    func multiPolygon2ErrorCalled() {
       
    }
    
    func permitShapesErrorCalled() {
       
    }
    
    func permitShapesSuccessCalled() {
        HUD.hide()
    }
    
    func accessPointSuccessCalled() {
        HUD.hide()
    }
    
    func accessPointErrorCalled() {
       
    }
    
    func searchAutoSuccessCalled() {
        HUD.hide()
    }
    
    func searchAutoErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    
    func statesSuccessCalled() {
        // HUD.hide()
    }
    
    func statesErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    
    func allAmenitiesSuccessCalled() {
        //HUD.hide()
        amenitiesCV.reloadData()
        activitiesCV.reloadData()
    }
    
    func allAmenitiesErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    func saveSearchSuccessCalled() {
        HUD.hide()
        let okBtn = [ButtonText.ok.text]
        UIAlertController.showAlert(EMPTY_STR, message: (AppAlerts.searchSaved.title), buttons: okBtn) { alert, index in
            if index == 0 {
                self.removeView(self.filterPopUpV)
                self.removeView(self.mapDetailPopUpV)
            }
        }
    }
    func saveSearchErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    
    func searchSuccessCalled() {
        self.removeView(self.filterPopUpV)
        self.removeView(self.mapDetailPopUpV)
        //  HUD.hide()
    }
    
    func searchErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
}

// MARK: - UITextFieldDelegate
extension SearchView:  UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Verify all the conditions
        if let sdcTextField = textField as? TextFieldInset {
            return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
        }
        
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            
            self.searchesRLUArr.removeAll()
            self.searchesPropertyArr.removeAll()
            self.searchesRegionArr.removeAll()
            self.searchesCountyArr.removeAll()
            self.freeTextArr.removeAll()
            
            if (txtAfterUpdate) != EMPTY_STR {
                self.searchViewModelArr?.searchAutoFillApi(self.view, txtAfterUpdate, completion: { [self] responseModel in
                    print(responseModel)
                    self.searchAutoFillModelArr = responseModel
                    print("searchAutoFillModelArr",searchAutoFillModelArr)
                    self.searchesAutoFillArr.removeAll()
                    self.searchesAutoFillTypeArr.removeAll()
                    for i in 0..<self.searchAutoFillModelArr.count {
                        self.searchesAutoFillArr.append(self.searchAutoFillModelArr[i].searchResult!)
                        self.searchesAutoFillTypeArr.append(self.searchAutoFillModelArr[i].type!)
                    }
                    
                    self.freeTextArr.append(txtAfterUpdate)
                    
                    if self.searchTopView.isHidden == false {
                        self.setSearchTxtF(textField)
                    }
                    
                    if self.searchTopViewInScrollV.isHidden == false {
                        self.setSearchTxtFinScrollV(textField)
                    }
                    
                })
            } else {
                print("EMPTY =--====-===->>>>>>>>>>>")
                textField.text = EMPTY_STR
                textField.placeholder = "Search"
                textField.resignFirstResponder()
                listArr.removeAll()
                searchTV.reloadData()
                self.listViewApi(stateName: [], regionName: [], propertyName: [], freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: 0, rluAcresMax: 0, priceMin: 0, priceMax: 0, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
            }
        }
        return true
    }
    
    private func setSearchTxtF(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            DropDownHandler.shared.cancelActionBlock = {
            }
            DropDownHandler.shared.showDropDownWithOutIcon(self.searchTopView.searchV, self.searchesAutoFillArr, self.searchTopView.searchMainV)
            DropDownHandler.shared.itemPickedBlock = { [self] (index, item) in
                textField.text = item
                print("item", item)
                print("index", index)
                print("searchesAutoFillTypeArr",searchesAutoFillTypeArr)
                print("searchesAutoFillTypeArr[index]",searchesAutoFillTypeArr[index])
                if self.searchesAutoFillTypeArr[index] == "County" {
                    listArr.removeAll()
                    searchTV.reloadData()
                   
                    self.searchesCountyArr.append(self.searchTopView.searchTxtF.text!)
                    self.listViewApi(stateName: [], regionName: [], propertyName: [], freeText: [], county: self.searchesCountyArr, rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                   
                } else if self.searchesAutoFillTypeArr[index] == "RLU" {
                    listArr.removeAll()
                    searchTV.reloadData()
                    self.searchesRLUArr.append(self.searchTopView.searchTxtF.text!)
                    print("self.searchTopView.searchTxtF.text",self.searchTopView.searchTxtF.text as Any)
                    print("searchesRLUArr",searchesRLUArr)
                    self.listViewApi(stateName: [], regionName: [], propertyName: searchesRLUArr, freeText: [], county: [], rlu: self.searchesRLUArr, amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber:pageCount)
                    
                } else if self.searchesAutoFillTypeArr[index] == "Region" {
                    listArr.removeAll()
                    searchTV.reloadData()
                    self.searchesRegionArr.append(self.searchTopView.searchTxtF.text!)
                    self.listViewApi(stateName: [], regionName: self.searchesRegionArr, propertyName: searchesRegionArr, freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                } else {
                    listArr.removeAll()
                    searchTV.reloadData()
                    self.searchesPropertyArr.append(self.searchTopView.searchTxtF.text!)
                    self.listViewApi(stateName: [], regionName: [], propertyName: self.searchesPropertyArr, freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                    
                }
                self.searchTopView.searchTxtF.resignFirstResponder()
            }
        }
    }
    
    private func setSearchTxtFinScrollV(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            DropDownHandler.shared.showDropDownWithOutIcon(self.searchTopViewInScrollV.searchV, self.searchesAutoFillArr, self.searchTopViewInScrollV.searchMainV)
            DropDownHandler.shared.itemPickedBlock = { [self] (index, item) in
                print("item", item)
                print("index", index)
                print("searchesAutoFillTypeArr[index]",searchesAutoFillTypeArr[index])
                textField.text = item
                if self.searchesAutoFillTypeArr[index] == "County" {
                    listArr.removeAll()
                    searchTV.reloadData()
                    self.searchesCountyArr.append(self.searchTopViewInScrollV.searchTxtF.text!)
                    self.listViewApi(stateName: [], regionName: [], propertyName: [], freeText: [], county: self.searchesCountyArr, rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                  
                } else if self.searchesAutoFillTypeArr[index] == "RLU" {
                    listArr.removeAll()
                    searchTV.reloadData()
                    self.searchesRLUArr.append(self.searchTopViewInScrollV.searchTxtF.text!)
                    print("searchesRLUArr",searchesRLUArr)
                    self.listViewApi(stateName: [], regionName: [], propertyName: searchesRLUArr, freeText: [], county: [], rlu: self.searchesRLUArr, amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                   
                } else if self.searchesAutoFillTypeArr[index] == "Region" {
                    listArr.removeAll()
                    searchTV.reloadData()
                    self.searchesRegionArr.append(self.searchTopViewInScrollV.searchTxtF.text!)
                    self.listViewApi(stateName: [], regionName: self.searchesRegionArr, propertyName: searchesRegionArr, freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                    
                } else {
                    listArr.removeAll()
                    searchTV.reloadData()
                    self.searchesPropertyArr.append(self.searchTopViewInScrollV.searchTxtF.text!)
                    self.listViewApi(stateName: [], regionName: [], propertyName: self.searchesPropertyArr, freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: self.rluAcresMin, rluAcresMax: self.rluAcresMax, priceMin: self.minPrice, priceMax: self.maxPrice, productTypeId: 0, order: EMPTY_STR, sort: "New Releases", pageNumber: pageCount)
                    
                }
                self.searchTopView.searchTxtF.resignFirstResponder()
            }
        }
    }
}



