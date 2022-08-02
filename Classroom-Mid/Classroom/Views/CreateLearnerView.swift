//
//  CreateLearnerView.swift
//  Classroom
//
//  Created by Gianluca Orpello for the Developer Academy on 18/01/22.
//
//


import SwiftUI

struct CreateLearnerView: View {
    @Environment(\.dismiss) var dismiss
    
    var learnerStore: LearnerStore
    @State var name: String = ""
    @State var shortBio: String = ""
    @State var surname: String = ""
    
    var body: some View {
        
        NavigationView{
            
            Form {
                Section(header: Text("Learner Details")) {
                    TextField("Firstname",
                              text: $name)
                    TextField("Lastname",
                              text: $surname)
                    
                }
                
                Section(header: Text("Short Bio")) {
                    TextEditor(text: $shortBio)
                }
                    
            }
            
            .navigationTitle("Add New Learner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
            }
        }
        
        
    }
}

