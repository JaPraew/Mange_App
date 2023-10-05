//
//  Image+Extension.swift
//  Manage_App
//
//  Created by Pare on 1/10/2566 BE.
//

import Foundation
import UIKit

extension UIImage {
    func resize(tragetSize: CGSize) -> UIImage {
        let rect = CGRect(x:0, y: 0, width: tragetSize.width, height: tragetSize.height)
        UIGraphicsBeginImageContextWithOptions(tragetSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}
