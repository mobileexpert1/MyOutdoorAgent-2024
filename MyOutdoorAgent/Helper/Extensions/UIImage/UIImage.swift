//  UIImage.swift
//  MyOutdoorAgent
//  Created by CS on 16/08/22.

import UIKit

extension UIImage {
    // -- IMAGE_TO_BASE64
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? EMPTY_STR
    }
}
