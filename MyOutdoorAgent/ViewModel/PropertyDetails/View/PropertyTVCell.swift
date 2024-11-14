//  PropertyTVCell.swift
//  MyOutdoorAgent
//  Created by CS on 29/08/22.

import UIKit
import PKHUD
import GoogleMaps
import MapKit
import GoogleMapsUtils

var productNo = String()
var latitude = Double()
var longitude = Double()
//var searchViewModelArray: SearchViewModel?
var isLicensed = Int()
var zoom = true
var lineCount = 0

//protocol SetMapDetailViewDelegate: AnyObject {
//    func setMapDetailView()
//}

class PropertyTVCell: UITableViewCell, PropertyViewModelDelegate {
    func multiPolygon2SuccessCalled() {
        HUD.hide()
    }
    
    func multiPolygon2ErrorCalled() {
        
    }
    
    func activityDetailSuccessCalled() {
        HUD.hide()
    }
    
    func activityDetailErrorCalled(_ error: String) {
        HUD.hide()
    }
    
    func entryFormSuccessCalled() {
        HUD.hide()
    }
    
    func entryFormErrorCalled(_ error: String) {
        HUD.hide()
    }
    
    func submitReqSuccessCalled() {
        HUD.hide()
    }
    
    func submitReqErrorCalled(_ error: String) {
        HUD.hide()
    }
    
    func paymentTokenSuccessCalled() {
        HUD.hide()
    }
    
    func paymentErrorCalled(_ error: String) {
        HUD.hide()
    }
    
    func dayPassSuccessCalled(_ daypassTotalCost: Double, _ isAvailable: Bool) {
        HUD.hide()
    }
    
    func dayPassErrorCalled(_ error: String) {
        HUD.hide()
    }
    
    func sendMessageSuccessCalled() {
        HUD.hide()
    }
    
    func sendMessageErrorCalled(_ error: String) {
        HUD.hide()
    }
    
    func generateContractSuccessCalled() {
        HUD.hide()
    }
    
    func generateContractErrorCalled(_ error: String) {
        HUD.hide()
    }
    
    func harvestingSuccessCalled() {
        HUD.hide()
    }
    
    func harvestingErrorCalled(_ error: String) {
        HUD.hide()
    }
    
    
    // MARK: - Variables
    var clusterArr = [Int]()
    var isLicensedArr = [Int]()
    var coordinatePointArr = [[Double]]()
    var clusterManager: GMUClusterManager!
    let specificLabelMarker = GMSMarker()
   
    let marker = GMSMarker()
    var mapModel : PointModel?
    var currentZoom: Float = 15
   
    weak var mapViewDelegate : SetMapDetailViewDelegate?
    var coordinateMultiplygonArr = [Double]()
    var polyArr : PolyModel?
    var coordinatePolyArr = [[Coordinate]]()
    var coordinateMultiPolyArr = [[[Coordinate]]]()
    var isLicensedPolyArr = [Int]()
    var polygonData: [String: UIColor] = [:]
    var polygonPoints: [CLLocationCoordinate2D] = []
    let polygonLine = GMSPolyline()
    var labelMarkers: [GMSMarker] = []
    var labelMarkers2: [GMSMarker] = []
    var hasCalledGenerateClusterItems = false
    var zoomChangeTimer: Timer?
    var lastZoomLevel: Float = 0
    var polygons: [GMSPolyline] = []
    var latitude = Double()
    var longitude = Double()
    var propertyViewModelArr: PropertyViewModel?
    var isLicensedMultiPolyArr = [Int]()
  
    // MARK: - Outlets
  
    @IBOutlet weak var zoomOut: UILabel!
    @IBOutlet weak var zoomIn: UILabel!
    @IBOutlet weak var noDocumentAvailable: UILabel!
    @IBOutlet weak var documemtTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var documentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var documentTableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var propertyAddressLbl: UILabel!
    @IBOutlet weak var propertyPriceLbl: UILabel!
    @IBOutlet weak var detailAddressLbl: UILabel!
    @IBOutlet weak var propertyId: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var AcresLbl: UILabel!
    @IBOutlet weak var licenseStartDateLbl: UILabel!
    @IBOutlet weak var licenseEndDateLbl: UILabel!
    @IBOutlet weak var requestTempAccessV: UIView!
    @IBOutlet weak var conditionsTV: UITableView!
    @IBOutlet weak var activitiesTV: UITableView!
    @IBOutlet weak var amenitiesTV: UITableView!
    @IBOutlet weak var noSpecialConditionsLbl: UILabel!
    @IBOutlet weak var noSimilarPropertiesLbl: UILabel!
    @IBOutlet weak var noActivitiesLbl: UILabel!
    @IBOutlet weak var noAmenitiesLbl: UILabel!
    @IBOutlet weak var amenitiesHeight: NSLayoutConstraint!
    @IBOutlet weak var activitiesHeight: NSLayoutConstraint!
    @IBOutlet weak var noDescLbl: UILabel!
    @IBOutlet weak var propertyDescHeight: NSLayoutConstraint!
    @IBOutlet weak var conditionsVHeight: NSLayoutConstraint!
    @IBOutlet weak var similarPropertiesHeight: NSLayoutConstraint!
    @IBOutlet weak var leaveMsgBtn: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSimilarPropertiesCVDelegates()
        registerSimilarPropertiesCV()
        registerConditionTV()
        setConditionTVDelegates()
        registerAmenitiesTV()
        documentTableViewRegister()
        setAmenitiesTVDelegates()
        registerActivitiesTV()
        setActivitiesTVDelegates()
       // setMapView()
      //  setPointLayer()
        if LocalStore.shared.productTypeId == 1 {
            setMultipolygonApi(LocalStore.shared.productNo)
        } else {
            setMultipolygonApi2(LocalStore.shared.productNo)
        }
        print("LocalStore.shared.productNo",LocalStore.shared.productNo)
       
