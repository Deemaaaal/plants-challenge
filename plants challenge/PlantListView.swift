import SwiftUI
import SwiftData

struct PlantListView: View {
    //context can edit
    @Environment(\.modelContext) var context
    @Query var plants: [Plant]
    
    @State private var showSheet = false
    
    @State private var selectedPlant: Plant? = nil
    
    var wateredCount: Int {
        plants.filter { $0.isWatered }.count
    }
    var allDone: Bool {
        !plants.isEmpty && wateredCount == plants.count
    }// checks if all plants is done 
    
    
    var progress: Double {
        if plants.isEmpty {
            return 0
        }
        let watered = plants.filter { $0.isWatered }.count
        return Double(watered) / Double(plants.count)
    }
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 16) {

                // الخط اللي تحت العنوان
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 1)

                // الجملة
                
                if allDone {
                    // all done screen

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

                } else {
                    
                    Text(wateredCount == 0
                         ? "Your plants are waiting for a sip 💦"
                         : "\(wateredCount) of your plants feel loved today ✨")
                    .font(.system(size: 16))
                    
                    
                    //progress bar UI
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
                                
                                HStack(spacing: 12) {
                                    
                                    // الدائرة
                                    
                                    Button {
                                        plant.isWatered.toggle()
                                    } label: {
                                        Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 22))
                                            .foregroundStyle(plant.isWatered ? Color("AppGreen") : .gray)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    // الاسم
                                    Text(plant.name)
                                        .font(.system(size: 20))
                                    
                                } // circle + name
                                
                                // الإضاءة والماء
                                HStack(spacing: 8) {
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "sun.max")
                                        Text(plant.light)
                                    }
                                    .foregroundStyle(.yellow)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "drop")
                                        Text(plant.water)
                                    }                                    .font(.system(size: 12))
                                        .foregroundStyle(.cyan)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.gray.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                    
                                } // chips
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
                        }
                    }
                    .listStyle(.plain)
                }//all done
                
            } // VStack
            .navigationTitle("My Plants 🌱")
            
            // plus icon
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
        } // NavigationStack
        //sheet shows up
        .sheet(isPresented: $showSheet) {
            SetReminderView()
        }
        .sheet(item: $selectedPlant) { plant in
            SetReminderView(plant: plant)
        }
    }
}

#Preview {
    // ١. مخزن تجريبي مؤقت
    let container = try! ModelContainer(
        for: Plant.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    // ٢. نحط فيه نباتات من البروتوتايب
    container.mainContext.insert(Plant(name: "Monstera", room: "Kitchen", light: "Full Sun", wateringDays: "Every day", water: "20-50 ml"))
    container.mainContext.insert(Plant(name: "Pothos", room: "Bedroom", light: "Full Sun", wateringDays: "Every day", water: "20-50 ml"))
    container.mainContext.insert(Plant(name: "Orchid", room: "Living Room", light: "Full Sun", wateringDays: "Every day", water: "200-300 ml"))
    container.mainContext.insert(Plant(name: "Spider", room: "Kitchen", light: "Full Sun", wateringDays: "Every day", water: "20-50 ml"))

    // ٣. نعرض الشاشة ونعطيها المخزن
    return PlantListView()
        .preferredColorScheme(.dark)
        .modelContainer(container)
}
