import SwiftUI
import Combine

/// Dedicated programmatic controller for managing and animating a ``FanDeckOTPField``.
public final class FanDeckOTPController: ObservableObject {
    /// Current entered OTP text.
    @Published public var text: String = ""
    
    /// Incremented whenever ``triggerError()`` is called to drive the shake animation.
    @Published public private(set) var errorTrigger: Int = 0
    
    /// Target code length.
    public let length: Int

    public init(length: Int = 6, initialText: String = "") {
        self.length = length
        self.text = String(initialText.prefix(length))
    }

    /// Whether the user has entered all required digits.
    public var isComplete: Bool {
        text.count == length
    }

    /// Clears all entered digits.
    public func clear() {
        text = ""
    }

    /// Triggers the error shake animation and red glow.
    public func triggerError() {
        errorTrigger += 1
    }

    /// Programmatically sets the OTP code.
    public func setCode(_ code: String) {
        text = String(code.filter { $0.isNumber }.prefix(length))
    }
}
