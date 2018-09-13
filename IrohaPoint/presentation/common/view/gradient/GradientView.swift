import UIKit

class GradientView:  UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(frame: CGRect, backgroundGradient: CAGradientLayer){
        super.init(frame: frame)
        set(backgroundGradient: backgroundGradient)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func set(backgroundGradient: CAGradientLayer) {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        guard let background = layer as? CAGradientLayer else {
            return
        }

        background.colors = backgroundGradient.colors
        background.locations = backgroundGradient.locations
        background.startPoint = backgroundGradient.startPoint
        background.endPoint = backgroundGradient.endPoint
        background.frame = bounds
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

