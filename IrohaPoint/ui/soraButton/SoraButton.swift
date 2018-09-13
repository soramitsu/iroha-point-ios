import UIKit

@IBDesignable
class SoraButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = min(frame.height, frame.width) / 2.0
    }

    func setActive(with color: UIColor) {
        isEnabled = true
        backgroundColor = color
    }

    func setInactive(with color: UIColor) {
        isEnabled = false
        backgroundColor = color
    }
}
