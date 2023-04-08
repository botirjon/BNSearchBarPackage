//
//  BNSearchBarTextField.swift
//  BNSearchBar
//
//  Created by Botirjon Nasridinov on 30/12/22.
//

import Foundation
import UIKit

internal class BNSearchBarTextField: UITextField {
    
    private struct Attributes {
        static let leftViewSize: CGSize = .init(width: 20.33, height: 18.67)
        static let rightViewSize: CGSize = .init(width: 19.67, height: 19)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        let leftViewRect = self.leftViewRect(forBounds: bounds)
        let x = leftViewRect.maxX+6
        
        let rightViewRect = self.rightViewRect(forBounds: bounds)
        let width = rightViewRect.minX-x-8
        return .init(x: x, y: rect.minY, width: width, height: rect.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        let leftViewRect = self.leftViewRect(forBounds: bounds)
        let x = leftViewRect.maxX+6
        
        let rightViewRect = self.rightViewRect(forBounds: bounds)
        let width = rightViewRect.minX-x-8
        return .init(x: x, y: rect.minY, width: width, height: rect.size.height)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let y = (bounds.height-Attributes.leftViewSize.height)/2
        let origin: CGPoint = .init(x: 6, y: y)
        return .init(origin: origin, size: Attributes.leftViewSize)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let x = super.rightViewRect(forBounds: bounds).origin.x-6
        let y = (bounds.size.height-Attributes.rightViewSize.height)/2
        let origin: CGPoint = .init(x: x, y: y)
        return .init(origin: origin, size: Attributes.rightViewSize)
    }
}
