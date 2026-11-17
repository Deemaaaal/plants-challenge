import Foundation
import SwiftData
import Observation

@Observable
class PlantListViewModel {

    // ✅ النباتات اللي سوى لها تشيك الحين (قبل لا يطلع من التطبيق)
    var checkedNow: [Plant] = []

    // 💧 النباتات اللي محتاجة سقي بس (المسقية تختفي)
    func plantsToWater(_ plants: [Plant]) -> [Plant] {
        plants.filter { !$0.isWatered }
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

    // ⭕ لما يضغط الدائرة: نسقيها ونحسبها في الشريط
    func toggle(_ plant: Plant) {
        plant.lastWatered = Date()
        checkedNow.append(plant)
    }

    // 🔄 لما يطلع من التطبيق: نصفّر الشريط
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
        context.delete(plant)
    }
}
