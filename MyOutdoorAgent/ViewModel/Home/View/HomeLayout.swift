//  HomeLayout.swift
//  MyOutdoorAgent
//  Created by CS on 24/09/22.

import UIKit

class HomeLayout {
    
    // MARK: -  Set at ViewWillLayoutSubviews
    // -- Title CollectionView
    func setLayoutTitleCV(_ collectionV : UICollectionView) {
        guard let flowLayout = collectionV.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2, height: collectionV.frame.height/2+5)
            default:
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-90, height: collectionV.frame.width/2+5)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-180, height: collectionV.frame.height)
            default:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-180, height: collectionV.frame.height)
                }
            }
        }
        flowLayout.invalidateLayout()
    }
    
    // -- List CollectionView
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
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-10, height: collectionV.frame.height/2-140)
            default:
                flowLayout.itemSize = CGSize(width: collectionV.frame.width/2-10, height: collectionV.frame.width/2)
            }
        }
        flowLayout.invalidateLayout()
    }
    
    // -- Set Title CollectionView Layout in cell class
    func setTitleCollectionLayout(_ collectionView: UICollectionView, _ collectionViewLayout: UICollectionViewLayout) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                return CGSize(width: collectionView.frame.width/2-150, height: collectionView.frame.height/2+5)
            case .portrait, .portraitUpsideDown:
                return CGSize(width: collectionView.frame.width/2-90, height: collectionView.frame.height/2+5)
            default:
                return CGSize(width: collectionView.frame.width/2-90, height: collectionView.frame.height/2+5)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                return CGSize(width: collectionView.frame.width/2-180, height: collectionView.frame.height)
            default:
                return CGSize(width: collectionView.frame.width/2-180, height: collectionView.frame.height)
            }
        }
        collectionViewLayout.invalidateLayout()
        return CGSize()
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
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2-140)
            default:
                return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.width/2)
            }
        }
        collectionViewLayout.invalidateLayout()
        return CGSize()
    }
}
