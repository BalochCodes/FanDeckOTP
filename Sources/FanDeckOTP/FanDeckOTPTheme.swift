import SwiftUI

/// Visual styling and animation configuration for ``FanDeckOTPField``.
public struct FanDeckOTPTheme {
    /// Width of each OTP digit box.
    public var boxWidth: CGFloat
    
    /// Height of each OTP digit box.
    public var boxHeight: CGFloat
    
    /// Corner radius of the digit boxes.
    public var boxCornerRadius: CGFloat
    
    /// Spacing between individual digit boxes.
    public var boxSpacing: CGFloat
    
    /// Text color of the entered digits.
    public var textColor: Color
    
    /// Typography font of the digits.
    public var font: Font
    
    /// Background color of empty inactive boxes.
    public var backgroundColor: Color
    
    /// Background color of the currently active/focused box.
    public var activeBackgroundColor: Color
    
    /// Background color of boxes that already have a digit.
    public var filledBackgroundColor: Color
    
    /// Border color of empty inactive boxes.
    public var inactiveBorderColor: Color
    
    /// Border color of filled boxes when not active.
    public var filledBorderColor: Color
    
    /// Border color for active box when neon loader is disabled.
    public var activeBorderColor: Color
    
    /// Error border and glow color when validation fails.
    public var errorColor: Color
    
    /// Palette of colors for the rotating neon border loader.
    public var neonColors: [Color]
    
    /// Whether to display the animated rotating neon border around the active box.
    public var enableRotatingBorder: Bool
    
    /// Whether to trigger haptic feedback on keystrokes and errors (iOS only).
    public var enableHaptics: Bool
    
    /// Maximum fan deck spread angle in degrees during entrance animation.
    public var fanSpreadAngle: Double
    
    /// Duration of the playing-card fan entrance animation in seconds.
    public var fanDuration: Double

    public init(
        boxWidth: CGFloat = 48,
        boxHeight: CGFloat = 58,
        boxCornerRadius: CGFloat = 12,
        boxSpacing: CGFloat = 10,
        textColor: Color = .primary,
        font: Font = .system(size: 24, weight: .bold, design: .rounded),
        backgroundColor: Color = Color.primary.opacity(0.04),
        activeBackgroundColor: Color = Color.primary.opacity(0.08),
        filledBackgroundColor: Color = Color.primary.opacity(0.06),
        inactiveBorderColor: Color = Color.primary.opacity(0.12),
        filledBorderColor: Color = Color.primary.opacity(0.25),
        activeBorderColor: Color = Color(red: 0.176, green: 0.482, blue: 0.851),
        errorColor: Color = Color(red: 0.937, green: 0.267, blue: 0.267),
        neonColors: [Color] = [
            Color(red: 0.176, green: 0.482, blue: 0.851),
            Color(red: 0.0, green: 0.941, blue: 1.0),
            Color(red: 0.176, green: 0.482, blue: 0.851)
        ],
        enableRotatingBorder: Bool = true,
        enableHaptics: Bool = true,
        fanSpreadAngle: Double = 16.0,
        fanDuration: Double = 0.75
    ) {
        self.boxWidth = boxWidth
        self.boxHeight = boxHeight
        self.boxCornerRadius = boxCornerRadius
        self.boxSpacing = boxSpacing
        self.textColor = textColor
        self.font = font
        self.backgroundColor = backgroundColor
        self.activeBackgroundColor = activeBackgroundColor
        self.filledBackgroundColor = filledBackgroundColor
        self.inactiveBorderColor = inactiveBorderColor
        self.filledBorderColor = filledBorderColor
        self.activeBorderColor = activeBorderColor
        self.errorColor = errorColor
        self.neonColors = neonColors
        self.enableRotatingBorder = enableRotatingBorder
        self.enableHaptics = enableHaptics
        self.fanSpreadAngle = fanSpreadAngle
        self.fanDuration = fanDuration
    }
}
