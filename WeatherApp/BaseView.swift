import Foundation
import UIKit



@IBDesignable
class BaseView: UIView {
    
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat = 0 {
        didSet {
            self.layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerrRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerrRadius
            self.clipsToBounds = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}

