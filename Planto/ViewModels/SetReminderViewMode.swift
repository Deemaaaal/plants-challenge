import Foundation
import SwiftData
import Observation

@Observable
class SetReminderViewModel {

    // الخانات 📝
    var plantName = ""
    var room = "Bedroom"
    var light = "Full Sun"
    var wateringDays = "Every day"
    var water = "20-50 ml"

    // الورقة 📄: فيها نبتة (تعديل) أو فاضية (إضافة)
    var plant: Plant?

    init(plant: Plant? = nil) {
        self.plant = plant

        // تعديل؟ ← عبّي الخانات
        if let plant {
            plantName = plant.name
            room = plant.room
            light = plant.light
            wateringDays = plant.wateringDays
            water = plant.water
        }
    }

    // edit
    func save(context: ModelContext) {
        if let plant {
            plant.name = plantName
            plant.room = room
            plant.light = light
            plant.wateringDays = wateringDays
            plant.water = water
            NotificationManager.cancel(for: plant)
            NotificationManager.schedule(for: plant)
        } else {
            let newPlant = Plant(name: plantName, room: room, light: light,
                                 wateringDays: wateringDays, water: water)
            context.insert(newPlant)
            NotificationManager.schedule(for: newPlant)
        }
    }

    // زر Delete Reminder 🔴
    func delete(context: ModelContext) {
        guard let plant else { return }
        NotificationManager.cancel(for: plant)
        context.delete(plant)
    }
}
