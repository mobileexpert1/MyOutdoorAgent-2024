//  MyLicensesLayout.swift
//  MyOutdoorAgent
//  Created by CS on 08/09/22.

import UIKit

class MyLicensesLayout {
    
    // MARK: -  Set at ViewWillLayoutSubviews
    func setLayout(_ collectionV : UICollectionView) {
        guard let flowLayout = collectionV.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-10, height: collectionV.frame.height + 50)
            default:
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-10, height: collectionV.frame.width/2+100)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-10, height: collectionV.frame.height - 100)
            default:
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-10, height: collectionV.frame.width/2+60)
            }
        }
        flowLayout.invalidateLayout()
    }
}

