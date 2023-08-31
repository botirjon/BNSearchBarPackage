//
//  BNSearchBar.swift
//  BNSearchBar
//
//  Created by Botirjon Nasridinov on 29/12/22.
//

import Foundation
import UIKit


open class BNSearchBar: UIControl {
    
    struct DefaultAttributes {
        static let placeholderColor = UIColor.init(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6) // UIColor.gray
        static let textColor = UIColor.black
        static let font = UIFont.systemFont(ofSize: 17)
        static let searchFieldBackgroundColor = UIColor.init(red: 118/255, green: 118/255, blue: 128/255, alpha: 0.12)
        static let cancelButtonPadding: CGFloat = 12
    }
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
//        containerView.isUserInteractionEnabled = false
        return containerView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = BNSearchBarTextField.init()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = DefaultAttributes.textColor
        textField.font = DefaultAttributes.font
        textField.leftViewMode = .always
        textField.leftView = searchImageView
        textField.rightViewMode = .never
        textField.rightView = clearButton
        textField.layer.cornerRadius = 10
        textField.backgroundColor = DefaultAttributes.searchFieldBackgroundColor
        textField.delegate = searchTextFieldDelegate // self
        textField.returnKeyType = .search
        textField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var searchTextFieldDelegate: BNSearchBarTextFieldDelegate = {
        let delegate = BNSearchBarTextFieldDelegate(searchBar: self)
        delegate.didEndEditingHandler = {
            self.updateCancelButtonColor(isActive: false)
        }
        delegate.searchBarDelegate = self.delegate
        delegate.didBeginEditingHandler = {
            self.updateCancelButtonColor(isActive: true)
        }
        return delegate
    }()
    
    private lazy var searchImageView: UIImageView = {
        let leftView = UIImageView()
        leftView.tintColor = placeholderColor
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.contentMode = .scaleAspectFit
        let img = UIImage(systemName: "magnifyingglass")
        leftView.image = img?.withRenderingMode(.alwaysTemplate)
        return leftView
    }()
    
    private lazy var clearButton: UIButton = {
        let button = BNSearchBarButton()
        let img = UIImage(systemName: "xmark.circle.fill")
        button.setImage(img?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = DefaultAttributes.placeholderColor
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = BNSearchBarButton()
        
        let bundle = Bundle.init(identifier: "com.apple.UIKit") ?? Bundle.init(for: BNSearchBar.self)
        
        let title = NSLocalizedString("Cancel", tableName: nil, bundle: bundle, value: "", comment: "")
        button.setTitle(title, for: .normal)
        button.tintColor = self.tintColor
        button.setTitleColor(self.tintColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = !_showsCancelButton
        return button
    }()
    
    
    private var _placeholderColor: UIColor? = DefaultAttributes.placeholderColor {
        didSet {
            setPlaceholder(self.placeholder)
            searchImageView.tintColor = _placeholderColor
            clearButton.tintColor = _placeholderColor
            searchTextField.rightView?.tintColor = _placeholderColor
            searchTextField.leftView?.tintColor = _placeholderColor
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initSearchBar()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initSearchBar()
    }
    
    private var searchTextFieldWidth: NSLayoutConstraint!
    
    private func initSearchBar() {
        addSubview(containerView)
        containerView.addSubview(searchTextField)
        containerView.addSubview(cancelButton)

        searchTextFieldWidth = searchTextField.widthAnchor.constraint(equalTo: searchTextField.superview!.widthAnchor)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: containerView.superview!.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: containerView.superview!.centerYAnchor),
            containerView.heightAnchor.constraint(equalTo: containerView.superview!.heightAnchor),
            containerView.widthAnchor.constraint(equalTo: containerView.superview!.widthAnchor),
            
            searchTextFieldWidth,
            searchTextField.heightAnchor.constraint(equalTo: searchTextField.superview!.heightAnchor),
            searchTextField.centerYAnchor.constraint(equalTo: searchTextField.superview!.centerYAnchor),
            searchTextField.leftAnchor.constraint(equalTo: searchTextField.superview!.leftAnchor),
            
            cancelButton.centerYAnchor.constraint(equalTo: cancelButton.superview!.centerYAnchor),
            cancelButton.leftAnchor.constraint(equalTo: searchTextField.rightAnchor, constant: DefaultAttributes.cancelButtonPadding)
        ])
        
        clearButton.addTarget(self, action: #selector(clearButtonTapped(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        self.containerView.isUserInteractionEnabled = true
        self.containerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTap)))
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    open override var intrinsicContentSize: CGSize {
        .init(width: UIScreen.main.bounds.size.width, height: 36)
    }
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        self.cancelButton.setTitleColor(tintColor, for: .normal)
        self.cancelButton.tintColor = self.tintColor
    }
    
    private var rightViewMode: UITextField.ViewMode {
        let text = self.text ?? ""
        return text.isEmpty ? .never : .always
    }
    
    private func updateRightViewVisibility() {
        self.searchTextField.rightViewMode = rightViewMode
    }
    
    private func updateCancelButtonColor(isActive: Bool = false) {
        let isActive = self.searchTextField.isFirstResponder
        let color = isActive ? tintColor : self.placeholderColor
        self.cancelButton.tintColor = color
        self.cancelButton.setTitleColor(color, for: .normal)
        
    }
    
    @objc private func didTap() {
        if !searchTextField.isFirstResponder {
            searchTextField.becomeFirstResponder()
        }
    }
    
    @objc private func cancelButtonTapped() {
        didTap()
        delegate?.searchBarCancelButtonClicked(self)
    }
    
    @objc private func clearButtonTapped(_ sender: UIButton) {
        self.text = nil
        self.delegate?.searchBar(self, textDidChange: "")
    }
    
    @objc private func editingChanged(_ sender: BNSearchBarTextField) {
        let text = self.text ?? ""
        self.delegate?.searchBar(self, textDidChange: text)
        self.sendActions(for: .editingChanged)
        self.updateRightViewVisibility()
    }
    
    private func setPlaceholder(_ placeholder: String?) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: self.font,
            .foregroundColor: self.placeholderColor ?? DefaultAttributes.placeholderColor
        ]
        
        let attributedPlaceholder = NSMutableAttributedString(string: placeholder ?? "", attributes: attributes)
        
        searchTextField.attributedPlaceholder = attributedPlaceholder
    }
    
    open override var backgroundColor: UIColor? {
        set {
            super.backgroundColor = .clear
            searchTextField.backgroundColor = newValue
        }
        get {
            searchTextField.backgroundColor
        }
    }
    
    private var _showsCancelButton: Bool = false
    
    open var showsCancelButton: Bool {
        set {
            _showsCancelButton = newValue
            updateSubviews(updateCancelButtonVisibility: true)
        }
        get {
            _showsCancelButton
        }
    }
    
    private func updateSubviews(updateCancelButtonVisibility: Bool = false) {
        containerView.layoutIfNeeded()
        cancelButton.sizeToFit()
        if _showsCancelButton {
            let buttonWidth = cancelButton.bounds.size.width
            searchTextFieldWidth.constant = -(buttonWidth+DefaultAttributes.cancelButtonPadding)
        } else {
            searchTextFieldWidth.constant = 0
        }
        if updateCancelButtonVisibility {
            cancelButton.isHidden = !_showsCancelButton
        }
    }
    
    open func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        
        self._showsCancelButton = showsCancelButton
        if animated {
            updateSubviews(updateCancelButtonVisibility: _showsCancelButton)
            UIView.animate(withDuration: 0.35, delay: 0, options: []) {
                self.layoutIfNeeded()
            } completion: { _ in
                if !self._showsCancelButton {
                    self.cancelButton.isHidden = true
                }
            }
        } else {
            self.updateSubviews(updateCancelButtonVisibility: true)
        }
    }
    
    open var delegate: BNSearchBarDelegate? {
        didSet {
            searchTextFieldDelegate.searchBarDelegate = delegate
        }
    }
}


