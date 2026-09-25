# FanDeckOTP 🃏✨

A premium, interactive OTP & PIN input component for **SwiftUI** featuring a 2-stage playing card fan-and-stack entrance animation, revolving neon border glow, tactile haptics, and spring-driven error shake physics.

Designed for modern iOS and macOS applications seeking an Apple-grade, captivating authentication experience.

[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Platform](https://img.shields.io/badge/Platform-iOS%2014%2B%20%7C%20macOS%2012%2B-blue.svg)](https://developer.apple.com/swift/)
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange.svg)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

---

## ✨ Features

- 🃏 **2-Stage Playing Card Fan Entrance:** Digit boxes start fanned out like a poker hand and smoothly snap into a clean horizontal alignment using spring physics.
- ⚡ **Revolving Neon Border Loader:** Dual-layer animated gradient sweep (soft ambient bloom + crisp neon line) rotating around the active digit box.
- 📳 **Tactile Haptics:** Authentic keystroke click feedback (`UIImpactFeedbackGenerator`) and failure alerts (`UINotificationFeedbackGenerator`).
- 📳 **Interactive Error Shake:** Fluid multi-oscillation horizontal shake with red warning glow when an invalid code is entered.
- 🔒 **PIN / Obscure Mode:** Seamlessly toggle between plain numeric codes and obscured bullet points (`•`).
- 📲 **SMS Auto-Fill & Paste Ready:** Built on native text responder with `.oneTimeCode` support for automatic 1-tap SMS OTP suggestions.
- 🎛️ **ObservableObject Controller:** Programmatically observe text, trigger error shakes, clear digits, or pre-fill codes via `FanDeckOTPController`.
- 🎨 **Deep Theming:** Configure box dimensions, corner radiuses, border colors, fonts, neon gradient stops, and fan angles via `FanDeckOTPTheme`.
- ⚡ **Zero External Dependencies:** 100% native SwiftUI and Combine.

---

## 📦 Installation

### In Xcode (Recommended)
1. In Xcode, open your project and go to **File** ➔ **Add Package Dependencies...**
2. In the search bar, paste the repository URL:
   ```text
   https://github.com/ShahzainBaloch/FanDeckOTP.git
   ```
3. Select **Up to Next Major Version** (`1.0.0`) and click **Add Package**.

### In `Package.swift`
If configuring a Swift package, add it to your `dependencies`:

```swift
dependencies: [
    .package(url: "https://github.com/ShahzainBaloch/FanDeckOTP.git", from: "1.0.0")
]
```

Import the framework in your SwiftUI files:

```swift
import SwiftUI
import FanDeckOTP
```

---

## 🚀 Usage Examples

### 1. Standard 6-Digit OTP with Completion Callback

```swift
import SwiftUI
import FanDeckOTP

struct VerificationView: View {
    @State private var otpCode = ""

    var body: some View {
        VStack(spacing: 24) {
            Text("Enter Verification Code")
                .font(.headline)

            FanDeckOTPField(
                text: $otpCode,
                length: 6,
                autoFocus: true,
                onChanged: { code in
                    print("Current code: \(code)")
                },
                onCompleted: { code in
                    print("Verification complete: \(code)")
                }
            )

            Button("Verify") {
                // Submit code
            }
            .disabled(otpCode.count < 6)
        }
        .padding()
    }
}
```

---

### 2. Sleek Dark Neon Theme with 4-Digit PIN Mode

```swift
FanDeckOTPField(
    text: $pinCode,
    length: 4,
    theme: FanDeckOTPTheme(
        boxWidth: 56,
        boxHeight: 66,
        boxCornerRadius: 16,
        boxSpacing: 14,
        textColor: .white,
        backgroundColor: Color.white.opacity(0.06),
        activeBackgroundColor: Color.white.opacity(0.12),
        filledBackgroundColor: Color.white.opacity(0.08),
        neonColors: [
            Color(red: 0.54, green: 0.36, blue: 0.96), // Violet
            Color(red: 0.0, green: 0.94, blue: 1.0),    // Cyan
            Color(red: 0.54, green: 0.36, blue: 0.96)
        ]
    ),
    obscureText: true,
    obscuringCharacter: "•"
)
```

