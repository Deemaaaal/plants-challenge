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
                        ForEach(["Bedroom", "Living Room", "Kitchen", "Balcony", "Bathroom"], id: \.self) {
                            Text($0).tag($0)
                        }
                    } label: {
                        Label("Room", systemImage: "location").foregroundStyle(.white)
                    }

                    Picker(selection: $viewModel.light) {
                        ForEach(["Full Sun", "Partial Sun", "Low Light"], id: \.self) {
                            Text($0).tag($0)
                        }
                    } label: {
                        Label("Light", systemImage: "sun.max").foregroundStyle(.white)
                    }
                }

                Section {
                    Picker(selection: $viewModel.wateringDays) {
                        ForEach(["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"], id: \.self) {
                            Text($0).tag($0)
                        }
                    } label: {
                        Label("Watering Days", systemImage: "drop").foregroundStyle(.white)
                    }

                    Picker(selection: $viewModel.water) {
                        ForEach(["20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"], id: \.self) {
                            Text($0).tag($0)
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
