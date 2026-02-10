import SwiftUI

struct StarDetailView: View {
    let star: Star
    @Environment(\.dismiss) private var dismiss
    
    @State private var starScale: CGFloat = 0.5
    @State private var pulseAnimation = false
    @State private var showContent = false
    @State private var selectedFact = 0
    
    var body: some View {
        ZStack {
            StarFieldView(starCount: 150, showNebula: true)
            
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
                starScale = 1
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulseAnimation = true
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
                ForEach(0..<12) { i in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [star.colors[0].opacity(0.3), Color.clear],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(width: 3, height: pulseAnimation ? 120 : 80)
                        .offset(y: -100)
                        .rotationEffect(.degrees(Double(i) * 30))
                }
                
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(
                            star.colors[0].opacity(0.15 - Double(i) * 0.04),
                            lineWidth: 2
                        )
                        .frame(
                            width: CGFloat(180 + i * 50) * (pulseAnimation ? 1.05 : 1),
                            height: CGFloat(180 + i * 50) * (pulseAnimation ? 1.05 : 1)
                        )
                }
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                star.colors[0].opacity(0.6),
                                star.colors[0].opacity(0.3),
                                star.colors[1].opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 40,
                            endRadius: pulseAnimation ? 130 : 100
                        )
                    )
                    .frame(width: 260, height: 260)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: star.colors + [star.colors.last!.opacity(0.8)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 70
                        )
                    )
                    .frame(width: 140, height: 140)
                    .overlay(
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.white, .white.opacity(0.5), .clear],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 30
                                )
                            )
                            .frame(width: 60, height: 60)
                            .offset(x: -25, y: -25)
                    )
                    .shadow(color: star.colors[0], radius: 40, x: 0, y: 0)
            }
            .scaleEffect(starScale)
            
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: star.type.icon)
                        .font(.system(size: 18))
                        .foregroundColor(star.colors[0])
                    Text(star.type.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(star.colors[0])
                }
                
                Text(star.name)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                if star.constellation != "—" {
                    Text(star.constellation)
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.5))
                        .tracking(4)
                }
            }
            .padding(.top, 20)
        }
        .frame(height: 520)
    }
    
    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "text.quote")
                    .foregroundColor(star.colors[0])
                Text("About")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Text(star.description)
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
                                colors: [star.colors[0].opacity(0.3), Color.clear],
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
            StatCard(icon: "location.fill", title: "Distance", value: star.distance, color: star.colors[0])
            StatCard(icon: "scalemass.fill", title: "Mass", value: star.mass, color: Color(hex: "FFD700"))
            StatCard(icon: "thermometer.sun.fill", title: "Temperature", value: star.temperature, color: Color(hex: "FF6B6B"))
            StatCard(icon: "sun.max.fill", title: "Luminosity", value: star.luminosity, color: Color(hex: "87CEEB"))
            StatCard(icon: "clock.fill", title: "Age", value: star.age, color: Color(hex: "98FB98"))
            StatCard(icon: "star.fill", title: "Constellation", value: star.constellation, color: Color(hex: "DDA0DD"))
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
                ForEach(0..<star.facts.count, id: \.self) { index in
                    FactCard(fact: star.facts[index], index: index + 1, color: star.colors[0])
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
                    .foregroundColor(star.colors[0])
                Text("Specifications")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            VStack(spacing: 0) {
                DetailRow(label: "Name", value: star.name, isFirst: true)
                DetailRow(label: "Type", value: star.type.rawValue)
                DetailRow(label: "Distance", value: star.distance)
                DetailRow(label: "Mass", value: star.mass)
                DetailRow(label: "Temperature", value: star.temperature)
                DetailRow(label: "Luminosity", value: star.luminosity)
                DetailRow(label: "Age", value: star.age)
                DetailRow(label: "Constellation", value: star.constellation, isLast: true)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.03))
            )
        }
    }
}

#Preview {
    StarDetailView(star: Star.allStars[3])
}
