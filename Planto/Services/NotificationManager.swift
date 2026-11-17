import Foundation
import UserNotifications   // أداة التنبيهات من أبل 🔔

struct NotificationManager {

    // ١. نطلب الإذن من المستخدم 🙋‍♀️
    static func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    // ٢. نجدول تنبيه لنبتة ⏰
    static func schedule(for plant: Plant) {

        // الرسالة 💬
        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = "Hey! let's water your plant"
        content.sound = .default

        // متى؟ (كل كم يوم) 📅
        let days = daysFrom(plant.wateringDays)
        let seconds =  Double(days) * 24 * 60 * 60
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: true)

        // نسلّمه للجوال 📲
        let request = UNNotificationRequest(
            identifier: plant.notificationID,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    // ٣. نلغي تنبيه نبتة 🗑️
    static func cancel(for plant: Plant) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [plant.notificationID])
    }

    // نحول "Every 2 days" لرقم 2 🔢
    static func daysFrom(_ text: String) -> Int {
        WateringDays(rawValue: text)?.days ?? 1
    }
    }

