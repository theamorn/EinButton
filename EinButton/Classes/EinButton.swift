//
//  EinButton.swift
//  EinButton
//
//  Created by Amorn Apichattanakul on 8/23/2560 BE.
//  Copyright © 2560 Theamorn. All rights reserved.
//

import UIKit

public protocol EinButtonDelegate: class {
    func valueDidChanged(to value: Int)
    func cannotAddMoreItem()
    
    // Convenience delegate functions to know which button is pressed
    func didTapPlus()
    func didTapMinus()
}

/// Optional delegate
extension EinButtonDelegate {
    public func cannotAddMoreItem() {}
    public func didTapPlus() {}
    public func didTapMinus() {}
}

@IBDesignable open class EinButton: UIView {
    private var title = UILabel()
    private var minusButton = UIButton()
    private var plusButton = UIButton()
    private var tap: UITapGestureRecognizer?
    public var isAllowToAddMore = true
    
    private enum Constant {
        static let margin: CGFloat = 10.0
    }
    
    weak public var delegate: EinButtonDelegate?
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 15.0) {
        didSet {
            title.font = titleFont
        }
    }
    
    @IBInspectable public var maximumNumberAllowed: Int = 99
    @IBInspectable public var defaultValue: Int = 0 {
        didSet {
            numberOfQuantity = defaultValue
            if numberOfQuantity > 0 {
                setItemToCart(with: defaultValue)
            }
        }
    }
    
    @IBInspectable public var titleTextColor: UIColor = .white {
        didSet {
            title.textColor = titleTextColor
        }
    }
    
    @IBInspectable public var iconImage: UIImage? {
        didSet {
            minusButton.setImage(iconImage, for: .normal)
        }
    }
    
    @IBInspectable public var buttonLabel: String = "" {
        didSet {
            title.text = buttonLabel
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    private var numberOfQuantity: Int = 0 {
        didSet {
            if numberOfQuantity == 0 {
                plusButton.removeFromSuperview()
                minusButton.removeFromSuperview()
                title.text = buttonLabel
                
                tap = UITapGestureRecognizer(target: self, action: #selector(addItemToCart(_:)))
                addGestureRecognizer(tap!)
            } else if numberOfQuantity == 1 {
                minusButton.setTitle(nil, for: .normal)
                minusButton.setImage(iconImage, for: .normal)
                title.text = "\(numberOfQuantity)"
            } else if numberOfQuantity > 1 {
                minusButton.setImage(nil, for: .normal)
                minusButton.setTitle("-", for: .normal)
                minusButton.titleEdgeInsets = UIEdgeInsets(top: -3, left: 0, bottom: 0, right: 0)
                title.text = "\(numberOfQuantity)"
            }
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let padding = CGFloat(20.0)
        let extendedBounds = bounds.insetBy(dx: -padding, dy: -padding)
        return extendedBounds.contains(point)
    }
    
    private func setup() {
        title.textColor = titleTextColor
        title.textAlignment = .center
        title.text = buttonLabel
        title.frame = bounds
        title.font = titleFont
        addSubview(title)
        let bundle = Bundle(for: EinButton.self).url(forResource: "EinButton", withExtension: "bundle")
        let bundlePath = Bundle(url: bundle!)
        iconImage = UIImage(named: "trash", in: bundlePath, compatibleWith: nil)
        minusButton.setImage(iconImage, for: .normal)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(addItemToCart(_:)))
        tap?.cancelsTouchesInView = false
        addGestureRecognizer(tap!)
    }
    
    @objc private func addItemToCart(_ gesture: UITapGestureRecognizer) {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        
        if isAllowToAddMore {
            setItemToCart(with: 1)
            delegate?.valueDidChanged(to: 1)
        } else {
            delegate?.cannotAddMoreItem()
        }
    }
    
    private func setItemToCart(with numberItems: Int) {
        removeAllGestures()
        
        let buttonWidth = frame.size.width / 2 - Constant.margin
        minusButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: frame.size.height)
        plusButton.setTitle("+", for: .normal)
        plusButton.titleEdgeInsets = UIEdgeInsets(top: -3, left: 0, bottom: 0, right: 0)
        plusButton.frame = CGRect(x: frame.width - buttonWidth, y: 0, width: buttonWidth, height: frame.size.height)
        
        numberOfQuantity = numberItems
        title.text = "\(numberOfQuantity)"
        
        addSubview(minusButton)
        addSubview(plusButton)
        
        minusButton.addTarget(self, action: #selector(valueDidChanged(_:)), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(valueDidChanged(_:)), for: .touchUpInside)
    }
    
    private func removeAllGestures() {
        guard let gestures = gestureRecognizers else { return }
        for recognizer in gestures {
            removeGestureRecognizer(recognizer)
        }
    }
    
    @objc private func valueDidChanged(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        
        if sender == plusButton {
            if numberOfQuantity < maximumNumberAllowed && isAllowToAddMore {
                numberOfQuantity += 1
                delegate?.didTapMinus()
            } else {
                delegate?.cannotAddMoreItem()
                return
            }
        } else if sender == minusButton {
            numberOfQuantity -= 1
            delegate?.didTapMinus()
        }
        
        delegate?.valueDidChanged(to: numberOfQuantity)
        
    }
}

