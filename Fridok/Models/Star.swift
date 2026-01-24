import SwiftUI

struct Star: Identifiable {
    let id = UUID()
    let name: String
    let type: StarType
    let description: String
    let facts: [String]
    let distance: String
    let mass: String
    let temperature: String
    let luminosity: String
    let age: String
    let constellation: String
    let colors: [Color]
}

enum StarType: String {
    case redDwarf = "Red Dwarf"
    case yellowDwarf = "Yellow Dwarf"
    case blueGiant = "Blue Giant"
    case redGiant = "Red Giant"
    case whiteDwarf = "White Dwarf"
    case neutronStar = "Neutron Star"
    case supergiant = "Supergiant"
    
    var icon: String {
        switch self {
        case .redDwarf: return "flame"
        case .yellowDwarf: return "sun.max.fill"
        case .blueGiant: return "sparkles"
        case .redGiant: return "circle.hexagongrid.fill"
        case .whiteDwarf: return "star.fill"
        case .neutronStar: return "atom"
        case .supergiant: return "burst.fill"
        }
    }
}

extension Star {
    static let allStars: [Star] = [
        Star(
            name: "Sun",
            type: .yellowDwarf,
            description: "Our star — the center of the Solar System. A nearly perfect sphere of hot plasma that provides energy for life on Earth.",
            facts: [
                "Contains 99.86% of the Solar System's mass",
                "Light takes 8 minutes to reach Earth",
                "Surface temperature is about 5,500°C"
            ],
            distance: "149.6 million km",
            mass: "1.989 × 10³⁰ kg",
            temperature: "5,778 K",
            luminosity: "3.828 × 10²⁶ W",
            age: "4.6 billion years",
            constellation: "—",
            colors: [Color(hex: "FFD700"), Color(hex: "FFA500"), Color(hex: "FF8C00")]
        ),
        Star(
            name: "Proxima Centauri",
            type: .redDwarf,
            description: "The closest star to the Sun. A small red dwarf in the Alpha Centauri system with a potentially habitable exoplanet.",
            facts: [
                "Only 4.24 light-years away",
                "Has an Earth-like planet in habitable zone",
                "Visible only from Southern Hemisphere"
            ],
            distance: "4.24 light-years",
            mass: "0.12 Solar masses",
            temperature: "3,042 K",
            luminosity: "0.0017 Solar",
            age: "4.85 billion years",
            constellation: "Centaurus",
            colors: [Color(hex: "FF6B6B"), Color(hex: "CD5C5C"), Color(hex: "8B0000")]
        ),
        Star(
            name: "Sirius",
            type: .yellowDwarf,
            description: "The brightest star in Earth's night sky. A binary system where Sirius A outshines its white dwarf companion.",
            facts: [
                "Twice as massive as our Sun",
                "25 times more luminous than the Sun",
                "Known since ancient times"
            ],
            distance: "8.6 light-years",
            mass: "2.02 Solar masses",
            temperature: "9,940 K",
            luminosity: "25.4 Solar",
            age: "242 million years",
            constellation: "Canis Major",
            colors: [Color(hex: "E8E8E8"), Color(hex: "B8D4E8"), Color(hex: "87CEEB")]
        ),
        Star(
            name: "Betelgeuse",
            type: .supergiant,
            description: "A red supergiant on the verge of supernova. One of the largest stars visible to the naked eye.",
            facts: [
                "Could explode as supernova anytime",
                "Diameter is 1,000 times the Sun's",
                "Pulsates and changes brightness"
            ],
            distance: "700 light-years",
            mass: "16.5 Solar masses",
            temperature: "3,500 K",
            luminosity: "126,000 Solar",
            age: "8-10 million years",
            constellation: "Orion",
            colors: [Color(hex: "FF4500"), Color(hex: "DC143C"), Color(hex: "8B0000")]
        ),
        Star(
            name: "Rigel",
            type: .blueGiant,
            description: "A blue supergiant and the brightest star in Orion. One of the most luminous stars in our galaxy.",
            facts: [
                "120,000 times brighter than the Sun",
                "Surface temperature over 12,000 K",
                "Part of a four-star system"
            ],
            distance: "860 light-years",
            mass: "21 Solar masses",
            temperature: "12,100 K",
            luminosity: "120,000 Solar",
            age: "8 million years",
            constellation: "Orion",
            colors: [Color(hex: "4169E1"), Color(hex: "0000CD"), Color(hex: "00BFFF")]
        ),
        Star(
            name: "Vega",
            type: .yellowDwarf,
            description: "One of the brightest stars in the northern sky. A relatively young star with a debris disk.",
            facts: [
                "Rotates once every 12.5 hours",
                "Was the North Star 14,000 years ago",
                "Has a dusty debris disk"
            ],
            distance: "25 light-years",
            mass: "2.1 Solar masses",
            temperature: "9,602 K",
            luminosity: "40 Solar",
            age: "455 million years",
            constellation: "Lyra",
            colors: [Color(hex: "F0F8FF"), Color(hex: "E6E6FA"), Color(hex: "B0C4DE")]
        ),
        Star(
            name: "Polaris",
            type: .supergiant,
            description: "The North Star — Earth's current pole star. A yellow supergiant that guides travelers.",
            facts: [
                "Actually a triple star system",
                "Pulsates every 4 days",
                "Will be closest to pole in 2100"
            ],
            distance: "433 light-years",
            mass: "5.4 Solar masses",
            temperature: "6,015 K",
            luminosity: "1,260 Solar",
            age: "70 million years",
            constellation: "Ursa Minor",
            colors: [Color(hex: "FFFACD"), Color(hex: "FFD700"), Color(hex: "DAA520")]
        ),
        Star(
            name: "Antares",
            type: .supergiant,
            description: "The heart of the Scorpion. A red supergiant rivaling Betelgeuse in size and luminosity.",
            facts: [
                "Name means 'rival of Mars'",
                "Would engulf Mars if placed at Sun",
                "Has a hot blue companion star"
            ],
            distance: "550 light-years",
            mass: "12 Solar masses",
            temperature: "3,660 K",
            luminosity: "75,900 Solar",
            age: "12 million years",
            constellation: "Scorpius",
            colors: [Color(hex: "FF4500"), Color(hex: "B22222"), Color(hex: "800000")]
        )
    ]
}

extension Star: Hashable {
    static func == (lhs: Star, rhs: Star) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
