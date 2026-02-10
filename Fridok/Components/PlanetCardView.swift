import SwiftUI

struct PlanetCardView: View {
    let planet: Planet
    let index: Int
    
    @State private var isPressed = false
    @State private var rotation: Double = 0
    @State private var appeared = false
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                planet.colors[0].opacity(0.4),
                                planet.colors[0].opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 25,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: planet.colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.4),
                                        .white.opacity(0.1),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .center
                                )
                            )
                            .scaleEffect(0.9)
                            .offset(x: -8, y: -8)
                    )
                    .shadow(color: planet.colors[0].opacity(0.5), radius: 10, x: 0, y: 5)
                
                if let ringColor = planet.ringColor {
                    Ellipse()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    ringColor,
                                    ringColor.opacity(0.5),
                                    ringColor
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: planet.name == "Saturn" ? 8 : 3
                        )
                        .frame(width: 90, height: 25)
                        .rotationEffect(.degrees(-15))
                }
            }
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(planet.symbol)
                        .font(.system(size: 20))
                    Text(planet.name)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Text(planet.name.uppercased())
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.5))
                
                HStack(spacing: 16) {
                    InfoBadge(icon: "circle.fill", value: planet.diameter, color: planet.colors[0])
                    InfoBadge(icon: "moon.fill", value: "\(planet.moons)", color: .white.opacity(0.7))
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.08),
                            Color.white.opacity(0.03)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    planet.colors[0].opacity(0.3),
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(isPressed ? 0.97 : 1)
        .opacity(appeared ? 1 : 0)
        .offset(x: appeared ? 0 : 50)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1)) {
                appeared = true
            }
        }
    }
}

struct InfoBadge: View {
    let icon: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 8))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.08))
        )
    }
}

#Preview {
    ZStack {
        StarFieldView()
        PlanetCardView(planet: Planet.allPlanets[5], index: 0)
            .padding()
    }
}