        zoomIn.actionBlock {
            self.mapView.animate(toZoom: self.mapView.camera.zoom + 1)
        }
        zoomOut.actionBlock{
            self.mapView.animate(toZoom: self.mapView.camera.zoom - 1)
        }
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    // MARK: - Draw Method
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setLayoutListCV(collectionV)
    }
    
    // MARK: - SetLayoutListCV
    func setLayoutListCV(_ collectionV : UICollectionView) {
        guard let flowLayout = collectionV.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if (UIDevice.current.orientation == .landscapeLeft) || (UIDevice.current.orientation == .landscapeRight) {
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-10, height: collectionV.frame.width/2-140)
            } else {
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-10, height: collectionV.frame.width/2+60)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-10, height: collectionV.frame.height/2-180)
            default:
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-10, height: collectionV.frame.width/2-50)
            }
        }
        flowLayout.invalidateLayout()
    }
    
    // MARK: - Functions
    func setSimilarPropertiesCVDelegates() {
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.reloadData()
    }
    
    func registerSimilarPropertiesCV() {
        collectionV.register(UINib.init(nibName: CustomCells.homeListCVCell.name, bundle: nil), forCellWithReuseIdentifier: CustomCells.homeListCVCell.name)
    }
    
    func setConditionTVDelegates() {
        conditionsTV.dataSource = self
        conditionsTV.delegate = self
        conditionsTV.reloadData()
    }
    
    func registerConditionTV() {
        conditionsTV.register(UINib(nibName: CustomCells.propertyConditionsTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.propertyConditionsTVCell.name)
    }
    
    func registerAmenitiesTV() {
        amenitiesTV.register(UINib(nibName: CustomCells.propertyAmenitiesTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.propertyAmenitiesTVCell.name)
    }
    func documentTableViewRegister() {
        documentTableView.register(UINib(nibName: "DocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "DocumentTableViewCell")
        documentTableView.dataSource = self
        documentTableView.delegate = self
    }
    func setAmenitiesTVDelegates() {
        amenitiesTV.delegate = self
        amenitiesTV.dataSource = self
        amenitiesTV.reloadData()
        amenitiesTV.estimatedRowHeight = 120
        amenitiesTV.rowHeight = UITableView.automaticDimension
    }
    
    func registerActivitiesTV() {
        activitiesTV.register(UINib(nibName: CustomCells.propertyAmenitiesTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.propertyAmenitiesTVCell.name)
    }
    
    func setActivitiesTVDelegates() {
        activitiesTV.delegate = self
        activitiesTV.dataSource = self
        activitiesTV.reloadData()
        activitiesTV.estimatedRowHeight = 120
        activitiesTV.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - UICollectionViewDataSource
extension PropertyTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarPropProductNoArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = configureSimilarPropertyCell(collectionView, indexPath)
        return cell
    }
}

// MARK: - UICollectionView Delegates
extension PropertyTVCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - UICollectionView Delegate FlowLayout
extension PropertyTVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let listSize = setListCollectionLayout(collectionView, collectionViewLayout)
        return listSize
    }
    
    // -- Set List CollectionView Layout in cell class
    func setListCollectionLayout(_ collectionView: UICollectionView, _ collectionViewLayout: UICollectionViewLayout) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if (UIDevice.current.orientation == .landscapeLeft) || (UIDevice.current.orientation == .landscapeRight) {
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2-140)
            } else {
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2+60)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2-180)
            default:
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2-50)
            }
        }
        collectionViewLayout.invalidateLayout()
        return CGSize()
    }
}

