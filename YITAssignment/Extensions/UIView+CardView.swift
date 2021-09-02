//
//  UIView+CardView.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 02/09/2021.
//

import UIKit

extension UIView {
    func setupCardView(cRadius: CGFloat, sColor: CGColor, sOffset: CGSize, sRadius: CGFloat, sOpacity: Float) {
        self.layer.cornerRadius = cRadius
        self.layer.shadowColor = sColor
        self.layer.shadowOffset = sOffset
        self.layer.shadowRadius = sRadius
        self.layer.shadowOpacity = sOpacity
    }

}
