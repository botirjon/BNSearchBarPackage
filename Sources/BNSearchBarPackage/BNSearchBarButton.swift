//
//  BNSearchBarButton.swift
//  BNSearchBar
//
//  Created by Botirjon Nasridinov on 05/01/23.
//

import Foundation
import UIKit

internal class BNSearchBarButton: UIButton {
    
    private var _isFocused: Bool = false {
        didSet {
            let alpha = _isFocused ? 0.3 : 1
            titleLabel?.alpha = alpha
            imageView?.alpha = alpha
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgroundImage(UIImage(), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _isFocused = true
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _isFocused = false
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        _isFocused = false
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        _isFocused = false
        super.touchesCancelled(touches, with: event)
    }
}