// MARK: - ConfigureCell
extension PropertyTVCell {
    func configureSimilarPropertyCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> UICollectionViewCell {
        let dequeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCells.homeListCVCell.name, for: indexPath)
        guard let cell = dequeCell as? HomeListCVCell else { return UICollectionViewCell() }
        setSimilarPropertyCell(cell, indexPath)
        return cell
    }
    
    func setSimilarPropertyCell(_ cell: HomeListCVCell, _ indexPath: IndexPath) {
        if similarPropProductNoArr.count == 0 {
            noSimilarPropertiesLbl.isHidden = false
        } else {
            noSimilarPropertiesLbl.isHidden = true
            cell.displayNameLbl.text = similarPropProductNoArr[indexPath.row]
            cell.locationLbl.text = similarPropLocationArr[indexPath.row]
            
            // -- Set Image
            if similarPropImagesArr.count == 0 {
                cell.regionImgV.image = Images.logoImg.name
            } else {
                if similarPropImagesArr[indexPath.row] == "none" {
                    cell.regionImgV.image = Images.logoImg.name
                } else {
                    var str = (Apis.rluImageUrl) + similarPropImagesArr[indexPath.row]
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
            }
            if cell.regionImgV.image == UIImage(named: "") {
                cell.regionImgV.image = Images.logoImg.name
            }
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                switch UIDevice.current.orientation {
                case .landscapeLeft, .landscapeRight:
                    cell.regionNameHeight.constant = 15
                default:
                    cell.regionNameHeight.constant = 30
                }
            } else {
                cell.regionNameHeight.constant = 15
            }
            
            cell.viewDetailsV.actionBlock {
                var data = [String: Any]()
                data["publicKey"] = similarProperties![indexPath.row].publicKey
                isComingFrom = "other"
                UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension PropertyTVCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == conditionsTV {
            if conditionsArr.count != 0 {
                UIDevice.current.userInterfaceIdiom == .phone
                ? (conditionsVHeight.constant = CGFloat(70 + Int(25*conditionsArr.count)))
                : (conditionsVHeight.constant = CGFloat(85 + Int(25*conditionsArr.count)))
                return conditionsArr.count
            }
        } else if tableView == activitiesTV {
            if activitiesArr != nil {
                UIDevice.current.userInterfaceIdiom == .phone
                ? (activitiesHeight.constant = CGFloat(55 + Int(50*activitiesArr!.count)))
                : (activitiesHeight.constant = CGFloat(85 + Int(50*activitiesArr!.count)))
                return activitiesArr!.count
            }
        } else if tableView == documentTableView {
            if clientDocumentss?.count ?? 0 > 0 {
                noDocumentAvailable.isHidden = true
                documentTableView.isHidden = false
                documentViewHeight.constant = CGFloat((clientDocumentss?.count ?? 0) * 50) + 60
            } else {
                documentViewHeight.constant = CGFloat((clientDocumentss?.count ?? 0) * 50) + 100
                noDocumentAvailable.isHidden = false
                documentTableView.isHidden = true
            }
           
            let height = CGFloat((clientDocumentss?.count ?? 0) * 50)
            documemtTableViewHeight.constant = height
            return clientDocumentss?.count ?? 0
        }
        else {
            if amenitiesArr != nil {
                UIDevice.current.userInterfaceIdiom == .phone
                ? (amenitiesHeight.constant = CGFloat(55 + Int(50*amenitiesArr!.count)))
                : (amenitiesHeight.constant = CGFloat(85 + Int(50*amenitiesArr!.count)))
                return amenitiesArr!.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(tableView, indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == amenitiesTV {
            return UITableView.automaticDimension
        } else if tableView == documentTableView {
            return 50
        } else if tableView == activitiesTV {
            return UITableView.automaticDimension
        } else if tableView == conditionsTV {
            return 20
        }
       return CGFloat()
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == documentTableView {
//            return 40
//        }
//        return CGFloat()
//    }
}
      
// MARK: - ConfigureCell
extension PropertyTVCell {
    private func configureCell(_ tableView : UITableView, _ indexPath : IndexPath) -> UITableViewCell {
        if tableView == conditionsTV {   // Special Conditions TableView
            let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.propertyConditionsTVCell.name, for: indexPath)
            guard let cell = dequeCell as? PropertyConditionsTVCell else { return UITableViewCell() }
            setConditionsCell(cell, indexPath)
            return cell
        } else if tableView == activitiesTV {  // Activities TableView
            let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.propertyAmenitiesTVCell.name, for: indexPath)
            guard let cell = dequeCell as? PropertyAmenitiesTVCell else { return UITableViewCell() }
            setActivitiesCell(cell, indexPath)
            return cell
        } else if tableView == documentTableView {
            let dequeCell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableViewCell", for: indexPath)
            guard let cell = dequeCell as? DocumentTableViewCell else { return UITableViewCell() }
            setClientDocument(cell, indexPath)
            return cell
        } else {        // Amenities TableView
            let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.propertyAmenitiesTVCell.name, for: indexPath)
            guard let cell = dequeCell as? PropertyAmenitiesTVCell else { return UITableViewCell() }
            setAmenitiesCell(cell, indexPath)
            return cell
        }
    }
    
    
    func setConditionsCell(_ cell: PropertyConditionsTVCell, _ indexPath: IndexPath) {
        if conditionsArr.count == 0 {
            noSpecialConditionsLbl.isHidden = false
        } else {
            
            
            noSpecialConditionsLbl.isHidden = true
            cell.conditionsLbl.text = conditionsArr[indexPath.row]
        }
    }
    func setClientDocument(_ cell: DocumentTableViewCell, _ indexPath: IndexPath) {
    //    print("documentData.........>>>>",clientDocumentss)
        cell.documentLabel.setTitle(clientDocumentss?[indexPath.row].fileName, for: .normal)
        cell.documentView.actionBlock {
            print("documentName",clientDocumentss?[indexPath.row].documentName ?? "")
            print("clientID",clientDocumentss?[indexPath.row].clientID ?? "")
            let clientIdValue = "\(clientDocumentss?[indexPath.row].clientID ?? 0)"
            print(clientIdValue)
            let urlString = "https://client.myoutdooragent.com/Assets/ClientDocuments/" + clientIdValue + "/" + (clientDocumentss?[indexPath.row].documentName ?? "")
                //  https://adminv2.myoutdooragent.com/Assets/ClientDocuments/13/HPL%20DAYPASS.pdf
            print("urlString",urlString)
            if let myURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(myURL) {
                    UIApplication.shared.open(myURL, options: [:], completionHandler: nil)
                }
            }
        }
        cell.documentLabel.actionBlock {
            print("documentName",clientDocumentss?[indexPath.row].documentName ?? "")
            print("clientID",clientDocumentss?[indexPath.row].clientID ?? "")
            let clientIdValue = "\(clientDocumentss?[indexPath.row].clientID ?? 0)"
            print(clientIdValue)
            let urlString = "https://client.myoutdooragent.com/Assets/ClientDocuments/" + clientIdValue + "/" + (clientDocumentss?[indexPath.row].documentName ?? "")
                //  https://adminv2.myoutdooragent.com/Assets/ClientDocuments/13/HPL%20DAYPASS.pdf
            print("urlString",urlString)
            if let myURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(myURL) {
                    UIApplication.shared.open(myURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    func setActivitiesCell(_ cell: PropertyAmenitiesTVCell, _ indexPath: IndexPath) {
        if activitiesArr == nil {
            noActivitiesLbl.isHidden = false
        } else {
            noActivitiesLbl.isHidden = true
            
            if (activitiesArr![indexPath.row].amenityName)?.contains("\n") == true {
                cell.amenityName.text = (activitiesArr![indexPath.row].amenityName)?.replacingOccurrences(of: "\n", with: "")
            } else {
                cell.amenityName.text = activitiesArr![indexPath.row].amenityName
                
            }
            
            if (activitiesArr![indexPath.row].description)?.contains("\n") == true {
                cell.amenityDescLbl.text = (activitiesArr![indexPath.row].description)?.replacingOccurrences(of: "\n", with: "")
                let linesCount = numberOfLines(of: cell.amenityDescLbl)
                activitiesHeight.constant = CGFloat(55 + Int(50*activitiesArr!.count)) + CGFloat(Double(linesCount) * 0.5)
            } else {
                cell.amenityDescLbl.text = activitiesArr![indexPath.row].description
                let linesCount = numberOfLines(of: cell.amenityDescLbl)
                activitiesHeight.constant = CGFloat(55 + Int(50*activitiesArr!.count)) + CGFloat(Double(linesCount) * 0.5)
            }
            
            // -- Set Image
            if activitiesArr![indexPath.row].amenityIcon == nil {
                cell.amenitiesImgV.image = Images.logoImg.name
            } else {
                var str = (Apis.licenseAmenitiesUrl) + (activitiesArr![indexPath.row].amenityIcon ?? "")
                if let dotRange = str.range(of: "?") {
                    str.removeSubrange(dotRange.lowerBound..<str.endIndex)
                    
                    str.contains(" ")
                    ? cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str.replacingOccurrences(of: " ", with: "%20"))
                    : cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str)
                    
                } else {
                    str.contains(" ")
                    ? cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str.replacingOccurrences(of: " ", with: "%20"))
                    : cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str)
                }
            }
        }
    }
    func numberOfLines(of label: UILabel) -> Int {
        let constraintBox = CGSize(width: label.bounds.width, height: .greatestFiniteMagnitude)
        let rect = label.text?.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: label.font as Any], context: nil)
        return Int(ceil(rect?.size.height ?? 0 / label.font.lineHeight))
    }

    func setAmenitiesCell(_ cell: PropertyAmenitiesTVCell, _ indexPath: IndexPath) {
        if amenitiesArr == nil {
            noAmenitiesLbl.isHidden = false
        } else {
            noAmenitiesLbl.isHidden = true
            cell.amenityName.text = amenitiesArr![indexPath.row].amenityName
          lineCount = lineCount +  numberOfLines(of: cell.amenityDescLbl)
            print(" amenitiesHeight.constant",CGFloat(65 + Int(25*amenitiesArr!.count)) + CGFloat(Double(lineCount) * 0.5))
            
            amenitiesHeight.constant = CGFloat(65 + Int(25*amenitiesArr!.count)) + CGFloat(Double(lineCount) * 0.5)
            cell.amenityDescLbl.text = amenitiesArr![indexPath.row].description
            
            // -- Set Image
            if amenitiesArr![indexPath.row].amenityIcon == nil {
                cell.amenitiesImgV.image = Images.logoImg.name
            } else {
                var str = (Apis.licenseAmenitiesUrl) + amenitiesArr![indexPath.row].amenityIcon!
                if let dotRange = str.range(of: "?") {
                    str.removeSubrange(dotRange.lowerBound..<str.endIndex)
                    
                    str.contains(" ")
                    ? cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str.replacingOccurrences(of: " ", with: "%20"))
                    : cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str)
                    
                } else {
                    str.contains(" ")
                    ? cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str.replacingOccurrences(of: " ", with: "%20"))
                    : cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str)
                }
            }
        }
    }
}

