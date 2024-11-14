//  PropertyHeaderTVCell.swift
//  MyOutdoorAgent
//  Created by CS on 29/08/22.

import UIKit

class PropertyHeaderTVCell: UITableViewCell, UIScrollViewDelegate {
    
    // MARK: - Variables
    var currentPage = 0
    
    // MARK: - Outlets
    @IBOutlet weak var customNavBar: CustomNavBar!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var selectBtnText: UILabel!
    @IBOutlet weak var logoImgV: UIImageView!
    @IBOutlet weak var dayPassV: UIView!
    @IBOutlet weak var dayPassLbl: UILabel!
    @IBOutlet weak var availableLbl: UILabel!
    @IBOutlet weak var availableView: UIView!
    @IBOutlet weak var topHeaderImgHeight: NSLayoutConstraint!
    @IBOutlet weak var backImgBtn: UIImageView!
    var viewController: UIViewController? 
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        setDelegates()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setUI()
    }
    
    private func setDelegates() {
        collectionV.isPagingEnabled = true
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.reloadData()
    }
    
    private func registerCell() {
        collectionV.register(UINib(nibName: CustomCells.propertyHeaderCVCell.name, bundle: nil), forCellWithReuseIdentifier: CustomCells.propertyHeaderCVCell.name)
    }
    
    private func setUI() {
        //  UIApplication.visibleViewController.setcustomNav(customView: customNavBar, titleIsHidden: false, navViewColor: .clear, mainViewColor: .clear, backImg: Images.backimg.name)
        
        backImgBtn.actionBlock {
            if LocalStore.shared.selectedPropertyIndex == 0 || LocalStore.shared.selectedPropertyIndex == 1 {
                UIApplication.visibleViewController.navigationController?.popToRootViewController(animated: true)
                if let tab = UIApplication.visibleViewController.tabBarController {
                    tab.selectedIndex = LocalStore.shared.selectedPropertyIndex
                }
            } else {
               // UIApplication.visibleViewController.popToSpecificVCs(Storyboards.preApprovalReqView.name, Controllers.preApprovalReq.name)
                UIApplication.visibleViewController.popToSpecificVCs(Controllers.preApprovalReq.name)
                
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    // MARK: - Auto Scroll Action
    @objc func scrollAutomatically(_ timer1: Timer) {
        if let coll  = collectionV {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < propertyImagesArr.count - 1) {
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                } else {
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
            }
        }
        print("===-=-=====-=-=-=-==-/////?//??/???????????????????//';';")
    }
    
    // MARK: - Page Control Action
    @IBAction func pageControlClick(_ sender: UIPageControl) {
        self.collectionV.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension PropertyHeaderTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        propertyImagesArr.count == 0
        ? (logoImgV.isHidden = false)
        : (logoImgV.isHidden = true)
        return propertyImagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = configureCell(collectionView, indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PropertyHeaderTVCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - ConfigureCell
extension PropertyHeaderTVCell {
    func configureCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> UICollectionViewCell {
        let dequeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCells.propertyHeaderCVCell.name, for: indexPath)
        guard let cell = dequeCell as? PropertyHeaderCVCell else { return UICollectionViewCell() }
        
        // -- Set Image
        var str = (Apis.rluImageUrl) + propertyImagesArr[indexPath.row]
        if let dotRange = str.range(of: "?") {
            str.removeSubrange(dotRange.lowerBound..<str.endIndex)
            
            str.contains(" ")
            ? cell.propertyImgV.setNetworkImage(cell.propertyImgV, str.replacingOccurrences(of: " ", with: "%20"))
            : cell.propertyImgV.setNetworkImage(cell.propertyImgV, str)
            
        } else {
            str.contains(" ")
            ? cell.propertyImgV.setNetworkImage(cell.propertyImgV, str.replacingOccurrences(of: " ", with: "%20"))
            : cell.propertyImgV.setNetworkImage(cell.propertyImgV, str)
        }
        if cell.propertyImgV.image == UIImage(named: "") {
            cell.propertyImgV.image = UIImage(named: "logoFull")
        }
        pageControl.numberOfPages = propertyImagesArr.count
        return cell
    }
}

// MARK: - ScrollView delegate method
extension PropertyHeaderTVCell {
    //-- ScrollViewDidScroll Method
    
    //ScrollViewDidEndDecelerating Method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    //ScrollViewDidEndScrollingAnimation Method
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}


