import Foundation
import SwiftData
import Observation

@Observable
class PlantListViewModel {

    var justFinished = false

    // كم نبتة انسقت؟
    func wateredCount(_ plants: [Plant]) -> Int {
        plants.filter { $0.isWatered }.count
    }

    // نسبة الـ Progress Bar
    func progress(_ plants: [Plant]) -> Double {
        if plants.isEmpty { return 0 }
        return Double(wateredCount(plants)) / Double(plants.count)
    }

    // ضغط الدائرة ⭕
    func toggle(_ plant: Plant, plants: [Plant], context: ModelContext) {
        plant.lastWatered = plant.isWatered ? nil : Date()

        // خلصت كلها؟ ← احذفيها واحتفلي 🎉
        if wateredCount(plants) == plants.count {
            for item in plants {
                NotificationManager.cancel(for: item)
                context.delete(item)
            }
            justFinished = true
        }
    }

    // سحب للحذف 🗑️
    func delete(_ plant: Plant, context: ModelContext) {
        NotificationManager.cancel(for: plant)
        context.delete(plant)
    }
}
