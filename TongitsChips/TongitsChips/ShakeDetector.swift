//
//  ShakeDetector.swift
//  TongitsChips
//
//  Created by Christian Galang on 7/5/25.
//

import SwiftUI
import Combine

class ShakeDetector: ObservableObject {
    @Published var didShake = false
    
    init() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(deviceShaken),
            name: .deviceDidShakeNotification,
            object: nil
        )
    }
    
    @objc private func deviceShaken() {
        didShake = true
    }
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: .deviceDidShakeNotification, object: nil)
        }
    }
}

extension Notification.Name {
    static let deviceDidShakeNotification = Notification.Name("deviceDidShakeNotification")
}
