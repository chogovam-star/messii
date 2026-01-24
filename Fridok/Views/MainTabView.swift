import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @Namespace private var animation
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                PlanetsHomeView()
                    .tag(0)
                
                StarsView()
                    .tag(1)
                
                ExploreView()
                    .tag(2)
                
                SettingsView()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            customTabBar
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            TabBarButton(
                icon: "globe.americas.fill",
                title: "Planets",
                isSelected: selectedTab == 0,
                color: Color(hex: "4169E1"),
                namespace: animation
            ) {
                AppSettings.shared.selectionHaptic()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = 0
                }
            }
            
            TabBarButton(
                icon: "star.fill",
                title: "Stars",
                isSelected: selectedTab == 1,
                color: Color(hex: "FFD700"),
                namespace: animation
            ) {
                AppSettings.shared.selectionHaptic()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = 1
                }
            }
            
            TabBarButton(
                icon: "paperplane.fill",
                title: "Explore",
                isSelected: selectedTab == 2,
                color: Color(hex: "FF6B6B"),
                namespace: animation
            ) {
                AppSettings.shared.selectionHaptic()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = 2
                }
            }
            
            TabBarButton(
                icon: "gearshape.fill",
                title: "Settings",
                isSelected: selectedTab == 3,
                color: Color(hex: "6B3FA0"),
                namespace: animation
            ) {
                AppSettings.shared.selectionHaptic()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = 3
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "1a1a2e").opacity(0.95),
                            Color(hex: "0f0f1a").opacity(0.98)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let color: Color
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(color.opacity(0.2))
                            .frame(width: 44, height: 44)
                            .matchedGeometryEffect(id: "tab_background", in: namespace)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? color : .white.opacity(0.4))
                        .scaleEffect(isSelected ? 1.1 : 1)
                }
                .frame(width: 44, height: 44)
                
                Text(title)
                    .font(.system(size: 9, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? color : .white.opacity(0.4))
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct StatBubble: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(width: 80)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension Planet: Hashable {
    static func == (lhs: Planet, rhs: Planet) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct PlanetsHomeView: View {
    @State private var showTitle = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                StarFieldView()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        headerSection
                        planetsSection
                    }
                }
            }
            .navigationDestination(for: Planet.self) { planet in
                PlanetDetailView(planet: planet)
            }
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
                                    Color(hex: "6B3FA0").opacity(0.3),
                                    Color(hex: "1E90FF").opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                        .frame(width: CGFloat(60 + i * 25), height: CGFloat(60 + i * 25))
                        .rotationEffect(.degrees(Double(i) * 30))
                }
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(hex: "FFD700"),
                                Color(hex: "FFA500"),
                                Color(hex: "FF6B35")
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 25
                        )
                    )
                    .frame(width: 50, height: 50)
                    .shadow(color: Color(hex: "FFD700").opacity(0.5), radius: 20, x: 0, y: 0)
                
                Circle()
                    .fill(Color(hex: "4169E1"))
                    .frame(width: 12, height: 12)
                    .offset(x: 50)
                    .rotationEffect(.degrees(showTitle ? 360 : 0))
                    .animation(.linear(duration: 8).repeatForever(autoreverses: false), value: showTitle)
            }
            .padding(.bottom, 10)
            
            VStack(spacing: 8) {
                Text("COSMOS")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "E8E8E8"), Color(hex: "B8B8B8")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .tracking(8)
                
                Text("Explore the Solar System")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
                    .tracking(2)
            }
            .opacity(showTitle ? 1 : 0)
            .offset(y: showTitle ? 0 : 20)
            
            HStack(spacing: 30) {
                StatBubble(value: "8", label: "Planets")
                StatBubble(value: "290+", label: "Moons")
                StatBubble(value: "4.5B", label: "Years")
            }
            .padding(.top, 20)
            .opacity(showTitle ? 1 : 0)
            
            Spacer()
                .frame(height: 30)
        }
        .frame(height: 340)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showTitle = true
            }
        }
    }
    
    private var planetsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("PLANETS")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "6B3FA0"))
                        .tracking(3)
                    
                    Text("Our cosmic neighbors")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 22))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(.horizontal, 20)
            
            LazyVStack(spacing: 16) {
                ForEach(Array(Planet.allPlanets.enumerated()), id: \.element.id) { index, planet in
                    NavigationLink(value: planet) {
                        PlanetCardView(planet: planet, index: index)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

#Preview {
    MainTabView()
}
