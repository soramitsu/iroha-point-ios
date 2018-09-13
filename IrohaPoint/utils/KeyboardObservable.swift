import Foundation

enum KeyboardEvent {
    case willShow
    case didShow
    case willHide
    case didHide
}

@objc protocol KeyboardObservable {
    @objc optional func keyboardWillShow(with notification: Notification)
    @objc optional func keyboardDidShow(with notification: Notification)
    @objc optional func keyboardWillHide(with notification: Notification)
    @objc optional func keyboardDidHide(with notification: Notification)
}

extension KeyboardObservable {

    func observe(keyboardEvent: KeyboardEvent) {
        switch keyboardEvent {
        case .willShow:
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillShow(with:)),
                                                   name: .UIKeyboardWillShow,
                                                   object: nil)
        case .didShow:
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardDidShow(with:)),
                                                   name: .UIKeyboardDidShow,
                                                   object: nil)
        case .willHide:
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillHide(with:)),
                                                   name: .UIKeyboardWillHide,
                                                   object: nil)
        case .didHide:
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardDidHide(with:)),
                                                   name: .UIKeyboardDidHide,
                                                   object: nil)
        }
    }

    func removeObserving(ofKeyboardEvent keyboardEvent: KeyboardEvent) {
        switch keyboardEvent {
        case .willShow:
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        case .didShow:
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        case .willHide:
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        case .didHide:
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
        }
    }

    func observe(keyboardEvents: [KeyboardEvent]) {
        for event in keyboardEvents {
            observe(keyboardEvent: event)
        }
    }

    func removeObserving(of keyboardEvents: [KeyboardEvent]) {
        for event in keyboardEvents {
            removeObserving(ofKeyboardEvent: event)
        }
    }
}
