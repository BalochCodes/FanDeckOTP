import SwiftUI

/// An animated rotating neon border loader that draws a revolving sweep gradient
/// around a rounded rectangle with dual-layer glow effect.
public struct CardBorderLoader: View {
    public let width: CGFloat
    public let height: CGFloat
    public let cornerRadius: CGFloat
    public let colors: [Color]
    public let glowWidth: CGFloat
    public let lineWidth: CGFloat
    public let blurRadius: CGFloat
    public let duration: Double

    @State private var isRotating = false

    public init(
        width: CGFloat = 50,
        height: CGFloat = 60,
        cornerRadius: CGFloat = 12,
        colors: [Color] = [
            Color(red: 0.176, green: 0.482, blue: 0.851), // #2D7BD9
            Color(red: 0.0, green: 0.941, blue: 1.0),     // #00F0FF
            Color(red: 0.176, green: 0.482, blue: 0.851)
        ],
        glowWidth: CGFloat = 3.0,
        lineWidth: CGFloat = 2.0,
        blurRadius: CGFloat = 3.0,
        duration: Double = 1.5
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.colors = colors
        self.glowWidth = glowWidth
        self.lineWidth = lineWidth
        self.blurRadius = blurRadius
        self.duration = duration
    }

    public var body: some View {
        let gradient = AngularGradient(
            gradient: Gradient(colors: colors),
            center: .center
        )

        ZStack {
            // Outer blurred neon bloom glow
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(gradient, lineWidth: glowWidth)
                .rotationEffect(.degrees(isRotating ? 360 : 0))
                .blur(radius: blurRadius)

            // Inner crisp sharp neon line
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(gradient, lineWidth: lineWidth)
                .rotationEffect(.degrees(isRotating ? 360 : 0))
        }
        .frame(width: width, height: height)
        .onAppear {
            withAnimation(
                .linear(duration: duration)
                .repeatForever(autoreverses: false)
            ) {
                isRotating = true
            }
        }
    }
}