// MARK: -
//extension PropertyTVCell: MyLicensesViewModelDelegate {
//    func multiPolygonSuccessCalled() {
//        HUD.hide()
//    }
//    
//    func multiPolygonErrorCalled() {
//        
//    }
//    
//    func rluDetailSuccessCalled() {
//        HUD.hide()
//    }
//    
//    func rluDetailErrorCalled() {
//        
//    }
//    
//    func polyLayerSuccessCalled() {
//        HUD.hide()
//    }
//    
//    func polyLayerErrorCalled() {
//    
//    }
//    
//    func pointLayerSuccessCalled() {
//        HUD.hide()
//    }
//    
//    func pointLayerErrorCalled() {
//        
//    }
//    
//    func deleteVehiclesSuccessCalled() {
//        HUD.hide()
//        DispatchQueue.main.async {
//            self.vehiclesTV.reloadData()
//            self.reloadDelegate?.reloadTableViewData()
//            HUD.flash(.label(AppAlerts.vehicleRemoveSuccess.title), delay: 1.0)
//            vehicleDetailArr?.count == 0
//            ? (self.noVehiclesLbl.isHidden = false)
//            : (self.noVehiclesLbl.isHidden = true)
//        }
//    }
//    func deleteVehiclesErrorCalled(_ error: String) {
//        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
//    }
//    func removeMembersSuccessCalled() {
//        HUD.hide()
//        DispatchQueue.main.async {
//            self.membersTV.reloadData()
//            self.reloadDelegate?.reloadTableViewData()
//            HUD.flash(.label(AppAlerts.memberRemoveSuccess.title), delay: 1.0)
//            memberDetailArr?.count == 0
//            ? (self.noMembersLbl.isHidden = false)
//            : (self.noMembersLbl.isHidden = true)
//        }
//    }
//    func removeMembersErrorCalled(_ error: String) {
//        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
//    }
//}

extension PropertyTVCell {
    func setClusterMap() {
        // Set up the cluster manager with default icon generator and renderer.
        clusterArr.removeAll()
        print("isLicensedArr.count",isLicensedArr.count)
        for i in 0..<self.isLicensedArr.count {
            if self.isLicensedArr[i] == 0 {
                clusterArr.append(self.isLicensedArr[i])
            }
        }
        print("clusterArr.count",clusterArr.count)
        let clusterCount = NSNumber(value: clusterArr.count)
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [clusterCount], backgroundColors: [UIColor(red: 33/255, green: 174/255, blue: 108/255, alpha: 1.0)])
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.animatesClusters = false
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        // Register self to listen to GMSMapViewDelegate events.
        clusterManager.setMapDelegate(self)
        clusterManager.setDelegate(self, mapDelegate: self)
        
        // Generate and add random items to the cluster manager.
        self.generateClusterItems(3) {
            HUD.hide()
            self.specificLabelMarker.map = nil
        }
        
        // Call cluster() after items have been added to perform the clustering and rendering on map.
        self.clusterManager.cluster()
        
       // self.mapDetailPopUpV.zoomLbl.text = "Zoom In"
        //self.zoom = true
    }
   
   func generateClusterItems(_ zoom: Float, completion: @escaping() -> ()) {
       //clusterManager.clearItems()
       
       for i in 0..<coordinatePointArr.count {
           let lat = coordinatePointArr[i][1]
           let lng = coordinatePointArr[i][0]
           
           if (((lat < -90 || lat > 90)) && ((lng < -180 || lng > 180))) {
               print("===================================Invalid lat long================================")
           } else {
               let camera = GMSCameraPosition.camera(withLatitude: coordinatePointArr[0][1], longitude: coordinatePointArr[0][0], zoom: zoom)
               self.mapView?.camera = camera
               
               if isLicensedArr[i] == 1 {
                   let notAvailablePosition = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                   let notAvailableMarker = GMSMarker(position: notAvailablePosition)
                   //notAvailableMarker.position = notAvailablePosition
                   notAvailableMarker.icon = #imageLiteral(resourceName: "grey_marker")
                   clusterManager.add(notAvailableMarker)
               } else {
                   let availablePosition = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                   let availableMarker = GMSMarker(position: availablePosition)
                   //availableMarker.position = availablePosition
                   availableMarker.icon = #imageLiteral(resourceName: "green_marker")
                   clusterManager.add(availableMarker)
               }
           }
       }
       
       completion()
       print("LocalStore.shared.productTypeId",LocalStore.shared.productTypeId)
       if LocalStore.shared.productTypeId == 1 {
           setMultipolygonApi(LocalStore.shared.productNo)
       } else {
           setMultipolygonApi2(LocalStore.shared.productNo)
       }
       
       
   }
   
