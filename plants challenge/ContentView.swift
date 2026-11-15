import SwiftUI
import SwiftData


struct ContentView: View {

    // صندوق يتذكر: شاشة Set Reminder مفتوحة ولا لا؟
    // false = مسكّرة بالبداية
    // @State = لما تتغير القيمة، SwiftUI يحدث الشاشة لحاله
    @State private var showSheet = false
    @Query var plants: [Plant]
    @AppStorage("hasSeenJourney") var hasSeenJourney = false
    @State private var showJourney = !UserDefaults.standard.bool(forKey: "hasSeenJourney")

    var body: some View {
        if plants.isEmpty && showJourney {

        // يعطينا الشريط اللي فوق (مكان العنوان My Plants)
        NavigationStack {

            // يرتب العناصر فوق بعض، و spacing = المسافة بين كل عنصر والثاني
            VStack(spacing: 16) {

                // الخط الرفيع اللي تحت العنوان
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 1)
                // سوستة: تدف المحتوى لتحت عشان يبقى الخط فوق
                Spacer()

                // صورة النبتة من Assets
                Image("plant")
                    .resizable()        // يسمح للصورة تكبر وتصغر
                    .scaledToFit()      // تصغر بدون ما تنمط
                    .frame(width: 160, height: 160) // حجمها

            // العنوان العريض
                Text("Start your plant journey!")
                    .font(.system(size: 25, weight: .bold)) // حجم ٢٥ وعريض

                // النص الرمادي الصغير
                Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                    .font(.system(size: 16))           // حجم ١٦
                    .foregroundStyle(.gray)            // لون رمادي
                    .multilineTextAlignment(.center)   // الأسطر في النص
                    .padding(.horizontal, 32)          // يبعده عن أطراف الشاشة

                // زر Set Plant Reminder
                Button {
                    // وش يصير لما ينضغط: افتح شاشة Set Reminder
                    showSheet = true
                } label: {
                    // شكل الزر من داخل (الكلام)
                    Text("Set Plant Reminder")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(width: 280, height: 42) // حجم الزر من البروتوتايب
                } // label close
                // تعديلات على الزر كله (برا القوس)
                .buttonStyle(.glassProminent)   // شكل الزجاج Liquid Glass
                .tint(Color("AppGreen"))        // لون الزجاج من Assets
                .padding(.top, 40)              // مسافة فوق الزر

                // سوستة: تدف المحتوى لفوق عشان يبقى في النص
                Spacer()

            } // VStack close
            .navigationTitle("My Plants 🌱") // العنوان الكبير فوق
            

        } // NavigationStack close

        // لما showSheet تصير true، تطلع شاشة SetReminderView من تحت
        // $ = مفتاح: يخلي الشيت يرجعها false لحاله لما يتسكر
        .sheet(isPresented: $showSheet) {
            SetReminderView()
        }
        .onAppear {
            hasSeenJourney = true
        }
        .onDisappear {
            showJourney = false
        }
        } else {
            PlantListView()
        }

    } // body close
} // struct close

// للكانفاس بس (أنتِ تشوفينه، المستخدم لا)
#Preview {
    ContentView()
        .preferredColorScheme(.dark)
        .modelContainer(for: Plant.self, inMemory: true)
      
}
