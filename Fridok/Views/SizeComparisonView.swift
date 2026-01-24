import SwiftUI

struct SizeComparisonView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlanets: Set<String> = ["Earth", "Mars"]
    @State private var showAllPlanets = false
    
    let planetSizes: [(name: String, diameter: Double, color: Color)] = [
        ("Mercury", 4879, Color(hex: "8B7355")),
        ("Venus", 12104, Color(hex: "FFA500")),
        ("Earth", 12742, Color(hex: "1E90FF")),
        ("Mars", 6779, Color(hex: "CD5C5C")),
        ("Jupiter", 139820, Color(hex: "DEB887")),
        ("Saturn", 116460, Color(hex: "F0E68C")),
        ("Uranus", 50724, Color(hex: "87CEEB")),
        ("Neptune", 49244, Color(hex: "4169E1"))
    ]
    
    var maxDiameter: Double {
        planetSizes.filter { selectedPlanets.contains($0.name) || showAllPlanets }.map { $0.diameter }.max() ?? 1
    }
    
    var body: some View {
        ZStack {
            StarFieldView(starCount: 100, showNebula: true)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    headerSection
                    controlsSection
                    comparisonSection
                    detailsSection
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
            
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Circle().fill(Color.white.opacity(0.1)))
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                Spacer()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 100)
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "6B3FA0").opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "circle.grid.2x2.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "DDA0DD"), Color(hex: "6B3FA0")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            
            VStack(spacing: 8) {
                Text("SIZE COMPARISON")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(2)
                
                Text("Compare the sizes of planets")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }
    
    private var controlsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Show all planets")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Toggle("", isOn: $showAllPlanets)
                    .labelsHidden()
                    .tint(Color(hex: "6B3FA0"))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
            )
            
            if !showAllPlanets {
                Text("Select planets to compare")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(planetSizes, id: \.name) { planet in
                            PlanetSelectChip(
                                name: planet.name,
                                color: planet.color,
                                isSelected: selectedPlanets.contains(planet.name)
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    if selectedPlanets.contains(planet.name) {
                                        if selectedPlanets.count > 1 {
                                            selectedPlanets.remove(planet.name)
                                        }
                                    } else {
                                        selectedPlanets.insert(planet.name)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var comparisonSection: some View {
        let filteredPlanets = planetSizes.filter { showAllPlanets || selectedPlanets.contains($0.name) }
        let planetCount = filteredPlanets.count
        
        return VStack(spacing: 20) {
            HStack {
                Text("VISUAL COMPARISON")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(hex: "6B3FA0"))
                    .tracking(2)
                
                Spacer()
                
                if planetCount > 4 {
                    Text("← Scroll →")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: planetCount > 4 ? 24 : 16) {
                    ForEach(filteredPlanets, id: \.name) { planet in
                        let scale = planet.diameter / maxDiameter
                        let baseSize: CGFloat = planetCount > 4 ? 120 : 150
                        let size = max(20, baseSize * scale)
                        let itemWidth: CGFloat = planetCount > 4 ? 80 : max(60, (UIScreen.main.bounds.width - 80) / CGFloat(planetCount))
                        
                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [planet.color.opacity(0.6), planet.color],
                                            center: .topLeading,
                                            startRadius: 0,
                                            endRadius: size / 2
                                        )
                                    )
                                    .frame(width: size, height: size)
                                    .overlay(
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [.white.opacity(0.4), .clear],
                                                    startPoint: .topLeading,
                                                    endPoint: .center
                                                )
                                            )
                                            .scaleEffect(0.9)
                                            .offset(x: -size * 0.1, y: -size * 0.1)
                                    )
                                    .shadow(color: planet.color.opacity(0.5), radius: 8, x: 0, y: 4)
                            }
                            .frame(height: planetCount > 4 ? 130 : 160, alignment: .bottom)
                            
                            Text(planet.name)
                                .font(.system(size: planetCount > 6 ? 9 : 11, weight: .semibold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        .frame(width: itemWidth)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.03))
            )
            .padding(.horizontal, 20)
        }
    }
    
    private var detailsSection: some View {
        VStack(spacing: 16) {
            Text("DIAMETER DETAILS")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(Color(hex: "FFD700"))
                .tracking(2)
            
            VStack(spacing: 8) {
                ForEach(planetSizes.filter { showAllPlanets || selectedPlanets.contains($0.name) }.sorted(by: { $0.diameter > $1.diameter }), id: \.name) { planet in
                    DiameterBar(
                        name: planet.name,
                        diameter: planet.diameter,
                        maxDiameter: planetSizes.map { $0.diameter }.max() ?? 1,
                        color: planet.color
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct PlanetSelectChip: View {
    let name: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isSelected ? .black : .white.opacity(0.7))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(isSelected ? color : Color.white.opacity(0.1))
                )
                .overlay(
                    Capsule()
                        .stroke(color.opacity(0.5), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

struct DiameterBar: View {
    let name: String
    let diameter: Double
    let maxDiameter: Double
    let color: Color
    
    @State private var animatedWidth: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 12) {
            Text(name)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 70, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.1))
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: animatedWidth)
                }
            }
            .frame(height: 24)
            
            Text(formatDiameter(diameter))
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundColor(color)
                .frame(width: 75, alignment: .trailing)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                animatedWidth = CGFloat(diameter / maxDiameter) * (UIScreen.main.bounds.width - 200)
            }
        }
    }
    
    private func formatDiameter(_ value: Double) -> String {
        if value >= 1000 {
            return String(format: "%.0fK km", value / 1000)
        }
        return String(format: "%.0f km", value)
    }
}

#Preview {
    SizeComparisonView()
}
