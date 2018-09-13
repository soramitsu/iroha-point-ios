import UIKit

protocol KeyboardToolbarDelegate: class {
    func didPressDoneButton()
}

class KeyboardToolbar: UIToolbar {
    private var doneButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
    }()

    weak var keyboardDelegate: KeyboardToolbarDelegate?

    init() {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 44.0))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setItems([flexibleButton, self.doneButton], animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tappedDone() {
        self.keyboardDelegate?.didPressDoneButton()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
