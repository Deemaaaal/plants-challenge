import SwiftUI
import SwiftData

struct PlantListView: View {
    @Query var plants: [Plant]
    
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
                Text("Your plants are waiting for a sip 💦")
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

                                Label(plant.water, systemImage: "drop")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.cyan)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))

                            } // chips
                            .padding(.leading, 34)

                        } // row VStack
                    }
                }
                .listStyle(.plain)
                
            } // VStack
            .navigationTitle("My Plants 🌱")
        } // NavigationStack
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