//    func setSpecificPolygonApi(_ rluName: String) {
//        HUD.show(.progress, onView: UIApplication.visibleViewController.view)
//
//        searchViewModelArr?.multiPolygonApi(UIApplication.visibleViewController.view, rluName: rluName, completion: { responseModel in
//            self.coordinateMultiplygonArr.removeAll()
//
//            // Safely unwrap the first feature and its coordinates
//            guard let firstFeature = responseModel.features.first,
//                  let firstPolygonCoordinates = firstFeature.geometry?.coordinates?.first else {
//                HUD.hide()
//                return
//            }
//
//            // Set the camera to the first coordinate of the first polygon
//            guard let firstCoordinate = firstPolygonCoordinates.first as? [Double],
//                  firstCoordinate.count == 2 else {
//                HUD.hide()
//                return
//            }
//
//            // Unpack latitude and longitude
//            let longitude = firstCoordinate[0]
//            let latitude = firstCoordinate[1]
//
//            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14)
//            self.mapView.camera = camera
//
//            let path = GMSMutablePath()
//
//            // Iterate through the coordinates of the first polygon to create the polygon path
//            for coordinate in firstPolygonCoordinates {
//                guard let coordArray = coordinate as? [Double], coordArray.count == 2 else { continue }
//
//                let lon = coordArray[0] // First element is longitude
//                let lat = coordArray[1]  // Second element is latitude
//
//                path.add(CLLocationCoordinate2D(latitude: lat, longitude: lon))
//            }
//
//            let polygon = GMSPolyline(path: path)
//
//            // Set polygon color based on licensing status
//            polygon.strokeColor = (firstFeature.properties?.isLicensed == 1)
//                ? UIColor(red: 0/255, green: 118/255, blue: 22/255, alpha: 1.0)
//                : UIColor(red: 33/255, green: 174/255, blue: 108/255, alpha: 1.0)
//
//            polygon.strokeWidth = 2
//            polygon.title = rluName
//            polygon.map = self.mapView
//
//            // Create a label marker at the camera target
//            let labelMarker = GMSMarker(position: camera.target)
//            let label = UILabel()
//            label.text = polygon.title
//            label.textColor = .black
//            label.backgroundColor = UIColor(red: 252/255, green: 247/255, blue: 224/255, alpha: 1.0)
//            label.sizeToFit()
//            labelMarker.iconView = label
//            labelMarker.map = self.mapView
//
//            self.clusterManager.clearItems()
//            HUD.hide()
//        })
//    }


   
    // Point Layer Api
    func setPointLayer() {
         propertyViewModelArr = PropertyViewModel(self)
       // myLicensesViewModelArr = MyLicensesViewModel(self)
        self.propertyViewModelArr?.pointLayerApi(UIApplication.visibleViewController.view, completion: { [self] responseModel in
           self.mapModel = responseModel
           //print("MapModel",mapModel)
           self.coordinatePointArr.removeAll()
           self.isLicensedArr.removeAll()
           responseModel.features?.forEach({ feature in
               
               self.coordinatePointArr.append(feature.geometry?.coordinates! ?? [])
               self.isLicensedArr.append((feature.properties?.isLicensed)!)
           })
           DispatchQueue.main.async { [self] in
            
               self.setPolyLayer(UIApplication.visibleViewController.view)
           }
       })
   }
   // Poly Layer Api
    func setPolyLayer(_ view: UIView) {
       self.propertyViewModelArr?.polyLayerApi(view, completion: { responseModel in
           self.polyArr = responseModel
       
           self.coordinatePolyArr.removeAll()
      
           self.isLicensedPolyArr.removeAll()
           self.isLicensedMultiPolyArr.removeAll()
           DispatchQueue.main.async { [self] in
               self.polyArr?.features.forEach({ feature in
                   if feature.geometry.coordinates.count != 0 {
                       for _ in 0..<feature.geometry.coordinates.count {
                           
                           if feature.geometry.type == "MultiPolygon" {
                          
                           } else {
                         
                           }
                       }
                   }
            
                 
               })
               self.setMapView(view)
           }
       })
   }
   
   // MARK: - MapView
   func setMapView(_ view : UIView) {
       HUD.show(.progress, onView:view)
       self.mapView?.delegate = self
       self.mapView?.settings.compassButton = true
       self.mapView?.settings.allowScrollGesturesDuringRotateOrZoom = true
       self.mapView?.settings.rotateGestures = true
       self.mapView?.settings.scrollGestures = true
       self.mapView?.settings.zoomGestures = true
       self.mapView?.setMinZoom(3, maxZoom: 16)
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                 self.setClusterMap()
             }
   }
    
}
// MARK: - GMUMapViewDelegate and GMUClusterManagerDelegate
extension PropertyTVCell: GMUClusterManagerDelegate {
 

   func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
       print("sdgfhdfdhfggfdj@@@@@####!!!!!")
       