---

### 3. Full Authentication Screen with Async Verification & Error Shake

```swift
import SwiftUI
import FanDeckOTP

struct SecureLoginScreen: View {
    @StateObject private var otpController = FanDeckOTPController(length: 6)
    @State private var isVerifying = false

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 8) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.blue)

                Text("Two-Factor Authentication")
                    .font(.title2.bold())

                Text("Enter the 6-digit code sent to your phone")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            FanDeckOTPField(
                controller: otpController,
                isLoading: isVerifying,
                autoFocus: true,
                onCompleted: { code in
                    verifyCode(code)
                }
            )

            if isVerifying {
                ProgressView("Verifying credentials...")
            }
        }
        .padding(32)
    }

    private func verifyCode(_ code: String) {
        isVerifying = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isVerifying = false
            if code == "123456" {
                print("Login successful!")
            } else {
                // Invalid code: trigger error shake & reset
                otpController.triggerError()
                otpController.clear()
            }
        }
    }
}
```

---

## 🛠️ API Reference

### `FanDeckOTPField`

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `text` | `Binding<String>` | **Required** | Two-way binding for entered digits. |
| `length` | `Int` | `6` | Total count of digit boxes (minimum 2). |
| `theme` | `FanDeckOTPTheme` | `FanDeckOTPTheme()` | Visual appearance & animation timing. |
| `obscureText` | `Bool` | `false` | When true, obscures digits for PIN privacy. |
| `obscuringCharacter` | `String` | `"•"` | Replacement character displayed when obscured. |
| `isLoading` | `Bool` | `false` | When true, displays rotating neon loader across boxes. |
| `errorTrigger` | `Int` | `0` | Increments trigger horizontal error shake animation. |
| `autoFocus` | `Bool` | `false` | Automatically brings up the keyboard on appear. |
| `onChanged` | `((String) -> Void)?` | `nil` | Callback triggered whenever input text updates. |
| `onCompleted` | `((String) -> Void)?` | `nil` | Callback triggered once all digits are entered. |

### `FanDeckOTPTheme`

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `boxWidth` | `CGFloat` | `48` | Width of each digit box. |
| `boxHeight` | `CGFloat` | `58` | Height of each digit box. |
| `boxCornerRadius` | `CGFloat` | `12` | Corner radius of the boxes. |
| `boxSpacing` | `CGFloat` | `10` | Horizontal spacing between boxes. |
| `font` | `Font` | `.rounded.bold (24)` | Typography font of the numbers. |
| `neonColors` | `[Color]` | `[#2D7BD9, #00F0FF, #2D7BD9]` | Gradient colors for the rotating neon border. |
| `enableRotatingBorder` | `Bool` | `true` | Whether the active box has rotating neon glow. |
| `enableHaptics` | `Bool` | `true` | Enables tactile vibration on typing and errors. |
| `fanSpreadAngle` | `Double` | `16.0` | Maximum degrees spread during entrance fan. |
| `fanDuration` | `Double` | `0.75` | Duration of the card fan entrance animation. |

### `FanDeckOTPController`

| Method / Property | Type | Description |
| :--- | :--- | :--- |
| `text` | `String` | Published string representing entered OTP. |
| `isComplete` | `Bool` | Returns `true` if all digits are entered. |
| `clear()` | `Void` | Resets entered text to empty string. |
| `triggerError()` | `Void` | Triggers error shake animation and red glow. |
| `setCode(String)` | `Void` | Programmatically populates digits. |

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Author
Created by [Shahzain Baloch](https://github.com/ShahzainBaloch).
