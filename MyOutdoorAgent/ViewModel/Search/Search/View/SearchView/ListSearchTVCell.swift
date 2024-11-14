//  ListSearchTVCell.swift
//  MyOutdoorAgent
//  Created by CS on 22/12/22.

import UIKit

class ListSearchTVCell: UITableViewCell {

    var imgArr = [String]()
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var listTopHeaderImg: UIImageView!
    @IBOutlet weak var listImgV: UIImageView!
    @IBOutlet weak var listDisplayNameLbl: UILabel!
    @IBOutlet weak var listLocationLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var licenseStartDate: UILabel!
    @IBOutlet weak var acresLbl: UILabel!
    @IBOutlet weak var listBtnV: UIView!
    @IBOutlet weak var amenitiesCV: UICollectionView!
    @IBOutlet weak var availableLbl: UILabel!
    @IBOutlet weak var licenseTermLbl: UILabel!
    @IBOutlet weak var preApprovalLbl: UILabel!
    @IBOutlet weak var topImageHeight: NSLayoutConstraint!
    @IBOutlet weak var topImageWidth: NSLayoutConstraint!
    @IBOutlet weak var topImageLeading: NSLayoutConstraint!
    @IBOutlet weak var availableHeight: NSLayoutConstraint!
    @IBOutlet weak var preApprovalHeight: NSLayoutConstraint!
    @IBOutlet weak var availableBottom: NSLayoutConstraint!
    @IBOutlet weak var locationBottom: NSLayoutConstraint!
    @IBOutlet weak var mapBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logoImg.layer.cornerRadius = 5
        logoImg.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func getImages(_ imgsArr: [String], collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: CustomCells.amenitiesListCVCell.name, bundle: nil), forCellWithReuseIdentifier: CustomCells.amenitiesListCVCell.name)
        imgArr = imgsArr
        collectionView.dataSource = self
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView Delegates and DataSource
extension ListSearchTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = configureCell(collectionView, indexPath)
        return cell
    }
}

// MARK: - ConfigureCell
extension ListSearchTVCell {
    func configureCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> UICollectionViewCell {
        let dequeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCells.amenitiesListCVCell.name, for: indexPath)
        guard let cell = dequeCell as? AmenitiesListCVCell else { return UICollectionViewCell() }
        cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, (Apis.amenitiesUrl + "/icon/" +  imgArr[indexPath.row]))
        return cell
    }
}
