import UIKit

struct AppDesign {
    struct color {
        static let MAIN_COLOR = UIColor(red: 227.0/255.0,
                                        green: 30.0/255.0,
                                        blue: 53.0/255.0,
                                        alpha: 1)
    }

    struct gradient {
        static var RED: CAGradientLayer {
            let gradient = CAGradientLayer()

            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

            let fromColor = UIColor.init(red: 177.0/255.0,
                                         green: 32.0/255.0,
                                         blue: 0.0/255.0,
                                         alpha: 1)

            let toColor = UIColor.init(red: 254.0/255.0,
                                       green: 124.0/255.0,
                                       blue: 90.0/255.0,
                                       alpha: 1)

            gradient.colors = [fromColor.cgColor, toColor.cgColor]
            return gradient
        }

        static var ORANGE: CAGradientLayer {
            let gradient = CAGradientLayer()

            let fromColor = UIColor.init(red: 224.0/255.0,
                                         green: 169.0/255.0,
                                         blue: 32.0/255.0,
                                         alpha: 1)

            let toColor = UIColor.init(red: 250.0/255.0,
                                       green: 210.0/255.0,
                                       blue: 0.0/255.0,
                                       alpha: 1)

            gradient.colors = [fromColor.cgColor, toColor.cgColor]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

            return gradient
        }

        static var GREEN: CAGradientLayer {
            let gradient = CAGradientLayer()

            let fromColor = UIColor.init(red: 0.0/255.0,
                                         green: 168.0/255.0,
                                         blue: 186.0/255.0,
                                         alpha: 1)

            let toColor = UIColor.init(red: 18.0/255.0,
                                       green: 186.0/255.0,
                                       blue: 100.0/255.0,
                                       alpha: 1)

            gradient.colors = [fromColor.cgColor, toColor.cgColor]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

            return gradient
        }

        static var GRAY: CAGradientLayer {
            let gradient = CAGradientLayer()

            let fromColor = UIColor.init(red: 240.0/255.0,
                                         green: 240.0/255.0,
                                         blue: 240.0/255.0,
                                         alpha: 1)

            let toColor = UIColor.init(red: 253.0/255.0,
                                       green: 253.0/255.0,
                                       blue: 253.0/255.0,
                                       alpha: 1)

            gradient.colors = [fromColor.cgColor, toColor.cgColor]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

            return gradient
        }
    }

    struct size {
        static let ACCOUNT_INFO_FRAME = CGRect(x: 0,
                                               y: 0,
                                               width: UIScreen.main.bounds.size.width,
                                               height: 50)
    }
}
