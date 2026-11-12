import SwiftUI
import SwiftData

struct SetReminderView: View {

    // أداة الإغلاق: عشان زر ❌ يسكّر الشاشة
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    var plant: Plant? = nil

    // صندوق يحفظ اسم النبتة اللي يكتبه المستخدم
    @State private var plantName = ""

    // صندوق يحفظ الغرفة اللي يختارها المستخدم
    // يبدأ بـ Bedroom لأنه أول اختيار
    @State private var room = "Bedroom"

    // صندوق يحفظ الإضاءة، ولازم يطابق الـ tag بالضبط
    @State private var light = "Full Sun"              // 🆕 حروف كبيرة
    @State private var wateringDays = "Every day"
    @State private var water = "20-50 ml"

    var body: some View {
        NavigationStack {
            Form {

                // ١. اسم النبتة
                HStack {
                    Text("Plant Name")
                    TextField("Pothos", text: $plantName)
                } // HStack

                // ٢. مجموعة الغرفة والإضاءة
                Section {

                    // الغرفة
                    Picker(selection: $room) {
                        // Text = وش يشوف المستخدم، tag = وش ينحفظ
                        Text("Bedroom").tag("Bedroom")
                        Text("Living Room").tag("Living Room")
                        Text("Kitchen").tag("Kitchen")
                        Text("Balcony").tag("Balcony")
                        Text("Bathroom").tag("Bathroom")
                    } label: {
                        Label("Room", systemImage: "location")
                    } // room label

                    // الإضاءة
                    Picker(selection: $light) {
                        Text("Full Sun").tag("Full Sun")
                        Text("Partial Sun").tag("Partial Sun")
                        Text("Low Light").tag("Low Light")
                    } label: {
                        Label("Light", systemImage: "sun.max")
                    } // light label

                } // Section
                Section {

                    // Watering days
                    Picker(selection: $wateringDays) {
                        Text("Every day").tag("Every day")
                        Text("Every 2 days").tag("Every 2 days")
                        Text("Every 3 days").tag("Every 3 days")
                        Text("Once a week").tag("Once a week")
                        Text("Every 10 days").tag("Every 10 days")
                        Text("Every 2 weeks").tag("Every 2 weeks")
                    } label: {
                        Label("Watering Days", systemImage: "drop")
                    } // watering label

                    // Water amount
                    Picker(selection: $water) {
                        Text("20-50 ml").tag("20-50 ml")
                        Text("50-100 ml").tag("50-100 ml")
                        Text("100-200 ml").tag("100-200 ml")
                        Text("200-300 ml").tag("200-300 ml")
                    } label: {
                        Label("Water", systemImage: "drop")
                    } // water label

                } // Section
                
                // زر الحذف: يطلع بس إذا كنا نعدل ✏️
                if let plant {
                    Section {
                        Button("Delete Reminder", role: .destructive) {
                            context.delete(plant)   // احذفي النبتة من المخزن 🗑️
                            dismiss()               // سكّري الشاشة 🚪
                        }
                        .frame(maxWidth: .infinity) // الكلام في النص
                    }
                }
              
                
            } // Form
            
            .onAppear {
                if let plant {
                    plantName = plant.name
                    room = plant.room
                    light = plant.light
                    wateringDays = plant.wateringDays
                    water = plant.water
                }
            }
            
    // 👇 هذي على الـ Form، يعني داخل NavigationStack ✅
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
                        
                        // إذا الورقة فيها نبتة؟ (يعني المستخدم يعدّل ✏️)
                        if let plant {

                            // خذي اللي في الخانات، وحطيه في النبتة القديمة
                            plant.name = plantName                // الاسم الجديد
                            plant.room = room                     // الغرفة الجديدة
                            plant.light = light                   // الإضاءة الجديدة
                            plant.wateringDays = wateringDays     // أيام السقي الجديدة
                            plant.water = water                   // كمية الماء الجديدة

                        } else {
                            // وإلا: الورقة فاضية (يعني المستخدم يضيف نبتة جديدة ➕)

                            // سوي نبتة جديدة من اللي في الخانات
                            let newPlant = Plant(
                                name: plantName,
                                room: room,
                                light: light,
                                wateringDays: wateringDays,
                                water: water
                            )

                            // حطي النبتة الجديدة في المخزن 🗄️
                            context.insert(newPlant)
                        }

                        // في الحالتين: سكّري الشاشة 🚪
                        dismiss()
                        
                    } label: {
                        Image(systemName: "checkmark")

                    }
                } // confirm

            } // toolbar
        } // NavigationStack
    } // body
} // struct                                            // 🆕 قوس الـ struct

#Preview {
    SetReminderView()
        .preferredColorScheme(.dark)
        .modelContainer(for: Plant.self, inMemory: true)
}
