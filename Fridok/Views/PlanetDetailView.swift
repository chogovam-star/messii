import SwiftUI

struct PlanetDetailView: View {
    let planet: Planet
    @Environment(\.dismiss) private var dismiss
    
    @State private var planetScale: CGFloat = 0.5
    @State private var planetRotation: Double = 0
    @State private var showContent = false
    @State private var selectedFact = 0
    
    var body: some View {
        ZStack {
            StarFieldView(starCount: 100, showNebula: true)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    heroSection
                    
                    VStack(spacing: 24) {
                        descriptionCard
                        statsGrid
                        factsSection
                        detailsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)
                }
            }
            
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                planetScale = 1
            }
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                planetRotation = 360
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                showContent = true
            }
        }
    }
    
    private var heroSection: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 100)
            
            ZStack {
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(
                            planet.colors[0].opacity(0.1 - Double(i) * 0.03),
                            lineWidth: 1
                        )
                        .frame(width: CGFloat(180 + i * 40), height: CGFloat(180 + i * 40))
                }
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                planet.colors[0].opacity(0.5),
                                planet.colors[0].opacity(0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 50,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: planet.colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                    .overlay(
                        ZStack {
                            if planet.name == "Jupiter" || planet.name == "Saturn" {
                                ForEach(0..<5) { i in
                                    Capsule()
                                        .fill(planet.colors[1].opacity(0.3))
                                        .frame(width: 120, height: 8)
                                        .offset(y: CGFloat(i - 2) * 20)
                                }
                                .mask(Circle().frame(width: 140, height: 140))
                            }
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(0.5),
                                            .white.opacity(0.1),
                                            .clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .center
                                    )
                                )
                                .scaleEffect(0.85)
                                .offset(x: -20, y: -20)
                        }
                    )
                    .shadow(color: planet.colors[0].opacity(0.6), radius: 30, x: 0, y: 10)
                
                if let ringColor = planet.ringColor {
                    Ellipse()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    ringColor.opacity(0.8),
                                    ringColor.opacity(0.3),
                                    ringColor.opacity(0.8)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: planet.name == "Saturn" ? 20 : 6
                        )
                        .frame(width: 220, height: 60)
                        .rotationEffect(.degrees(-20))
                }
            }
            .scaleEffect(planetScale)
            .rotationEffect(.degrees(planetRotation * 0.01))
            
            VStack(spacing: 8) {
                Text(planet.symbol)
                    .font(.system(size: 32))
                
                Text(planet.name)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(planet.name.uppercased())
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .foregroundColor(planet.colors[0])
                    .tracking(4)
            }
            .padding(.top, 20)
        }
        .frame(height: 500)
    }
    
    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "text.quote")
                    .foregroundColor(planet.colors[0])
                Text("About")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Text(planet.description)
                .font(.system(size: 17, weight: .regular, design: .serif))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(6)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [planet.colors[0].opacity(0.3), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            StatCard(icon: "ruler", title: "Diameter", value: planet.diameter, color: planet.colors[0])
            StatCard(icon: "sun.max.fill", title: "From Sun", value: planet.distanceFromSun, color: Color(hex: "FFD700"))
            StatCard(icon: "clock.fill", title: "Day Length", value: planet.dayLength, color: Color(hex: "87CEEB"))
            StatCard(icon: "calendar", title: "Year Length", value: planet.yearLength, color: Color(hex: "98FB98"))
            StatCard(icon: "moon.stars.fill", title: "Moons", value: "\(planet.moons)", color: Color(hex: "DDA0DD"))
            StatCard(icon: "thermometer.medium", title: "Temperature", value: planet.temperature, color: Color(hex: "FF6B6B"))
        }
    }
    
    private var factsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Color(hex: "FFD700"))
                Text("Fun Facts")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            TabView(selection: $selectedFact) {
                ForEach(0..<planet.facts.count, id: \.self) { index in
                    FactCard(fact: planet.facts[index], index: index + 1, color: planet.colors[0])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: 120)
        }
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(planet.colors[0])
                Text("Specifications")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            VStack(spacing: 0) {
                DetailRow(label: "Name", value: planet.name, isFirst: true)
                DetailRow(label: "Symbol", value: planet.symbol)
                DetailRow(label: "Diameter", value: planet.diameter)
                DetailRow(label: "Distance from Sun", value: planet.distanceFromSun)
                DetailRow(label: "Rotation Period", value: planet.dayLength)
                DetailRow(label: "Orbital Period", value: planet.yearLength)
                DetailRow(label: "Number of Moons", value: "\(planet.moons)")
                DetailRow(label: "Temperature", value: planet.temperature, isLast: true)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.03))
            )
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
            
            Text(value)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
}

struct FactCard: View {
    let fact: String
    let index: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(index)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(color.opacity(0.5))
            
            Text(fact)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
        .padding(.horizontal, 4)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    var isFirst: Bool = false
    var isLast: Bool = false
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.5))
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.02))
        .overlay(
            Rectangle()
                .fill(Color.white.opacity(0.05))
                .frame(height: 1),
            alignment: .bottom
        )
        .opacity(isLast ? 1 : 1)
    }
}

#Preview {
    PlanetDetailView(planet: Planet.allPlanets[5])
}
