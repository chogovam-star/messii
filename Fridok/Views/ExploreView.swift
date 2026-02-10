import SwiftUI

struct ExploreView: View {
    @State private var showTitle = false
    @State private var showQuiz = false
    @State private var showWeightCalculator = false
    @State private var showSizeComparison = false
    
    var body: some View {
        ZStack {
            StarFieldView(starCount: 120, showNebula: true)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    headerSection
                    featuresSection
                    funFactsSection
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
        }
        .fullScreenCover(isPresented: $showQuiz) {
            QuizView()
        }
        .fullScreenCover(isPresented: $showWeightCalculator) {
            WeightCalculatorView()
        }
        .fullScreenCover(isPresented: $showSizeComparison) {
            SizeComparisonView()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 60)
            
            ZStack {
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(hex: "FF6B6B").opacity(0.2),
                                    Color(hex: "FFD700").opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                        .frame(width: CGFloat(50 + i * 20), height: CGFloat(50 + i * 20))
                }
                
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "FFD700"), Color(hex: "FF6B35")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .rotationEffect(.degrees(-45))
                    .offset(y: showTitle ? 0 : 10)
                    .animation(.easeOut(duration: 0.8), value: showTitle)
            }
            .padding(.bottom, 10)
            
            VStack(spacing: 8) {
                Text("EXPLORE")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "E8E8E8"), Color(hex: "B8B8B8")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .tracking(8)
                
                Text("Interactive space activities")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
                    .tracking(2)
            }
            .opacity(showTitle ? 1 : 0)
            .offset(y: showTitle ? 0 : 20)
            
            Spacer()
                .frame(height: 10)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showTitle = true
            }
        }
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("ACTIVITIES")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(hex: "FF6B6B"))
                    .tracking(3)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                FeatureCard(
                    icon: "questionmark.circle.fill",
                    title: "Space Quiz",
                    description: "Test your cosmic knowledge with fun questions",
                    gradient: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                    badge: "12 Questions"
                ) {
                    showQuiz = true
                }
                
                FeatureCard(
                    icon: "scalemass.fill",
                    title: "Weight Calculator",
                    description: "Discover how much you'd weigh on other planets",
                    gradient: [Color(hex: "87CEEB"), Color(hex: "4169E1")],
                    badge: "9 Planets"
                ) {
                    showWeightCalculator = true
                }
                
                FeatureCard(
                    icon: "circle.grid.2x2.fill",
                    title: "Size Comparison",
                    description: "Visually compare the sizes of planets",
                    gradient: [Color(hex: "DDA0DD"), Color(hex: "6B3FA0")],
                    badge: "Interactive"
                ) {
                    showSizeComparison = true
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var funFactsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("DID YOU KNOW?")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(hex: "4CAF50"))
                    .tracking(3)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    FunFactCard(
                        fact: "A day on Venus is longer than its year!",
                        icon: "clock.fill",
                        color: Color(hex: "FFA500")
                    )
                    
                    FunFactCard(
                        fact: "Saturn's rings are mostly made of ice chunks",
                        icon: "snowflake",
                        color: Color(hex: "87CEEB")
                    )
                    
                    FunFactCard(
                        fact: "Jupiter's Great Red Spot is shrinking",
                        icon: "wind",
                        color: Color(hex: "FF6B6B")
                    )
                    
                    FunFactCard(
                        fact: "Neutron stars can spin 600 times per second",
                        icon: "atom",
                        color: Color(hex: "DDA0DD")
                    )
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let gradient: [Color]
    let badge: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: gradient.map { $0.opacity(0.2) },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 26))
                        .foregroundStyle(
                            LinearGradient(
                                colors: gradient,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(badge)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(gradient[0])
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(gradient[0].opacity(0.2))
                            )
                    }
                    
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.5))
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [gradient[0].opacity(0.3), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.2)) { isPressed = true }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.2)) { isPressed = false }
                }
        )
    }
}

struct FunFactCard: View {
    let fact: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(fact)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(3)
        }
        .padding(16)
        .frame(width: 180, height: 130, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ExploreView()
}
