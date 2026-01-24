import SwiftUI

struct Planet: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let description: String
    let facts: [String]
    let diameter: String
    let distanceFromSun: String
    let dayLength: String
    let yearLength: String
    let moons: Int
    let temperature: String
    let colors: [Color]
    let ringColor: Color?
}

extension Planet {
    static let allPlanets: [Planet] = [
        Planet(
            name: "Mercury",
            symbol: "☿",
            description: "The smallest and closest planet to the Sun. Despite its proximity to the star, nighttime temperatures drop to -180°C.",
            facts: [
                "A year on Mercury lasts only 88 Earth days",
                "The surface has craters 4 billion years old",
                "Mercury has virtually no atmosphere"
            ],
            diameter: "4,879 km",
            distanceFromSun: "57.9 million km",
            dayLength: "59 Earth days",
            yearLength: "88 Earth days",
            moons: 0,
            temperature: "-180°C to +430°C",
            colors: [Color(hex: "8B7355"), Color(hex: "A9A9A9"), Color(hex: "696969")],
            ringColor: nil
        ),
        Planet(
            name: "Venus",
            symbol: "♀",
            description: "The hottest planet in the Solar System. Its dense atmosphere creates a powerful greenhouse effect.",
            facts: [
                "Venus rotates in the opposite direction",
                "A day on Venus is longer than a year",
                "Atmospheric pressure is 90 times higher than Earth's"
            ],
            diameter: "12,104 km",
            distanceFromSun: "108.2 million km",
            dayLength: "243 Earth days",
            yearLength: "225 Earth days",
            moons: 0,
            temperature: "+465°C",
            colors: [Color(hex: "FFA500"), Color(hex: "FFD700"), Color(hex: "DAA520")],
            ringColor: nil
        ),
        Planet(
            name: "Earth",
            symbol: "⊕",
            description: "Our home — the only known planet with life. 71% of the surface is covered with water.",
            facts: [
                "Earth is approximately 4.5 billion years old",
                "The magnetic field protects from solar wind",
                "The atmosphere is 78% nitrogen"
            ],
            diameter: "12,742 km",
            distanceFromSun: "149.6 million km",
            dayLength: "24 hours",
            yearLength: "365.25 days",
            moons: 1,
            temperature: "-89°C to +57°C",
            colors: [Color(hex: "1E90FF"), Color(hex: "228B22"), Color(hex: "4169E1")],
            ringColor: nil
        ),
        Planet(
            name: "Mars",
            symbol: "♂",
            description: "The Red Planet — the main target for colonization. Home to the tallest volcano in the Solar System.",
            facts: [
                "Olympus Mons is a volcano 21.9 km high",
                "Mars has seasons like Earth",
                "Rovers have been exploring since 1997"
            ],
            diameter: "6,779 km",
            distanceFromSun: "227.9 million km",
            dayLength: "24h 37min",
            yearLength: "687 Earth days",
            moons: 2,
            temperature: "-140°C to +20°C",
            colors: [Color(hex: "CD5C5C"), Color(hex: "B22222"), Color(hex: "8B0000")],
            ringColor: nil
        ),
        Planet(
            name: "Jupiter",
            symbol: "♃",
            description: "The giant of the Solar System. The Great Red Spot is a storm that has been raging for 400 years.",
            facts: [
                "Mass is 2.5x all other planets combined",
                "The Great Red Spot is larger than Earth",
                "Jupiter has faint rings"
            ],
            diameter: "139,820 km",
            distanceFromSun: "778.5 million km",
            dayLength: "10 hours",
            yearLength: "12 Earth years",
            moons: 95,
            temperature: "-110°C",
            colors: [Color(hex: "DEB887"), Color(hex: "D2691E"), Color(hex: "F4A460")],
            ringColor: Color(hex: "8B7355").opacity(0.3)
        ),
        Planet(
            name: "Saturn",
            symbol: "♄",
            description: "The Lord of the Rings — the most recognizable planet. Its rings consist of billions of ice particles.",
            facts: [
                "Saturn's density is less than water",
                "The rings extend 282,000 km",
                "Titan is a moon with a dense atmosphere"
            ],
            diameter: "116,460 km",
            distanceFromSun: "1.4 billion km",
            dayLength: "10.7 hours",
            yearLength: "29 Earth years",
            moons: 146,
            temperature: "-140°C",
            colors: [Color(hex: "F0E68C"), Color(hex: "DAA520"), Color(hex: "BDB76B")],
            ringColor: Color(hex: "DEB887").opacity(0.6)
        ),
        Planet(
            name: "Uranus",
            symbol: "⛢",
            description: "An ice giant lying on its side. Its axis of rotation is tilted 98° to the orbital plane.",
            facts: [
                "Discovered by William Herschel in 1781",
                "Coldest atmosphere in the Solar System",
                "Rotates 'lying on its side'"
            ],
            diameter: "50,724 km",
            distanceFromSun: "2.9 billion km",
            dayLength: "17 hours",
            yearLength: "84 Earth years",
            moons: 28,
            temperature: "-224°C",
            colors: [Color(hex: "87CEEB"), Color(hex: "00CED1"), Color(hex: "5F9EA0")],
            ringColor: Color(hex: "87CEEB").opacity(0.2)
        ),
        Planet(
            name: "Neptune",
            symbol: "♆",
            description: "The most distant planet. Winds reach speeds of 2,100 km/h — the fastest in the system.",
            facts: [
                "Discovered through mathematical calculations",
                "The Great Dark Spot is a giant storm",
                "Triton is a moon with nitrogen geysers"
            ],
            diameter: "49,244 km",
            distanceFromSun: "4.5 billion km",
            dayLength: "16 hours",
            yearLength: "165 Earth years",
            moons: 16,
            temperature: "-218°C",
            colors: [Color(hex: "4169E1"), Color(hex: "0000CD"), Color(hex: "191970")],
            ringColor: Color(hex: "4169E1").opacity(0.15)
        )
    ]
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
