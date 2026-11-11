import SwiftUI

struct SetReminderView: View {

    // أداة الإغلاق: عشان زر ❌ يسكّر الشاشة
    @Environment(\.dismiss) var dismiss

    // صندوق يحفظ اسم النبتة اللي يكتبه المستخدم
    @State private var plantName = ""

    // صندوق يحفظ الغرفة اللي يختارها المستخدم
    // يبدأ بـ Bedroom لأنه أول اختيار
    @State private var room = "Bedroom"

    var body: some View {
        NavigationStack {
            Form {

                // ١. اسم النبتة
                HStack {
                    Text("Plant Name")
                    TextField("Pothos", text: $plantName)
                } // HStack

                // ٢. مجموعة الغرفة
                Section {
                    // قائمة اختيارات، واللي ينختار ينحفظ في room
                    Picker(selection: $room) {
                        // Text = وش يشوف المستخدم، tag = وش ينحفظ
                        Text("Bedroom").tag("Bedroom")
                        Text("Living Room").tag("Living Room")
                        Text("Kitchen").tag("Kitchen")
                        Text("Balcony").tag("Balcony")
                        Text("Bathroom").tag("Bathroom")
                    } label: {
                        // الكلام اللي على اليسار مع أيقونة
                        Label("Room", systemImage: "location")
                    } // label
                } // Section

            } // Form
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                // زر ❌
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                } // cancel

                // زر ✅
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        // بعدين: نحفظ النبتة
                    } label: {
                        Image(systemName: "checkmark")
                    }
                } // confirm

            } // toolbar
        } // NavigationStack
    } // body
} // struct

#Preview {
    SetReminderView()
        .preferredColorScheme(.dark)
}
