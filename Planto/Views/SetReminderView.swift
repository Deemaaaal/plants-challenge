import SwiftUI
import SwiftData

struct SetReminderView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State private var viewModel: SetReminderViewModel   // 🧠

    // نعطي الـ ViewModel الورقة 📄
    init(plant: Plant? = nil) {
        _viewModel = State(initialValue: SetReminderViewModel(plant: plant))
    }

    var body: some View {
        NavigationStack {
            Form {

                HStack {
                    Text("Plant Name")
                    TextField("Pothos", text: $viewModel.plantName)
                }

                Section {
                    Picker(selection: $viewModel.room) {
                        ForEach(Room.allCases, id: \.self) {          // 🏠 Enum
                            Text($0.rawValue).tag($0.rawValue)
                        }
                    } label: {
                        Label("Room", systemImage: "location").foregroundStyle(.white)
                    }

                    Picker(selection: $viewModel.light) {
                        ForEach(Light.allCases, id: \.self) {         // ☀️ Enum
                            Text($0.rawValue).tag($0.rawValue)
                        }
                    } label: {
                        Label("Light", systemImage: "sun.max").foregroundStyle(.white)
                    }
                }

                Section {
                    Picker(selection: $viewModel.wateringDays) {
                        ForEach(WateringDays.allCases, id: \.self) {  // 📅 Enum
                            Text($0.rawValue).tag($0.rawValue)
                        }
                    } label: {
                        Label("Watering Days", systemImage: "drop").foregroundStyle(.white)
                    }

                    Picker(selection: $viewModel.water) {
                        ForEach(Water.allCases, id: \.self) {         // 💧 Enum
                            Text($0.rawValue).tag($0.rawValue)
                        }
                    } label: {
                        Label("Water", systemImage: "drop").foregroundStyle(.white)
                    }
                }

                // زر الحذف: بس في التعديل
                if viewModel.plant != nil {
                    Section {
                        Button("Delete Reminder", role: .destructive) {
                            viewModel.delete(context: context)
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.save(context: context)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color("AppGreen"))
                    .disabled(viewModel.plantName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    SetReminderView()
        .preferredColorScheme(.dark)
        .modelContainer(for: Plant.self, inMemory: true)
}
