//  AmenitiesCVCell.swift
//  MyOutdoorAgent
//  Created by CS on 28/09/22.

import UIKit

class AmenitiesCVCell: UICollectionViewCell {
    
    // MARK: - Objects
    var amenitiesArr = [GetAllAmenitiesModelClass]()
    var activitiesArr = [GetAllAmenitiesModelClass]()
    
    // MARK: - Variables
    var selectedAmenitiesArr = [String]()
    
    // MARK: - Override Variables
    // Override isSelected property of collectionview
    override var isSelected: Bool {
        didSet {
            self.isSelected == true
            ? (checkImgV.isHidden = false)
            : (checkImgV.isHidden = true)
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var amenitiesImgV: UIImageView!
    @IBOutlet weak var amenitiesLbl: UILabel!
    @IBOutlet weak var amenitiesV: UIView!
    @IBOutlet weak var checkImgV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedAmenitiesArr.removeAll()
    }
    
    // MARK: - Functions
    // -- Set up Amenities CollectionView delegates and datasource
    func setUpAmenitiesCollectionCell(_ collection : UICollectionView, _ responseModel : [GetAllAmenitiesModelClass], _ tag : Int, _ collectionViewHeight: NSLayoutConstraint) {
        collection.delegate = self
        collection.dataSource = self
        collection.tag = tag
        amenitiesArr = responseModel
        
        var amenitiesIndexArr = [Int]()
        for i in 0..<self.amenitiesArr.count {
            if (self.amenitiesArr[i].amenityType == CommonKeys.activity.name){
                amenitiesIndexArr.append(i)
            }
        }
        self.amenitiesArr.remove(at: amenitiesIndexArr)
        collectionViewHeight.constant = CGFloat(10 + Int(90*amenitiesArr.count)/3)
    }
    
    // -- Set up Activities CollectionView delegates and datasource
    func setUpActivitiesCollectionCell(_ collection : UICollectionView, _ responseModel : [GetAllAmenitiesModelClass], _ tag : Int, _ collectionViewHeight: NSLayoutConstraint) {
        collection.delegate = self
        collection.dataSource = self
        collection.tag = tag
        activitiesArr = responseModel
        
        var activityIndexArr = [Int]()
        for i in 0..<self.activitiesArr.count {
            if (self.activitiesArr[i].amenityType == CommonKeys.amenity.name){
                activityIndexArr.append(i)
            }
        }
        self.activitiesArr.remove(at: activityIndexArr)
        collectionViewHeight.constant = CGFloat(10 + Int(90*activitiesArr.count)/3)
    }
}

// MARK: - UICollectionViewDelegates and UICollectionViewDatasource
extension AmenitiesCVCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return activitiesArr.count
        } else {
            return amenitiesArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = configureCell(collectionView, indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            for index in 0..<activitiesArr.count {
                if indexPath.row == index {
                    selectedAmenitiesArr.append(activitiesArr[index].amenityName!)
                }
            }
        } else {
            for index in 0..<amenitiesArr.count {
                if indexPath.row == index {
                    selectedAmenitiesArr.append(amenitiesArr[index].amenityName!)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            for (index, value) in self.selectedAmenitiesArr.enumerated() {
                if value == activitiesArr[indexPath.row].amenityName {
                    selectedAmenitiesArr.remove(at: index)
                }
            }
        } else {
            for (index, value) in self.selectedAmenitiesArr.enumerated() {
                if value == amenitiesArr[indexPath.row].amenityName {
                    selectedAmenitiesArr.remove(at: index)
                }
            }
        }
    }
}

// MARK: - ConfigureCell
extension AmenitiesCVCell {
    func configureCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> UICollectionViewCell {
        let dequeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCells.amenitiesCVCell.name, for: indexPath)
        guard let cell = dequeCell as? AmenitiesCVCell else { return UICollectionViewCell() }
        
        collectionView.tag == 0
        ? (setActivitiesView(cell, activitiesArr, indexPath, collectionView, self))
        : (setAmenitiesView(cell, amenitiesArr, indexPath, collectionView, self))
        
        return cell
    }
}
