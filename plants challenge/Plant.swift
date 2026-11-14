import Foundation
import SwiftData

@Model
class Plant {
    var name: String
    var room: String
    var light: String
    var wateringDays: String
    var water: String
    var isWatered: Bool = false
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