       if mapView.camera.zoom >= 10 {
           drawPolygons { [self] in
               clusterManager.clearItems()
           }
           // Reset the flag when zoom level is 10 or greater
           hasCalledGenerateClusterItems = false
       } else {
           polygons.forEach { $0.map = nil }
           
           // Call generateClusterItems only if it hasn't been called yet
           if !hasCalledGenerateClusterItems {
               generateClusterItems(mapView.camera.zoom) { [self] in
                   // After calling, set the flag to true
                   hasCalledGenerateClusterItems = true
               }
           }
       }
       updateLabelVisibility(for: mapView.camera.zoom)
   }
    func updateLabelVisibility(for zoomLevel: Float) {
        guard zoomLevel != lastZoomLevel else { return }
        lastZoomLevel = zoomLevel
        
        let shouldShowLabels = zoomLevel >= 12
        let shouldShowLabels2 = zoomLevel >= 13
        labelMarkers2.forEach{ labelMaker in
            labelMaker.iconView?.isHidden = !shouldShowLabels2
        }
        labelMarkers.forEach { labelMarker in
            labelMarker.iconView?.isHidden = !shouldShowLabels
        }
    }

   // Update visibility on camera position change
   func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
       updateLabelVisibility(for: position.zoom)
   }
   
   
   func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
       mapView.animate(toLocation: marker.position)
       print("zoom====>>>>>>", mapView.camera.zoom)
       if let _ = marker.userData as? GMUCluster {
           if mapView.camera.zoom >= 8.0 {
           } else {
               mapView.animate(toZoom: mapView.camera.zoom + 1)
           }
           NSLog("Did tap cluster")
           return true
       }
  //     print(marker.iconView)
       if let label = marker.iconView as? UILabel {
           let text = label.text ?? "No text available"
           print("Marker icon text: \(text)")
           
           // Retrieve the stroke color of the polygon associated with this label
           if let strokeColor = polygonData[text] {
               // Determine the binary representation
               let colorValue: Int
               if strokeColor == .red {
                   colorValue = 1
               } else if strokeColor == UIColor(red: 0/255, green: 119/255, blue: 22/255, alpha: 1) { // Your specific green
                   colorValue = 0
               } else {
                   print("Unknown color")
                   colorValue = -1 // Use -1 for any unexpected color
               }
               
               print("Polygon stroke color binary value: \(colorValue)")
               isLicensed = colorValue
               // You can now use colorValue as needed
           } else {
               print("No polygon found for this label.")
           }

           productNo = text
       } else {
           print("Marker iconView is not a UILabel")
       }
       
       for i in 0..<coordinatePointArr.count where coordinatePointArr[i][0] == marker.position.longitude && coordinatePointArr[i][1] == marker.position.latitude {
           var tempArr = [Double]()
           tempArr.append(marker.position.longitude)
           tempArr.append(marker.position.latitude)
           
           if self.coordinatePointArr.contains(tempArr) {
               let index = self.coordinatePointArr.firstIndex(of: tempArr)
               productNo = (self.mapModel?.features?[index!].properties?.rluNo)!
               print("productNo:::",productNo)
               isLicensed = (self.mapModel?.features?[index!].properties?.isLicensed)!
               self.latitude = marker.position.latitude
               self.longitude = marker.position.longitude
           }
       }
       NSLog("Did tap marker")
       return false
   }
   func drawPolygons(_ completion: @escaping () -> ()) {
       // Remove the old polygons and labels
       polygons.forEach { $0.map = nil }
       polygons.removeAll()
       labelMarkers.forEach { $0.map = nil }
       labelMarkers.removeAll()

       guard let polyArr = self.polyArr else {
           completion()
           return
       }
       
       let visibleRegion = self.mapView.projection.visibleRegion()
       let visibleBounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)

       polyArr.features.forEach { feature in
           let coordinates = feature.geometry.type == "MultiPolygon"
               ? feature.geometry.coordinates.flatMap { $0[0] }
               : feature.geometry.coordinates[0]

           var polygonPoints: [CLLocationCoordinate2D] = []
           let path = GMSMutablePath()

           coordinates.forEach { internalCoordinate in
               do {
                   let encoded = try JSONEncoder().encode(internalCoordinate)
                   let decoded = try JSONDecoder().decode([Double].self, from: encoded)
                   let point = CLLocationCoordinate2D(latitude: decoded[1], longitude: decoded[0])
                   path.add(point)
                   polygonPoints.append(point)
               } catch {
                   print(error.localizedDescription)
               }
           }
           if polygonPoints.contains(where: { visibleBounds.contains($0) }) {
               let polygon = GMSPolyline(path: path)
               polygon.strokeColor = feature.properties.isLicensed == 1 ? .red : UIColor(red: 0/255, green: 119/255, blue: 22/255, alpha: 1)
               let strokeColor = feature.properties.isLicensed == 1 ? .red : UIColor(red: 0/255, green: 119/255, blue: 22/255, alpha: 1)
               polygon.strokeWidth = 2
               polygon.title = feature.properties.rluNo
               polygon.map = self.mapView
               polygons.append(polygon)
               polygonData[polygon.title ?? ""] = strokeColor
               // Calculate the centroid of the polygon
               let centroid = calculateCentroid(of: polygonPoints)

               // Create label marker at the centroid
               let labelMarker = GMSMarker(position: centroid)
               let label = UILabel()
               label.text = polygon.title
               label.textColor = .black
               label.backgroundColor = UIColor(red: 252/255, green: 247/255, blue: 224/255, alpha: 1.0)
               label.sizeToFit()
               labelMarker.iconView = label
               labelMarker.map = mapView
               labelMarkers.append(labelMarker)
               
               // Set initial visibility based on current zoom
               label.isHidden = self.mapView.camera.zoom < 12
           }
       }

       updateLabelVisibility(for: mapView.camera.zoom)
       completion()
   }
    func setMultipolygonApi(_ rluName: String) {
        HUD.show(.progress, onView: UIApplication.visibleViewController.view)
        propertyViewModelArr = PropertyViewModel(self)
        
        self.propertyViewModelArr?.multiPolygonApi(UIApplication.visibleViewController.view, rluName: rluName, completion: { [self] responseModel in
            self.coordinateMultiplygonArr.removeAll()

            // Safely unwrap the first feature
            guard let firstFeature = responseModel.features?.first,
                  let geometry = firstFeature.geometry else {
                HUD.hide()
                return
            }

            // Handle coordinates based on their type
            guard let coordinates = geometry.coordinates else {
                HUD.hide()
                return
            }

            // Access the first polygon's coordinates
            let firstPolygonCoordinates: [[[Double]]]
            switch coordinates {
            case .twoDimensional(let coords):
                firstPolygonCoordinates = coords
            case .fourDimensional(let coords):
                // Handle four-dimensional coordinates by selecting the first polygon
                firstPolygonCoordinates = coords.first ?? []
            }

            // Check if the coordinates array is not empty
            guard !firstPolygonCoordinates.isEmpty, let firstPolygon = firstPolygonCoordinates.first, !firstPolygon.isEmpty else {
                HUD.hide()
                return
            }

            // Create a path for the polygon
            let path = GMSMutablePath()

            // Iterate through the first polygon's coordinates
            for coordinateArray in firstPolygon {
                guard coordinateArray.count == 2 else {
                    continue
                }

                // Extract longitude and latitude
                let longitude = coordinateArray[0] // First element is longitude
                let latitude = coordinateArray[1]  // Second element is latitude
                
                // Create CLLocationCoordinate2D and add to path
                path.add(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }

            // Set camera to the first coordinate
            let initialCoordinate = firstPolygon[0]
            let camera = GMSCameraPosition.camera(withLatitude: initialCoordinate[1], longitude: initialCoordinate[0], zoom: 12)
            self.mapView.camera = camera

            // Create a polygon after iterating through coordinates
            let polygon = GMSPolyline(path: path)
             print("firstFeature.properties?.isLicensed",firstFeature.properties?.isLicensed)
            // Set polygon color based on licensing status
            polygon.strokeColor = (firstFeature.properties?.isLicensed == 1)
            ? .red : UIColor(red: 0/255, green: 119/255, blue: 22/255, alpha: 1)

            polygon.strokeWidth = 2
            polygon.title = rluName
            polygon.map = self.mapView

            // Create label marker for the polygon
            let labelMarker = GMSMarker(position: camera.target)
            let label = UILabel()
            label.text = polygon.title
            label.textColor = .black
            label.backgroundColor = UIColor(red: 252/255, green: 247/255, blue: 224/255, alpha: 1.0)
            label.sizeToFit()
            labelMarker.iconView = label
            labelMarker.map = self.mapView
            labelMarkers2.append(labelMarker)
            self.mapView.animate(toZoom: 12)
            HUD.hide()
            // Draw polygons if needed
//            self.drawPolygons {
//                self.mapView.animate(toZoom: 12)
//                HUD.hide()
//            }

            // Optional delays to refresh UI
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                HUD.show(.progress, onView: UIApplication.visibleViewController.view)
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    self.drawPolygons {
//                        DispatchQueue.main.async {
//                            HUD.hide()
//                            self.mapView.animate(toZoom: 12)
//                        }
//                    }
//                }
//            }
        })
        updateLabelVisibility(for: mapView.camera.zoom)
    }

    func setMultipolygonApi2(_ rluName: String) {
        HUD.show(.progress, onView: UIApplication.visibleViewController.view)
        propertyViewModelArr = PropertyViewModel(self)
        
        self.propertyViewModelArr?.multiPolygonApi2(UIApplication.visibleViewController.view, rluName: rluName, completion: { [self] responseModel in
            self.coordinateMultiplygonArr.removeAll()

            // Safely unwrap the first feature
            guard let firstFeature = responseModel.features?.last,
                  let geometry = firstFeature.geometry else {
                HUD.hide()
                return
            }

            // Extract coordinates based on the type
            guard let coordinates = geometry.coordinates else {
                HUD.hide()
                return
            }

            var firstPolygonCoordinates: [[[Double]]]?

            switch coordinates {
            case .twoDimensional(let coords):
                firstPolygonCoordinates = coords
            case .fourDimensional(let coords):
                firstPolygonCoordinates = coords.first // Get the first polygon's coordinates
            }

            // Ensure we have valid polygon coordinates
            guard let polygonCoordinates = firstPolygonCoordinates?.first else {
                HUD.hide()
                return
            }

            // Set camera to the first coordinate (assuming it has at least one coordinate)
            guard let initialCoordinate = polygonCoordinates.last, initialCoordinate.count == 2 else {
                HUD.hide()
                return
            }

            let camera = GMSCameraPosition.camera(withLatitude: initialCoordinate[1], longitude: initialCoordinate[0], zoom: 12)
            self.mapView.camera = camera

            // Create a path for the polygon
            let path = GMSMutablePath()

            // Iterate through the polygon's coordinates
            for coordinate in polygonCoordinates {
                // Ensure each coordinate is an array of doubles with exactly two elements
                guard coordinate.count == 2 else { continue }

                let longitude = coordinate[0] // First element is longitude
                let latitude = coordinate[1]  // Second element is latitude

                path.add(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }

            // Create a polygon after iterating through coordinates
            let polygon = GMSPolyline(path: path)
            print("firstFeature.properties?.isLicensed",firstFeature.properties?.isLicensed)
            // Set polygon color based on licensing status
            polygon.strokeColor = (firstFeature.properties?.isLicensed == 1)
            ? .red : UIColor(red: 0/255, green: 119/255, blue: 22/255, alpha: 1)
            polygon.strokeWidth = 2
            polygon.title = rluName
            polygon.map = self.mapView

            // Create label marker for the polygon
            let labelMarker = GMSMarker(position: camera.target)
            let label = UILabel()
            label.text = polygon.title
            label.textColor = .black
            label.backgroundColor = UIColor(red: 252/255, green: 247/255, blue: 224/255, alpha: 1.0)
            label.sizeToFit()
            labelMarker.iconView = label
            labelMarker.map = self.mapView
            labelMarkers2.append(labelMarker)
            self.mapView.animate(toZoom: 12)
            HUD.hide()

            // Assuming drawPolygons is still relevant
//            self.drawPolygons {
//                self.mapView.animate(toZoom: 12)
//                HUD.hide()
//            }

            // Additional delays to refresh UI (optional)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                HUD.show(.progress, onView: UIApplication.visibleViewController.view)
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    self.drawPolygons {
//                        DispatchQueue.main.async {
//                            HUD.hide()
//                            self.mapView.animate(toZoom: 12)
//                        }
//                    }
//                }
//            }
        })
        updateLabelVisibility(for: mapView.camera.zoom)
    }

   // Function to calculate the centroid of a set of coordinates
   private func calculateCentroid(of points: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
       var totalLatitude: Double = 0
       var totalLongitude: Double = 0

       for point in points {
           totalLatitude += point.latitude
           totalLongitude += point.longitude
       }

       let count = Double(points.count)
       return CLLocationCoordinate2D(latitude: totalLatitude / count, longitude: totalLongitude / count)
   }

   
}
extension PropertyTVCell: GMSMapViewDelegate {
   
   func placeMarkerOnCenter(centerMapCoordinate:CLLocationCoordinate2D) {
       let marker = GMSMarker(position: centerMapCoordinate)
       marker.map = self.mapView
   }
   
   /* handles Info Window tap */
   func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
       print("didTapInfoWindowOf")
   }
   
   /* handles Info Window long press */
   func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
       print("didLongPressInfoWindowOf")
   }
   
   /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        propertyViewModelArr = PropertyViewModel(self)
        propertyViewModelArr?.rluDetailApi(UIApplication.visibleViewController.view, productNo: productNo, completion: { responseModel in
            if isLicensed == 1 {
                let btn = [ButtonText.ok.text]
                UIAlertController.showAlert("", message: "\(productNo) is currently not available", buttons: btn) { alert, index in
                    if index == 0 {
                    }
                }
                //               } else {
                //                   // Map Detail Pop Up View
                //                   self.viewTransition(self.mapDetailPopUpView)
                //
                //                   self.mapDetailPopUpView.displayNameLbl.text = responseModel.productNo
                //                   self.mapDetailPopUpView.countyLbl.text = responseModel.countyName! + " County, " + responseModel.stateName!
                //                   self.mapDetailPopUpView.acresLbl.text = responseModel.acres?.description
                //                   self.mapDetailPopUpView.priceLbl.text = "$" + "" + responseModel.licenseFee!.description
                //
                //                   // -- Set Image
                //                   if responseModel.imageFilename == nil {
                //                       self.mapDetailPopUpView.rluImageV.image = Images.logoImg.name
                //                   } else {
                //                       var str = (Apis.rluImageUrl) + responseModel.imageFilename!
                //                       if let dotRange = str.range(of: "?") {
                //                           str.removeSubrange(dotRange.lowerBound..<str.endIndex)
                //
                //                           str.contains(" ")
                //                           ? self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str.replacingOccurrences(of: " ", with: "%20"))
                //                           : self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str)
                //                       } else {
                //                           str.contains(" ")
                //                           ? self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str.replacingOccurrences(of: " ", with: "%20"))
                //                           : self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str)
                //                       }
                //                   }
                //
                //                   self.mapDetailPopUpView.rluImageV.actionBlock {
                //                       var data = [String: Any]()
                //                       data["publicKey"] = responseModel.publicKey
                //                       data["id"] = responseModel.productID
                //                       isComingFrom = "map"
                //                       LocalStore.shared.selectedPropertyIndex = self.tabBarController!.selectedIndex
                //                       UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
                //                   }
                //
                //                   // Cross Button
                //                   self.mapDetailPopUpView.crossBtn.actionBlock {
                //                       self.removeView(self.mapDetailPopUpView)
                //                   }
                //
                //                   // View Details
                //                   self.mapDetailPopUpView.viewDetailsBtn.actionBlock {
                //                       var data = [String: Any]()
                //                       data["publicKey"] = responseModel.publicKey
                //                       data["id"] = responseModel.productID
                //                       isComingFrom = "map"
                //                       LocalStore.shared.selectedPropertyIndex = self.tabBarController!.selectedIndex
                //                       UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
                //                   }
                //
                //                   // Zoom In
                //                   self.mapDetailPopUpView.zoomInBtn.actionBlock {
                //                       if zoom == true {
                //                           //  self.mapView.animate(toZoom: self.mapView.camera.zoom + 2)
                //                           zoom = false
                //                           self.mapDetailPopUpView.zoomLbl.text = "Zoom Out"
                //                           self.removeView(self.mapDetailPopUpView)
                //                           self.propertyCell.setSpecificPolygonApi(responseModel.productNo!)
                //                       } else {
                //                           self.propertyCell.mapView.animate(toZoom: self.propertyCell.mapView.camera.zoom - 2)
                //                           zoom = true
                //                           self.mapDetailPopUpView.zoomLbl.text = "Zoom In"
                //                           self.removeView(self.mapDetailPopUpView)
                //                       }
                //                   }
                //
                //                   // Directions
                //                   self.mapDetailPopUpView.directionsBtn.actionBlock {
                //                       //if checkLocationPermissions() {
                //                       //        print(locationDict.value(forKey: "Location")!)
                //                       //       print(index)
                //
                //                       //       let locationCoordinates = (locationDict.value(forKey: "Location")! as AnyObject).components(separatedBy: ",")
                //
                //                       // Create An UIAlertController with Action Sheet
                //                       let optionMenuController = UIAlertController(title: nil, message: "Choose Option for maps", preferredStyle: .actionSheet)
                //
                //                       // Create UIAlertAction for UIAlertController
                //                       let googleMaps = UIAlertAction(title: "Google Maps", style: .default, handler: {
                //                           (alert: UIAlertAction!) -> Void in
                //                           self.openGoogleDirectionMap(destinationLat: String(latitude), destinationLng: String(longitude))
                //                       })
                //
                //                       let appleMaps = UIAlertAction(title: "Apple Maps", style: .default, handler: {
                //                           (alert: UIAlertAction!) -> Void in
                //
                //                           print("self.latitude>>>", latitude)
                //                           print("self.longitude>>>", longitude)
                //
                //                           //                        let directionsURL = "http://maps.apple.com/maps?saddr=&daddr=\(self.latitude)\(self.longitude)"
                //                           let directionsURL = "https://maps.apple.com/?daddr=\(latitude),\(longitude)"
                //                           guard let url = URL(string: directionsURL) else {
                //                               return
                //                           }
                //                           if #available(iOS 10.0, *) {
                //                               UIApplication.shared.open(url, options: [:], completionHandler: nil)
                //                           } else {
                //                               UIApplication.shared.openURL(url)
                //                           }
                //
                //
                //
                //                           // Pass the coordinate that you want here
                //                           //                        let coordinate = CLLocationCoordinate2DMake(self.latitude,self.longitude)
                //                           //                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
                //                           //                        mapItem.name = "Destination"
                //                           //                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                //
                //                           /*
                //
                //                            let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)))
                //                            source.name = self.productNo
                //
                //                            //let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(([longitudeString] as NSString).doubleValue), longitude: Double(([LatitudeString] as NSString).doubleValue))
                //
                //                            let locc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)
                //
                //                            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locc.latitude, longitude: locc.longitude)))
                //
                //                            destination.name = responseModel.countyName! + " County, " + responseModel.stateName!
                //
                //                            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                //
                //                            */
                //                       })
                //
                //                       let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                //                           (alert: UIAlertAction!) -> Void in
                //                           print("Cancel")
                //                       })
                //
                //                       // Add UIAlertAction in UIAlertController
                //                       optionMenuController.addAction(googleMaps)
                //                       optionMenuController.addAction(appleMaps)
                //                       optionMenuController.addAction(cancelAction)
                //
                //                       // Present UIAlertController with Action Sheet
                //                       self.present(optionMenuController, animated: true, completion: nil)
                //                       //   }
                //
                //                       //}
                //                   }
                //               }
            }
        })
        return UIView()
    }
   
   // MARK: - GMSMarker Dragging
   func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
       print("didBeginDragging")
   }
   func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
       print("didDrag")
   }
   func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
       print("didEndDragging")
   }
   
   // MARK: - GMSMarker position
   func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
       marker.position = coordinate
   }
   
   //MARK: - Animate PopUp
