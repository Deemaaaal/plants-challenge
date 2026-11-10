//
//  SetReminderView.swift
//  plants challenge
//
//  Created by deemaalqassem on 30/05/1448 AH.
//

import SwiftUI

struct SetReminderView: View {
    @Environment(\.dismiss) var dismiss
    //dismiss the the xmark close the page
    @State private var plantName = ""
    var body: some View {
        
        NavigationStack {
            Form {
                
                HStack {
                    Text("Plant Name")
                    TextField("photos", text: $plantName)
                }//HStack
            }//form
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    
                }//cancel
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }//comfirm
            }// toolbar
        }//NavigationStack
    }//body
}// struct


#Preview {
    SetReminderView()
        .preferredColorScheme(.dark)
}
