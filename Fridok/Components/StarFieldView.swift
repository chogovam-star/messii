import SwiftUI

struct BackgroundStar: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var twinkleSpeed: Double
}

struct StarFieldView: View {
    @State private var stars: [BackgroundStar] = []
    @State private var phase: Double = 0
    
    let starCount: Int
    let showNebula: Bool
    
    init(starCount: Int = 150, showNebula: Bool = true) {
        self.starCount = starCount
        self.showNebula = showNebula
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(hex: "0a0a1a"),
                        Color(hex: "0d1025"),
                        Color(hex: "0f0f2d"),
                        Color(hex: "05051a")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                if showNebula {
                    NebulaView()
                        .opacity(0.4)
                }
                
                Canvas { context, size in
                    for star in stars {
                        let twinkle = sin(phase * star.twinkleSpeed) * 0.3 + 0.7
                        let finalOpacity = star.opacity * twinkle
                        
                        let rect = CGRect(
                            x: star.x * size.width,
                            y: star.y * size.height,
                            width: star.size,
                            height: star.size
                        )
                        
                        let glowRect = rect.insetBy(dx: -star.size * 0.5, dy: -star.size * 0.5)
                        context.fill(
                            Path(ellipseIn: glowRect),
                            with: .color(.white.opacity(finalOpacity * 0.3))
                        )
                        
                        context.fill(
                            Path(ellipseIn: rect),
                            with: .color(.white.opacity(finalOpacity))
                        )
                    }
                }
                
                ShootingStarView()
            }
            .onAppear {
                generateStars()
                startTwinkling()
            }
        }
        .ignoresSafeArea()
    }
    
    private func generateStars() {
        stars = (0..<starCount).map { _ in
            BackgroundStar(
                x: CGFloat.random(in: 0...1),
                y: CGFloat.random(in: 0...1),
                size: CGFloat.random(in: 1...3),
                opacity: Double.random(in: 0.4...1.0),
                twinkleSpeed: Double.random(in: 0.5...2.0)
            )
        }
    }
    
    private func startTwinkling() {
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            phase = .pi * 2
        }
    }
}

struct NebulaView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: "6B3FA0").opacity(0.3),
                            Color(hex: "4B0082").opacity(0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 200
                    )
                )
                .frame(width: 400, height: 400)
                .offset(x: -100, y: -200)
                .blur(radius: 40)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: "1E90FF").opacity(0.2),
                            Color(hex: "0066CC").opacity(0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 250
                    )
                )
                .frame(width: 500, height: 500)
                .offset(x: 150, y: 300)
                .blur(radius: 50)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: "FF69B4").opacity(0.15),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 300)
                .offset(x: 100, y: -100)
                .blur(radius: 30)
        }
    }
}

struct ShootingStarView: View {
    @State private var isVisible = false
    @State private var offset: CGFloat = 0
    @State private var startPosition: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            if isVisible {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.5), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 60, height: 2)
                    .rotationEffect(.degrees(45))
                    .position(
                        x: startPosition.x + offset,
                        y: startPosition.y + offset
                    )
                    .blur(radius: 0.5)
            }
        }
        .onAppear {
            triggerShootingStar()
        }
    }
    
    private func triggerShootingStar() {
        Timer.scheduledTimer(withTimeInterval: Double.random(in: 4...10), repeats: true) { _ in
            startPosition = CGPoint(
                x: CGFloat.random(in: 50...300),
                y: CGFloat.random(in: 50...200)
            )
            offset = 0
            isVisible = true
            
            withAnimation(.easeIn(duration: 0.8)) {
                offset = 250
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isVisible = false
            }
        }
    }
}

#Preview {
    StarFieldView()
}
