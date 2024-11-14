//  UIImageView.swift
//  MyOutdoorAgent
//  Created by CS on 01/09/22.

import UIKit
import SDWebImage

extension UIImageView {
    // -- SDWebImage Loader
    func setNetworkImage(_ imageContainer: UIImageView, _ imageStrUrl: String){
        imageContainer.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageContainer.sd_imageIndicator?.startAnimatingIndicator()
        imageContainer.sd_setImage(with: URL(string: imageStrUrl), placeholderImage: nil)
    }
}
