import Foundation
import SwiftData      
import Observation

@Observable
class PlantListViewModel {

    // 💧 كم نبتة مسقية؟
    func wateredCount(_ plants: [Plant]) -> Int {
        plants.filter { $0.isWatered }.count
    }

    // 📊 كم يتعبى شريط التقدم؟ (من 0 إلى 1)
    func progress(_ plants: [Plant]) -> Double {
        if plants.isEmpty { return 0 }
        return Double(wateredCount(plants)) / Double(plants.count)
    }

    // 🎉 هل كل النباتات مسقية؟
    func allDone(_ plants: [Plant]) -> Bool {
        !plants.isEmpty && wateredCount(plants) == plants.count
    }

    // ⭕ لما يضغط الدائرة: حط التشيك أو شيله (بدون حذف)
    func toggle(_ plant: Plant) {
        plant.lastWatered = plant.isWatered ? nil : Date()
    }

    // 🗑️ نحذف النبتة وإشعارها (لما يسحب ويحذف بنفسه)
    func delete(_ plant: Plant, context: ModelContext) {
        NotificationManager.cancel(for: plant)
        context.delete(plant)
    }
}
