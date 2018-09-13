import UIKit

protocol StoryboardView: class {
    func xibSetup()
    func loadViewFromNib() -> UIView
    func layoutSubviews()
}

