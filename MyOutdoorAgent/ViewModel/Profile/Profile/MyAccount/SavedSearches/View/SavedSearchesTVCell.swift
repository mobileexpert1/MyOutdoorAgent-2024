//  SavedSearchesTVCell.swift
//  MyOutdoorAgent
//  Created by CS on 26/08/22.

import UIKit

class SavedSearchesTVCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var deleteBtn: UIImageView!
    @IBOutlet weak var viewBtn: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Functions
    // -- Set up delegates and datasource
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionV.delegate = dataSourceDelegate
        collectionV.dataSource = dataSourceDelegate
        collectionV.tag = row
        collectionV.reloadData()
    }
}
