import Foundation

enum Room: String, CaseIterable {
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case balcony = "Balcony"
    case bathroom = "Bathroom"
}

enum Light: String, CaseIterable {
    case fullSun = "Full Sun"
    case partialSun = "Partial Sun"
    case lowLight = "Low Light"
}


enum WateringDays: String, CaseIterable {
    case everyDay = "Every day"
    case every2Days = "Every 2 days"
    case every3Days = "Every 3 days"
    case onceAWeek = "Once a week"
    case every10Days = "Every 10 days"
    case every2Weeks = "Every 2 weeks"

    // كم يوم لكل خيار 📅
    var days: Int {
        switch self {
        case .everyDay: 1
        case .every2Days: 2
        case .every3Days: 3
        case .onceAWeek: 7
        case .every10Days: 10
        case .every2Weeks: 14
        }
    }
}

enum Water: String, CaseIterable {
    case small = "20-50 ml"
    case medium = "50-100 ml"
    case large = "100-200 ml"
    case xLarge = "200-300 ml"
}
