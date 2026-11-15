import Foundation
import SwiftData

@Model
class Plant {
    var name: String
    var room: String
    var light: String
    var wateringDays: String
    var water: String
    var lastWatered: Date? = nil

    var isWatered: Bool {
        guard let lastWatered else { return false }
        let days = NotificationManager.daysFrom(wateringDays)
        let start = Calendar.current.startOfDay(for: lastWatered)
        let nextTime = Calendar.current.date(byAdding: .day, value: days, to: start)!
        return Date() < nextTime
    }
        //like an ID for each plant
    var notificationID: String = UUID().uuidString

    init(name: String, room: String, light: String, wateringDays: String, water: String) {
        self.name = name
        self.room = room
        self.light = light
        self.wateringDays = wateringDays
        self.water = water
    }
}
