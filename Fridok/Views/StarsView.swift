import SwiftUI

struct StarsView: View {
    @State private var showTitle = false
    @State private var navigationPath = NavigationPath()
    @State private var selectedType: StarType?
    
    let starTypes: [StarType] = [.yellowDwarf, .redDwarf, .blueGiant, .redGiant, .supergiant]
    
    var filteredStars: [Star] {
        if let type = selectedType {
            return Star.allStars.filter { $0.type == type }
        }
        return Star.allStars
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                StarFieldView(starCount: 200, showNebula: true)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        headerSection
                        filterSection
                        starsSection
                    }
                }
            }
            .navigationDestination(for: Star.self) { star in
                StarDetailView(star: star)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 60)
            
            ZStack {
                ForEach(0..<8) { i in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white,
                                    Color.white.opacity(0.5),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 15
                            )
                        )
                        .frame(width: CGFloat.random(in: 8...20), height: CGFloat.random(in: 8...20))
                        .offset(
                            x: cos(Double(i) * .pi / 4) * 35,
                            y: sin(Double(i) * .pi / 4) * 35
                        )
                        .opacity(showTitle ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(Double(i) * 0.1), value: showTitle)
                }
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white,
                                Color(hex: "87CEEB"),
                                Color(hex: "4169E1").opacity(0.5),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: Color.white.opacity(0.5), radius: 20, x: 0, y: 0)
            }
            .padding(.bottom, 10)
            
            VStack(spacing: 8) {
                Text("STARS")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(hex: "E8E8E8"),
                                Color(hex: "B8B8B8")
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .tracking(8)
                
                Text("Celestial beacons of light")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
                    .tracking(2)
            }
            .opacity(showTitle ? 1 : 0)
            .offset(y: showTitle ? 0 : 20)
            
            HStack(spacing: 30) {
                StatBubble(value: "200B+", label: "In Galaxy")
                StatBubble(value: "8", label: "Featured")
                StatBubble(value: "∞", label: "Stories")
            }
            .padding(.top, 20)
            .opacity(showTitle ? 1 : 0)
            
            Spacer()
                .frame(height: 20)
        }
        .frame(height: 320)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showTitle = true
            }
        }
    }
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterChip(
                    title: "All",
                    isSelected: selectedType == nil,
                    color: Color(hex: "6B3FA0")
                ) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedType = nil
                    }
                }
                
                ForEach(starTypes, id: \.self) { type in
                    FilterChip(
                        title: type.rawValue,
                        isSelected: selectedType == type,
                        color: colorForType(type)
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedType = type
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 16)
    }
    
    private var starsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("CATALOG")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "1E90FF"))
                        .tracking(3)
                    
                    Text("\(filteredStars.count) stars to explore")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            LazyVStack(spacing: 16) {
                ForEach(Array(filteredStars.enumerated()), id: \.element.id) { index, star in
                    NavigationLink(value: star) {
                        StarCardView(star: star, index: index)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private func colorForType(_ type: StarType) -> Color {
        switch type {
        case .redDwarf, .redGiant: return Color(hex: "FF6B6B")
        case .yellowDwarf: return Color(hex: "FFD700")
        case .blueGiant: return Color(hex: "4169E1")
        case .whiteDwarf: return Color(hex: "E8E8E8")
        case .neutronStar: return Color(hex: "00CED1")
        case .supergiant: return Color(hex: "FF4500")
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
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
                        .stroke(color.opacity(0.3), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

struct StarCardView: View {
    let star: Star
    let index: Int
    
    @State private var appeared = false
    @State private var pulse = false
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                star.colors[0].opacity(0.5),
                                star.colors[0].opacity(0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 15,
                            endRadius: 45
                        )
                    )
                    .frame(width: 90, height: 90)
                    .scaleEffect(pulse ? 1.1 : 1.0)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: star.colors,
                            center: .center,
                            startRadius: 0,
                            endRadius: 25
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.white.opacity(0.8), .clear],
                                    center: .topLeading,
                                    startRadius: 0,
                                    endRadius: 20
                                )
                            )
                            .frame(width: 20, height: 20)
                            .offset(x: -10, y: -10)
                    )
                    .shadow(color: star.colors[0], radius: 15, x: 0, y: 0)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(star.name)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                HStack(spacing: 6) {
                    Image(systemName: star.type.icon)
                        .font(.system(size: 10))
                        .foregroundColor(star.colors[0])
                    Text(star.type.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                HStack(spacing: 12) {
                    InfoBadge(icon: "location.fill", value: star.distance, color: star.colors[0])
                }
                .padding(.top, 4)
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
                                    star.colors[0].opacity(0.3),
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
        .opacity(appeared ? 1 : 0)
        .offset(x: appeared ? 0 : 50)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1)) {
                appeared = true
            }
        }
    }
}

#Preview {
    StarsView()
}
