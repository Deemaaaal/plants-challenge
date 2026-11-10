import SwiftUI
import Playgrounds

struct ContentView: View {
    @State private var showSheet = false
    var body: some View {
        NavigationStack {
            VStack {
                Image("plant")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160,height: 160)
                Text("Start your plant journey!")
                    .font(.system(size: 25, weight: .bold))
                    .bold()
                
                Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                    .font(.system(size: 16))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,32)
                
                Button {
                    showSheet = true
                    //open the reminder page
                    
                } label: {
                    Text("Set plant reminder")
                    // style the text
                        .font(.system(size: 17, weight: .semibold))
                        .frame(width: 280, height: 42)
                       
               
                }
                //styel the shape of the button
                .buttonStyle(.glassProminent)
                .tint(Color("AppGreen"))
                .padding(.top, 40)
            
        
                   
                
                
                
            }
            
            .navigationTitle("My Plants 🌱")
        }
// NavigationStack close
        .sheet(isPresented: $showSheet) {
            SetReminderView()
        }
       
    }
// body close
}
//strcutre close


#Preview {
    ContentView()
}
