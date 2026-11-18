import SwiftUI
import SwiftData

struct PlantListView: View {

    @Environment(\.modelContext) var context
    @Environment(\.scenePhase) var scenePhase   // حالة التطبيق
    @Query var plants: [Plant]

    @State private var viewModel = PlantListViewModel()   // 🧠 الـ ViewModel
    @State private var showSheet = false
    @State private var selectedPlant: Plant? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 1)

                if viewModel.allDone(plants) {
                    // 🎉 All Done
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

                } else if viewModel.plantsToWater(plants).isEmpty {
                    // 📭 No reminders
                    Spacer()
                    Text("No reminders set yet..")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                    Spacer()

                } else {
                    // 📋 القائمة
                    let count = viewModel.checkedNow.count   // 👈 1: كم سقى الحين
                    Text(count == 0
                         ? "Your plants are waiting for a sip 💦"
                         : "\(count) of your plants feel loved today ✨")
                        .font(.system(size: 16))

                    ProgressView(value: viewModel.progress(plants))
                        .tint(Color("AppGreen"))
                        .padding(.horizontal, 32)

                    List {
                        ForEach(viewModel.listPlants(plants)) { plant in
                            VStack(alignment: .leading, spacing: 6) {

                                HStack(spacing: 4) {
                                    Image(systemName: "location")
                                    Text("in \(plant.room)")
                                }
                                .font(.system(size: 12))
                                .foregroundStyle(.gray)

                                HStack(spacing: 12) {
                                    Button {
                                        viewModel.toggle(plant)
                                    } label: {
                                        Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 22))
                                            .foregroundStyle(plant.isWatered ? Color("AppGreen") : .gray)
                                    }
                                    .buttonStyle(.plain)

                                    Text(plant.name)
                                        .font(.system(size: 28))
                                }

                                HStack(spacing: 8) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "sun.max")
                                        Text(plant.light)
                                    }
                                    .foregroundStyle(.yellow)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.white.opacity(0.1), in: .rect(cornerRadius: 8))

                                    HStack(spacing: 4) {
                                        Image(systemName: "drop")
                                        Text(plant.water)
                                    }
                                    .foregroundStyle(.cyan)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.white.opacity(0.1), in: .rect(cornerRadius: 8))
                                }
                                .font(.system(size: 12))
                                .padding(.leading, 34)
                            }
                            .opacity(plant.isWatered ? 0.5 : 1)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedPlant = plant
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.delete(plant, context: context)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    viewModel.newRound(plants)   // 👈 2: لو خلص الكل، الشريط يبدأ من جديد
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
            // 🔄 لما يطلع من التطبيق: نصفّر الشريط، فلما يرجع تطلع No reminders
            .onChange(of: scenePhase) {
                if scenePhase == .background {
                    viewModel.reset()   // 👈 3
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            SetReminderView()
        }
        .sheet(item: $selectedPlant) { plant in
            SetReminderView(plant: plant)
        }
    }
}

#Preview {
    PlantListView()
        .preferredColorScheme(.dark)
        .modelContainer(for: Plant.self, inMemory: true)
}
