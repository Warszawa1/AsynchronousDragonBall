//
//  UIControl+Combine.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//

import UIKit
import Combine

extension UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher {
        return UIControlPublisher(control: self, events: events)
    }
}

struct UIControlPublisher: Publisher {
    typealias Output = Void
    typealias Failure = Never
    
    private let control: UIControl
    private let events: UIControl.Event
    
    init(control: UIControl, events: UIControl.Event) {
        self.control = control
        self.events = events
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, events: events)
        subscriber.receive(subscription: subscription)
    }
}

private final class UIControlSubscription<S: Subscriber>: Subscription where S.Input == Void, S.Failure == Never {
    private var subscriber: S?
    private let control: UIControl
    private let events: UIControl.Event
    
    init(subscriber: S, control: UIControl, events: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        self.events = events
        
        control.addTarget(self, action: #selector(handleEvent), for: events)
    }
    
    func request(_ demand: Subscribers.Demand) {
        // No implementation needed
    }
    
    func cancel() {
        subscriber = nil
        control.removeTarget(self, action: #selector(handleEvent), for: events)
    }
    
    @objc private func handleEvent() {
        _ = subscriber?.receive(())
    }
}

// Presentation/Common/Extensions/UITextField+Combine.swift

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { _ in self.text ?? "" }
            .eraseToAnyPublisher()
    }
}
