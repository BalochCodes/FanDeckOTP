import SwiftUI
#if os(iOS)
import UIKit
#endif

/// A premium animated OTP & PIN input view for SwiftUI featuring a 2-stage playing card
/// fan-and-stack entrance animation, revolving neon border glow, and interactive error shake physics.
public struct FanDeckOTPField: View {
    @Binding public var text: String
    public let length: Int
    public let theme: FanDeckOTPTheme
    public let obscureText: Bool
    public let obscuringCharacter: String
    public let isLoading: Bool
    public let errorTrigger: Int
    public let autoFocus: Bool
    public let onChanged: ((String) -> Void)?
    public let onCompleted: ((String) -> Void)?

    @FocusState private var isFocused: Bool
    @State private var hasFannedOut: Bool = false
    @State private var shakeOffset: CGFloat = 0
    @State private var isErrorActive: Bool = false

    public init(
        text: Binding<String>,
        length: Int = 6,
        theme: FanDeckOTPTheme = FanDeckOTPTheme(),
        obscureText: Bool = false,
        obscuringCharacter: String = "•",
        isLoading: Bool = false,
        errorTrigger: Int = 0,
        autoFocus: Bool = false,
        onChanged: ((String) -> Void)? = nil,
        onCompleted: ((String) -> Void)? = nil
    ) {
        self._text = text
        self.length = max(2, length)
        self.theme = theme
        self.obscureText = obscureText
        self.obscuringCharacter = obscuringCharacter
        self.isLoading = isLoading
        self.errorTrigger = errorTrigger
        self.autoFocus = autoFocus
        self.onChanged = onChanged
        self.onCompleted = onCompleted
    }

    /// Convenience initializer using a ``FanDeckOTPController``.
    public init(
        controller: FanDeckOTPController,
        theme: FanDeckOTPTheme = FanDeckOTPTheme(),
        obscureText: Bool = false,
        obscuringCharacter: String = "•",
        isLoading: Bool = false,
        autoFocus: Bool = false,
        onChanged: ((String) -> Void)? = nil,
        onCompleted: ((String) -> Void)? = nil
    ) {
        self._text = Binding(
            get: { controller.text },
            set: { controller.text = $0 }
        )
        self.length = controller.length
        self.theme = theme
        self.obscureText = obscureText
        self.obscuringCharacter = obscuringCharacter
        self.isLoading = isLoading
        self.errorTrigger = controller.errorTrigger
        self.autoFocus = autoFocus
        self.onChanged = onChanged
        self.onCompleted = onCompleted
    }

