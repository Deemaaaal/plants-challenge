import SwiftUI
import SwiftData

struct PlantListView: View {

    // المخزن وحالة التطبيق
    @Environment(\.modelContext) var context
    @Environment(\.scenePhase) var scenePhase
    @Query var plants: [Plant]

    // الصناديق
    @State private var showSheet = false              // شيت الإضافة ➕
    @State private var selectedPlant: Plant? = nil    // النبتة اللي ينعدل عليها ✏️
    @State private var justFinished = false           // خلّص السقي الحين؟ 🎉

    // الحسابات 🧮
    var wateredCount: Int {
        plants.filter { $0.isWatered }.count
    }

    var allDone: Bool {
        !plants.isEmpty && wateredCount == plants.count
    }

    var progress: Double {
        if plants.isEmpty { return 0 }
        return Double(wateredCount) / Double(plants.count)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                // الخط
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 1)

                // ١. خلّص السقي الحين 🎉
                if plants.isEmpty && justFinished {

                    Spacer()
                    Image("plantDone")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                    Text("All Done! 🎉")
                        .font(.system(size: 25, weight: .bold))
                    Text("All Reminders Completed")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                    Spacer()

                // ٢. ما فيه تذكيرات 📭
                } else if plants.isEmpty {

                    Spacer()
                    Text("No reminders set yet..")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                    Spacer()

                // ٣. القائمة 📋
                } else {

                    Text(wateredCount == 0
                         ? "Your plants are waiting for a sip 💦"
                         : "\(wateredCount) of your plants feel loved today ✨")
                        .font(.system(size: 16))

                    ProgressView(value: progress)
                        .tint(Color("AppGreen"))
                        .padding(.horizontal, 32)

                    List {
                        ForEach(plants) { plant in
                            VStack(alignment: .leading, spacing: 6) {

                                // الغرفة
                                HStack(spacing: 4) {
                                    Image(systemName: "location")
                                    Text("in \(plant.room)")
                                }
                                .font(.system(size: 12))
                                .foregroundStyle(.gray)

                                // الدائرة + الاسم
                                HStack(spacing: 12) {
                                    Button {
                                        plant.lastWatered = plant.isWatered ? nil : Date()

                                        // 🆕 إذا خلصت كلها:
                                        if allDone {
                                            for item in plants {
                                                NotificationManager.cancel(for: item)  // 🔕 الغي تنبيهها
                                                context.delete(item)                   // 🗑️ احذفيها
                                            }
                                            justFinished = true                        // 🎉 احتفلي
                                        }
                                    } label: {
                                        Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 22))
                                            .foregroundStyle(plant.isWatered ? Color("AppGreen") : .gray)
                                    }
                                    .buttonStyle(.plain)

                                    Text(plant.name)
                                        .font(.system(size: 20))
                                }

                                // الإضاءة والماء
                                HStack(spacing: 8) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "sun.max")
                                        Text(plant.light)
                                    }
                                    .font(.system(size: 12))
                                    .foregroundStyle(.yellow)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))

                                    HStack(spacing: 4) {
                                        Image(systemName: "drop")
                                        Text(plant.water)
                                    }
                                    .font(.system(size: 12))
                                    .foregroundStyle(.cyan)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                }
                                .padding(.leading, 34)

                            } // row VStack
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedPlant = plant
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    NotificationManager.cancel(for: plant)
                                    context.delete(plant)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        } // ForEach
                    } // List
                    .listStyle(.plain)

                } // if

            } // VStack
            // زر +
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .semibold))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.circle)
                .tint(Color("AppGreen"))
                .padding(24)
            }
            .navigationTitle("My Plants 🌱")
            // لما يطلع من التطبيق ← امسحي الاحتفال
            .onChange(of: scenePhase) {
                if scenePhase == .background {
                    justFinished = false
                }
            }
        } // NavigationStack
        .sheet(isPresented: $showSheet) {
            SetReminderView()
        }
        .sheet(item: $selectedPlant) { plant in
            SetReminderView(plant: plant)
        }
    } // body
} // struct

#Preview {
    let container = try! ModelContainer(
        for: Plant.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    container.mainContext.insert(Plant(name: "Monstera", room: "Kitchen", light: "Full Sun", wateringDays: "Every day", water: "20-50 ml"))
    container.mainContext.insert(Plant(name: "Pothos", room: "Bedroom", light: "Full Sun", wateringDays: "Every day", water: "20-50 ml"))
    container.mainContext.insert(Plant(name: "Orchid", room: "Living Room", light: "Full Sun", wateringDays: "Every day", water: "200-300 ml"))
    container.mainContext.insert(Plant(name: "Spider", room: "Kitchen", light: "Full Sun", wateringDays: "Every day", water: "20-50 ml"))

    return PlantListView()
        .preferredColorScheme(.dark)
        .modelContainer(container)
}
