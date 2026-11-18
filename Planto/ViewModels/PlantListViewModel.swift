import Foundation
import SwiftData
import Observation

@Observable
class PlantListViewModel {

    // ✅ النباتات اللي سوى لها تشيك الحين (قبل لا يطلع من التطبيق)
    var checkedNow: [Plant] = []

    // 💧 النباتات اللي محتاجة سقي
    func plantsToWater(_ plants: [Plant]) -> [Plant] {
        plants.filter { !$0.isWatered }
    }

    // 📋 اللي تطلع في القائمة: اللي محتاجة سقي فوق ⭕ + اللي سقاها الحين تحت ✅
    func listPlants(_ plants: [Plant]) -> [Plant] {
        let checked = checkedNow.filter { item in plants.contains { $0.id == item.id } }
        return plantsToWater(plants) + checked
    }

    // 📊 الشريط: اللي سقاها الحين ÷ (اللي سقاها الحين + اللي باقية)
    func progress(_ plants: [Plant]) -> Double {
        let total = plantsToWater(plants).count + checkedNow.count
        if total == 0 { return 0 }
        return Double(checkedNow.count) / Double(total)
    }

    // 🎉 خلص الكل الحين؟ (ما باقي شي + سقى شي الحين)
    func allDone(_ plants: [Plant]) -> Bool {
        plantsToWater(plants).isEmpty && !checkedNow.isEmpty
    }

    // ⭕ لما يضغط الدائرة: يسقيها، أو يلغي السقي لو غلط
    func toggle(_ plant: Plant) {
        if plant.isWatered {
            plant.lastWatered = nil                          // ↩️ ألغِ السقي
            checkedNow.removeAll { $0.id == plant.id }
        } else {
            plant.lastWatered = Date()                       // ✅ سقيناها
            checkedNow.append(plant)
        }
    }

    // 🔄 لما يطلع من التطبيق: نصفّر
    func reset() {
        checkedNow = []
    }

    // 🆕 لو خلص الكل وبيضيف نبتة جديدة: الشريط يبدأ من جديد
    func newRound(_ plants: [Plant]) {
        if plantsToWater(plants).isEmpty {
            checkedNow = []
        }
    }

    // 🗑️ نحذف النبتة وإشعارها
    func delete(_ plant: Plant, context: ModelContext) {
        NotificationManager.cancel(for: plant)
        checkedNow.removeAll { $0.id == plant.id }
        context.delete(plant)
    }
}
