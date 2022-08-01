//
//  Utils.swift
//  
//
//  Created by Krzysztof Kryniecki on 01/08/2022.
//

import UIKit

extension UITableViewCell {
  func round(corners: UIRectCorner, withRadius radius: CGFloat) {
    let mask = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let shape = CAShapeLayer()
    shape.frame = self.bounds
    shape.path = mask.cgPath
    self.layer.mask = shape
  }
}
