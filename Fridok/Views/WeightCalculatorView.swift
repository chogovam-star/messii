import SwiftUI

struct PlanetGravity {
    let name: String
    let gravity: Double
    let emoji: String
    let color: Color
}

extension PlanetGravity {
    static let planets: [PlanetGravity] = [
        PlanetGravity(name: "Mercury", gravity: 0.38, emoji: "☿", color: Color(hex: "8B7355")),
        PlanetGravity(name: "Venus", gravity: 0.91, emoji: "♀", color: Color(hex: "FFA500")),
        PlanetGravity(name: "Earth", gravity: 1.0, emoji: "⊕", color: Color(hex: "1E90FF")),
        PlanetGravity(name: "Moon", gravity: 0.166, emoji: "☾", color: Color(hex: "C0C0C0")),
        PlanetGravity(name: "Mars", gravity: 0.38, emoji: "♂", color: Color(hex: "CD5C5C")),
        PlanetGravity(name: "Jupiter", gravity: 2.34, emoji: "♃", color: Color(hex: "DEB887")),
        PlanetGravity(name: "Saturn", gravity: 1.06, emoji: "♄", color: Color(hex: "F0E68C")),
        PlanetGravity(name: "Uranus", gravity: 0.92, emoji: "⛢", color: Color(hex: "87CEEB")),
        PlanetGravity(name: "Neptune", gravity: 1.19, emoji: "♆", color: Color(hex: "4169E1"))
    ]
}

struct WeightCalculatorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var earthWeight: String = ""
    @State private var showResults = false
    @FocusState private var isInputFocused: Bool
    
    var weightValue: Double {
        Double(earthWeight) ?? 0
    }
    
    var body: some View {
        ZStack {
            StarFieldView(starCount: 100, showNebula: true)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    headerSection
                    inputSection
                    
                    if showResults && weightValue > 0 {
                        resultsSection
                    }
                    
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
        .onTapGesture {
            isInputFocused = false
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
                            colors: [Color(hex: "4169E1").opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "scalemass.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "87CEEB"), Color(hex: "4169E1")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            
            VStack(spacing: 8) {
                Text("WEIGHT CALCULATOR")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(2)
                
                Text("See how much you'd weigh on other planets")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var inputSection: some View {
        VStack(spacing: 16) {
            Text("Enter your weight on Earth")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.6))
            
            HStack(spacing: 12) {
                TextField("70", text: $earthWeight)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .focused($isInputFocused)
                    .frame(width: 150)
                    .onChange(of: earthWeight) { _, _ in
                        withAnimation(.spring(response: 0.3)) {
                            showResults = !earthWeight.isEmpty
                        }
                    }
                
                Text("kg")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "4169E1").opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal, 20)
    }
    
    private var resultsSection: some View {
        VStack(spacing: 16) {
            Text("YOUR WEIGHT ACROSS THE COSMOS")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(Color(hex: "FFD700"))
                .tracking(2)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(PlanetGravity.planets, id: \.name) { planet in
                    WeightCard(
                        planet: planet,
                        weight: weightValue * planet.gravity
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
}

struct WeightCard: View {
    let planet: PlanetGravity
    let weight: Double
    
    @State private var appeared = false
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(planet.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text(planet.emoji)
                    .font(.system(size: 24))
            }
            
            Text(planet.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            
            VStack(spacing: 2) {
                Text(String(format: "%.1f", weight))
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(planet.color)
                
                Text("kg")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.4))
            }
            
            HStack(spacing: 4) {
                Image(systemName: planet.gravity > 1 ? "arrow.up" : "arrow.down")
                    .font(.system(size: 10))
                Text("\(Int(planet.gravity * 100))%")
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(planet.gravity > 1 ? Color(hex: "FF6B6B") : Color(hex: "4CAF50"))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(planet.gravity > 1 ? Color(hex: "FF6B6B").opacity(0.2) : Color(hex: "4CAF50").opacity(0.2))
            )
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(planet.color.opacity(0.2), lineWidth: 1)
                )
        )
        .scaleEffect(appeared ? 1 : 0.8)
        .opacity(appeared ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double.random(in: 0...0.2))) {
                appeared = true
            }
        }
    }
}

#Preview {
    WeightCalculatorView()
}
