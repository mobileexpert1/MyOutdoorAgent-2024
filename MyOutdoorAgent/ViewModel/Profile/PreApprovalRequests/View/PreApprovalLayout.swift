//  PreApprovalLayout.swift
//  MyOutdoorAgent
//  Created by CS on 12/09/22.

import UIKit

class PreApprovalLayout {
    
    // -- Set Layout in main view class
    func setLayout(_ collectionV: UICollectionView) {
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
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-10, height: collectionV.frame.height - 150)
            default:
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-10, height: collectionV.frame.width/2+100)
            }
        }
        flowLayout.invalidateLayout()
    }
    
    // -- Set Layout in cell class
    func setCollectionLayout(_ collectionView: UICollectionView, _ collectionViewLayout: UICollectionViewLayout) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.height + 50)
            case .portrait, .portraitUpsideDown:
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2+100)
            default:
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2+100)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.height - 150)
            case .portrait, .portraitUpsideDown:
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2+100)
            default:
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2+100)
            }
        }
        collectionViewLayout.invalidateLayout()
        return CGSize()
    }
}
