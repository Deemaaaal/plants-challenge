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
    var body: some View {
        
        NavigationStack {
            Form {
                Text("Plant name")
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
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }//comfirm
            }// toolbar
        }
    }
}


#Preview {
    SetReminderView()
}
