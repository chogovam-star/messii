import SwiftUI

@Observable
class AppSettings {
    static let shared = AppSettings()
    
    var showAnimations: Bool {
        didSet { UserDefaults.standard.set(showAnimations, forKey: "showAnimations") }
    }
    var showNebula: Bool {
        didSet { UserDefaults.standard.set(showNebula, forKey: "showNebula") }
    }
    var starDensity: Double {
        didSet { UserDefaults.standard.set(starDensity, forKey: "starDensity") }
    }
    var hapticFeedback: Bool {
        didSet { UserDefaults.standard.set(hapticFeedback, forKey: "hapticFeedback") }
    }
    
    init() {
        self.showAnimations = UserDefaults.standard.object(forKey: "showAnimations") as? Bool ?? true
        self.showNebula = UserDefaults.standard.object(forKey: "showNebula") as? Bool ?? true
        self.starDensity = UserDefaults.standard.object(forKey: "starDensity") as? Double ?? 150
        self.hapticFeedback = UserDefaults.standard.object(forKey: "hapticFeedback") as? Bool ?? true
    }
    
    func lightHaptic() {
        guard hapticFeedback else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func mediumHaptic() {
        guard hapticFeedback else { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func heavyHaptic() {
        guard hapticFeedback else { return }
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    func successHaptic() {
        guard hapticFeedback else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func errorHaptic() {
        guard hapticFeedback else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    func selectionHaptic() {
        guard hapticFeedback else { return }
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

struct SettingsView: View {
    @State private var settings = AppSettings.shared
    @State private var showTitle = false
    @State private var showAbout = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                StarFieldView(starCount: Int(settings.starDensity), showNebula: settings.showNebula)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        headerSection
                        settingsContent
                    }
                }
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 60)
            
            ZStack {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "6B3FA0").opacity(0.3), Color(hex: "1E90FF").opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "E8E8E8"), Color(hex: "A0A0A0")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .rotationEffect(.degrees(showTitle ? 90 : 0))
                    .animation(.easeInOut(duration: 1), value: showTitle)
            }
            
            VStack(spacing: 8) {
                Text("SETTINGS")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "E8E8E8"), Color(hex: "B8B8B8")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .tracking(6)
                
                Text("Customize your experience")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
                    .tracking(2)
            }
            .opacity(showTitle ? 1 : 0)
            .offset(y: showTitle ? 0 : 20)
            
            Spacer()
                .frame(height: 30)
        }
        .frame(height: 260)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showTitle = true
            }
        }
    }
    
    private var settingsContent: some View {
        VStack(spacing: 24) {
            SettingsSection(title: "VISUAL", icon: "eye.fill", color: Color(hex: "6B3FA0")) {
                SettingsToggle(
                    title: "Animations",
                    subtitle: "Planet rotations and effects",
                    icon: "sparkles",
                    isOn: $settings.showAnimations,
                    color: Color(hex: "FFD700")
                )
                
                SettingsToggle(
                    title: "Nebula Effects",
                    subtitle: "Background cosmic clouds",
                    icon: "cloud.fill",
                    isOn: $settings.showNebula,
                    color: Color(hex: "FF69B4")
                )
                
                SettingsSlider(
                    title: "Star Density",
                    value: $settings.starDensity,
                    range: 50...300,
                    icon: "star.fill",
                    color: Color(hex: "87CEEB")
                )
            }
            
            SettingsSection(title: "INTERACTION", icon: "hand.tap.fill", color: Color(hex: "1E90FF")) {
                SettingsToggleWithTest(
                    title: "Haptic Feedback",
                    subtitle: "Vibration on interactions",
                    icon: "iphone.radiowaves.left.and.right",
                    isOn: $settings.hapticFeedback,
                    color: Color(hex: "98FB98")
                )
            }
            
            SettingsSection(title: "ABOUT", icon: "info.circle.fill", color: Color(hex: "FF6B6B")) {
                SettingsButton(
                    title: "About Cosmos",
                    subtitle: "Version 1.0.0",
                    icon: "paperplane.fill",
                    color: Color(hex: "FFD700")
                ) {
                    settings.lightHaptic()
                    showAbout = true
                }
            }
            
            VStack(spacing: 8) {
                Text("Made with 💜 for space lovers")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.4))
                
                Text("© 2026 Cosmos App")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
        .padding(.horizontal, 20)
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(color)
                    .tracking(3)
            }
            
            VStack(spacing: 2) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
}

struct SettingsToggle: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var isOn: Bool
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(color)
                .onChange(of: isOn) { _, _ in
                    AppSettings.shared.selectionHaptic()
                }
        }
        .padding(16)
    }
}

struct SettingsToggleWithTest: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var isOn: Bool
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                    
                    Button(action: {
                        AppSettings.shared.mediumHaptic()
                    }) {
                        Text("Test")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(color.opacity(0.2))
                            )
                    }
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(color)
                .onChange(of: isOn) { _, _ in
                    if isOn {
                        AppSettings.shared.successHaptic()
                    }
                }
        }
        .padding(16)
    }
}

struct SettingsSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    Text("\(Int(value)) stars")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
            }
            
            Slider(value: $value, in: range)
                .tint(color)
        }
        .padding(16)
    }
}

struct SettingsButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(16)
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "0a0a1a").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color(hex: "6B3FA0").opacity(0.3),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 30,
                                        endRadius: 80
                                    )
                                )
                                .frame(width: 160, height: 160)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        }
                        
                        Text("COSMOS")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .tracking(6)
                        
                        Text("Solar System Explorer")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("Version 1.0.0")
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .padding(.top, 40)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "6B3FA0"))
                        
                        Text("Cosmos is your personal guide to the wonders of our Solar System and beyond. Explore planets, discover stars, and learn fascinating facts about the universe we call home.")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(6)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.05))
                    )
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Features")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "1E90FF"))
                        
                        FeatureRow(icon: "globe.americas.fill", text: "8 planets with detailed info", color: Color(hex: "4169E1"))
                        FeatureRow(icon: "star.fill", text: "8 famous stars to explore", color: Color(hex: "FFD700"))
                        FeatureRow(icon: "questionmark.circle.fill", text: "Interactive space quiz", color: Color(hex: "FF6B6B"))
                        FeatureRow(icon: "scalemass.fill", text: "Weight calculator", color: Color(hex: "87CEEB"))
                        FeatureRow(icon: "circle.grid.2x2.fill", text: "Planet size comparison", color: Color(hex: "DDA0DD"))
                        FeatureRow(icon: "sparkles", text: "Beautiful animations", color: Color(hex: "FF69B4"))
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.05))
                    )
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        AppSettings.shared.lightHaptic()
                        dismiss()
                    }) {
                        Text("Close")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "6B3FA0"))
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
                .frame(width: 24)
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

#Preview {
    SettingsView()
}