// API
public extension BNSearchBar {
    
    var text: String? {
        set {
            searchTextField.text = newValue
            updateRightViewVisibility()
        }
        get {
            searchTextField.text
        }
    }
    
    var font: UIFont {
        set {
            searchTextField.font = newValue
        }
        get {
            searchTextField.font ?? DefaultAttributes.font
        }
    }
    
    var placeholder: String? {
        set {
            setPlaceholder(newValue)
        }
        get {
            searchTextField.attributedPlaceholder?.string
        }
    }
    
    var placeholderColor: UIColor? {
        set {
            _placeholderColor = newValue
        }
        get {
            _placeholderColor
        }
    }
    
    var textColor: UIColor? {
        set {
            searchTextField.textColor = newValue
        }
        get {
            searchTextField.textColor
        }
    }
    
    var searchIcon: UIImage? {
        set {
            searchImageView.image = newValue
        }
        get {
            searchImageView.image
        }
    }
    
    var rightView: UIView? {
        set {
            searchTextField.rightView = newValue
        }
        get {
            searchTextField.rightView
        }
    }
}

class BNSearchBarTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var searchBar: BNSearchBar
    
    init(searchBar: BNSearchBar) {
        self.searchBar = searchBar
        super.init()
    }
    
    var searchBarDelegate: BNSearchBarDelegate?
    var didBeginEditingHandler: (() -> Void)?
    var didEndEditingHandler: (() -> Void)?
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool  {
        searchBarDelegate?.searchBarShouldBeginEditing(searchBar) ?? true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        searchBarDelegate?.searchBarTextDidBeginEditing(searchBar)
        didBeginEditingHandler?()
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        searchBarDelegate?.searchBarShouldEndEditing(searchBar) ?? true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchBarDelegate?.searchBarTextDidEndEditing(searchBar)
        didEndEditingHandler?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchBarDelegate?.searchBar(searchBar, shouldChangeTextIn: range, replacementText: string) ?? true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBarDelegate?.searchBarSearchButtonClicked(searchBar)
        return true
    }
}

//extension BNSearchBar: UITextFieldDelegate {
//
////    private func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool  {
////        delegate?.searchBarShouldBeginEditing(self) ?? true
////    }
////
////
////    private func textFieldDidBeginEditing(_ textField: UITextField)  {
////        delegate?.searchBarTextDidBeginEditing(self)
////        updateCancelButtonColor(isActive: true)
////    }
////
////
////    private func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
////        delegate?.searchBarShouldEndEditing(self) ?? true
////    }
////
////
////    private func textFieldDidEndEditing(_ textField: UITextField) {
////        delegate?.searchBarTextDidEndEditing(self)
////        updateCancelButtonColor(isActive: false)
////    }
////
//////    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) // if implemented, called in place of textFieldDidEndEditing:
////
////
////
////    private func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////        delegate?.searchBar(self, shouldChangeTextIn: range, replacementText: string) ?? true
////    }
////
////
////
//////    func textFieldDidChangeSelection(_ textField: UITextField) {
//////
//////    }
//////
//////
//////
//////    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//////
//////    }
////
////
////    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        delegate?.searchBarSearchButtonClicked(self)
////        return true
////    }
////
//
//
////    func textField(_ textField: UITextField, editMenuForCharactersIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu?
////
////
////    func textField(_ textField: UITextField, willPresentEditMenuWith animator: UIEditMenuInteractionAnimating)
////
////
////
////    func textField(_ textField: UITextField, willDismissEditMenuWith animator: UIEditMenuInteractionAnimating)
//}
//
//
