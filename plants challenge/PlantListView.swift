import SwiftUI
import SwiftData

struct PlantListView: View {

    @Environment(\.modelContext) var context
    @Environment(\.scenePhase) var scenePhase
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

                if plants.isEmpty && viewModel.justFinished {
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

                } else if plants.isEmpty {
                    // 📭 No reminders
                    Spacer()
                    Text("No reminders set yet..")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                    Spacer()

                } else {
                    // 📋 القائمة
                    let count = viewModel.wateredCount(plants)
                    Text(count == 0
                         ? "Your plants are waiting for a sip 💦"
                         : "\(count) of your plants feel loved today ✨")
                        .font(.system(size: 16))

                    ProgressView(value: viewModel.progress(plants))
                        .tint(Color("AppGreen"))
                        .padding(.horizontal, 32)

                    List {
                        ForEach(plants) { plant in
                            VStack(alignment: .leading, spacing: 6) {

                                HStack(spacing: 4) {
                                    Image(systemName: "location")
                                    Text("in \(plant.room)")
                                }
                                .font(.system(size: 12))
                                .foregroundStyle(.gray)

                                HStack(spacing: 12) {
                                    Button {
                                        viewModel.toggle(plant, plants: plants, context: context)
                                    } label: {
                                        Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 22))
                                            .foregroundStyle(plant.isWatered ? Color("AppGreen") : .gray)
                                    }
                                    .buttonStyle(.plain)

                                    Text(plant.name)
                                        .font(.system(size: 20))
                                }

                                HStack(spacing: 8) {
                                    Label(plant.light, systemImage: "sun.max")
                                        .foregroundStyle(.yellow)
                                    Label(plant.water, systemImage: "drop")
                                        .foregroundStyle(.cyan)
                                }
                                .font(.system(size: 12))
                                .labelStyle(.titleAndIcon)
                                .padding(.leading, 34)
                            }
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
            .onChange(of: scenePhase) {
                if scenePhase == .background {
                    viewModel.justFinished = false
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