//    func viewTransition(_ addView: UIView) {
//        UIView.transition(with: UIApplication.visibleViewController.view, duration: 0.7, options: .transitionCrossDissolve, animations: {
//            UIApplication.visibleViewController.view.addSubview(addView)
//            self.viewConstraints(addView)
//        })
//    }
//
//    // -- Remove View From SuperView
//    func removeView(_ viewToRemove: UIView) {
//        DispatchQueue.main.async {
//            UIView.transition(with: UIApplication.visibleViewController.view, duration: 0.7, options: .transitionCrossDissolve, animations: {
//                viewToRemove.removeFromSuperview()
//            })
//        }
//    }
//
//    // -- Set PopUp View Constraints
//    func viewConstraints(_ View: UIView) {
//        View.translatesAutoresizingMaskIntoConstraints = false
//        View.leftAnchor.constraint(equalTo: UIApplication.visibleViewController.view.leftAnchor, constant: 0).isActive = true
//        View.rightAnchor.constraint(equalTo: UIApplication.visibleViewController.view.rightAnchor, constant: 0).isActive = true
//        View.widthAnchor.constraint(equalTo: UIApplication.visibleViewController.view.widthAnchor, constant: 0).isActive = true
//        View.bottomAnchor.constraint(equalTo: UIApplication.visibleViewController.view.bottomAnchor, constant: 0).isActive = true
//        View.heightAnchor.constraint(equalTo: UIApplication.visibleViewController.view.heightAnchor, multiplier: 1.0, constant: 0).isActive = true
//    }
}

// MARK: - SearchViewModelDelegate
extension PropertyTVCell {
   func pointLayerSuccessCalled() {
       //HUD.hide()
   }
   func pointLayerErrorCalled() {
       HUD.flash(.labeledError(title: "", subtitle: "error"), delay: 1.0)
   }
   func polyLayerSuccessCalled() {
       // HUD.hide()
   }
   func polyLayerErrorCalled() {
       HUD.flash(.labeledError(title: "", subtitle: "error"), delay: 1.0)
   }
   func multiPolygonSuccessCalled() {
       // HUD.hide
   }
   func multiPolygonErrorCalled() {
       HUD.hide()
       let btn = [ButtonText.ok.text]
       UIAlertController.showAlert(AppAlerts.propertyNotListed.title, message: AppErrors.propertyNotListed.localizedDescription, buttons: btn) { alert, index in
           if index == 0 {
           }
       }
   }
   func rluDetailSuccessCalled() {
       HUD.hide()
   }
   func rluDetailErrorCalled() {
       HUD.hide()
       let btn = [ButtonText.ok.text]
       UIAlertController.showAlert(AppAlerts.propertyNotListed.title, message: AppErrors.propertyNotListed.localizedDescription, buttons: btn, completion: nil)
   }
}