    public var body: some View {
        ZStack {
            // Hidden native input to capture keyboard, SMS OTP auto-fill & paste events
            TextField("", text: Binding(
                get: { text },
                set: { newValue in
                    let filtered = String(newValue.filter { $0.isNumber }.prefix(length))
                    if filtered != text {
                        text = filtered
                        triggerHaptic(style: .light)
                        onChanged?(filtered)
                        if filtered.count == length {
                            triggerHaptic(style: .medium)
                            onCompleted?(filtered)
                        }
                    }
                }
            ))
            .focused($isFocused)
            #if os(iOS)
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            #endif
            .accentColor(.clear)
            .foregroundColor(.clear)
            .frame(width: 1, height: 1)
            .opacity(0.001)

            // Fanned-out OTP Digit Cards
            HStack(spacing: theme.boxSpacing) {
                ForEach(0..<length, id: \.self) { index in
                    digitBox(for: index)
                }
            }
            .offset(x: shakeOffset)
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = true
            }
        }
        .onAppear {
            if autoFocus {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isFocused = true
                }
            }
            // Trigger 2-stage playing card fan entrance
            withAnimation(.spring(response: theme.fanDuration, dampingFraction: 0.72, blendDuration: 0)) {
                hasFannedOut = true
            }
        }
        .onChange(of: errorTrigger) { _ in
            playErrorShake()
        }
    }

    @ViewBuilder
    private func digitBox(for index: Int) -> some View {
        let isCurrentActive = isFocused && index == text.count
        let isFilled = index < text.count
        let charString = characterAt(index)

        // Card fan angle calculation
        let centerIndex = Double(length - 1) / 2.0
        let normalizedOffset = (Double(index) - centerIndex) / (centerIndex == 0 ? 1 : centerIndex)
        let fanAngle = hasFannedOut ? 0.0 : normalizedOffset * theme.fanSpreadAngle
        let fanYOffset = hasFannedOut ? 0.0 : abs(normalizedOffset) * 8.0

        ZStack {
            // Background fill
            RoundedRectangle(cornerRadius: theme.boxCornerRadius, style: .continuous)
                .fill(boxBackgroundColor(isFilled: isFilled, isActive: isCurrentActive))

            // Inactive / filled border
            RoundedRectangle(cornerRadius: theme.boxCornerRadius, style: .continuous)
                .strokeBorder(boxBorderColor(isFilled: isFilled, isActive: isCurrentActive), lineWidth: 1.5)

            // Rotating Neon Border Loader for active or loading box
            if (isCurrentActive || isLoading) && theme.enableRotatingBorder && !isErrorActive {
                CardBorderLoader(
                    width: theme.boxWidth,
                    height: theme.boxHeight,
                    cornerRadius: theme.boxCornerRadius,
                    colors: theme.neonColors,
                    glowWidth: 3.0,
                    lineWidth: 2.0,
                    blurRadius: 2.5
                )
            }

            // Error glowing border
            if isErrorActive {
                RoundedRectangle(cornerRadius: theme.boxCornerRadius, style: .continuous)
                    .strokeBorder(theme.errorColor, lineWidth: 2.0)
                    .shadow(color: theme.errorColor.opacity(0.4), radius: 6)
            }

            // Digit text or obscure indicator
            if let char = charString {
                Text(obscureText ? obscuringCharacter : char)
                    .font(theme.font)
                    .foregroundColor(isErrorActive ? theme.errorColor : theme.textColor)
                    .transition(.scale.combined(with: .opacity))
            } else if isCurrentActive && !isLoading {
                // Pulsing cursor bar
                RoundedRectangle(cornerRadius: 1)
                    .fill(theme.activeBorderColor)
                    .frame(width: 2, height: theme.boxHeight * 0.45)
                    .opacity(isFocused ? 1.0 : 0.0)
            }
        }
        .frame(width: theme.boxWidth, height: theme.boxHeight)
        .rotationEffect(.degrees(fanAngle))
        .offset(y: fanYOffset)
        .animation(.spring(response: 0.28, dampingFraction: 0.8), value: text)
    }

    private func characterAt(_ index: Int) -> String? {
        guard index < text.count else { return nil }
        let stringIndex = text.index(text.startIndex, offsetBy: index)
        return String(text[stringIndex])
    }

    private func boxBackgroundColor(isFilled: Bool, isActive: Bool) -> Color {
        if isErrorActive {
            return theme.errorColor.opacity(0.06)
        } else if isActive {
            return theme.activeBackgroundColor
        } else if isFilled {
            return theme.filledBackgroundColor
        }
        return theme.backgroundColor
    }

    private func boxBorderColor(isFilled: Bool, isActive: Bool) -> Color {
        if isErrorActive {
            return theme.errorColor
        } else if isActive {
            return theme.enableRotatingBorder ? .clear : theme.activeBorderColor
        } else if isFilled {
            return theme.filledBorderColor
        }
        return theme.inactiveBorderColor
    }

    private func playErrorShake() {
        guard errorTrigger > 0 else { return }
        isErrorActive = true
        #if os(iOS)
        if theme.enableHaptics {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
        #endif

        let offsets: [CGFloat] = [-12, 10, -8, 6, -3, 0]
        for (i, offset) in offsets.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.06) {
                withAnimation(.easeInOut(duration: 0.06)) {
                    shakeOffset = offset
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeOut(duration: 0.3)) {
                isErrorActive = false
            }
        }
    }

    private enum HapticStyle {
        case light, medium
    }

    private func triggerHaptic(style: HapticStyle) {
        #if os(iOS)
        guard theme.enableHaptics else { return }
        let generator = UIImpactFeedbackGenerator(style: style == .light ? .light : .medium)
        generator.impactOccurred()
        #endif
    }
}

// MARK: - Interactive Xcode Live Canvas Preview
struct FanDeckOTPField_Previews: PreviewProvider {
    struct DemoContainer: View {
        @StateObject private var controller = FanDeckOTPController(length: 6)
        @State private var isLoading = false
        @State private var obscure = false

        var body: some View {
            VStack(spacing: 36) {
                VStack(spacing: 8) {
                    Text("FanDeckOTP Live Demo")
                        .font(.title2.bold())
                    Text("Type code or tap buttons below to test animations")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                FanDeckOTPField(
                    controller: controller,
                    obscureText: obscure,
                    isLoading: isLoading,
                    autoFocus: true
                )

                Text("Entered: \(controller.text.isEmpty ? "None" : controller.text)")
                    .font(.footnote)
                    .foregroundColor(.secondary)

                HStack(spacing: 12) {
                    Button("Error Shake") {
                        controller.triggerError()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)

                    Button("Clear") {
                        controller.clear()
                    }
                    .buttonStyle(.bordered)

                    Button(obscure ? "Show PIN" : "Hide PIN") {
                        obscure.toggle()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(24)
        }
    }

    static var previews: some View {
        DemoContainer()
            .preferredColorScheme(.dark)
        DemoContainer()
            .preferredColorScheme(.light)
    }
}

