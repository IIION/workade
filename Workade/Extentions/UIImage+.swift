//
//  UIImage+.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/18.
//

import UIKit

extension UIImage {
    func original() -> UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
}
