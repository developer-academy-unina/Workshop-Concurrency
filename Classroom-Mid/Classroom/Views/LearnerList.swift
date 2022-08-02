//
//  ContentView.swift
//  Classroom
//
//  Created by Gianluca Orpello for the Developer Academy on 18/01/22.
//

import SwiftUI

struct LearnerList: View {
    
    @State private var showingSheet = false
    @StateObject var learnerStore = LearnerStore()
    
    var body: some View {
        NavigationView{
            if !showingSheet {
                ProgressView("Loading...")
            }else{
                List {
                    ForEach(learnerStore.learners) { learner in
                        NavigationLink(destination: PresentMeView(learner: learner, learnerStore: learnerStore )) {
                            HStack {
                                Image(learner.imageName)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text("\(learner.name) \(learner.surname)")
                                Spacer()
                            }
                        }
                    }
                }
                .navigationTitle("Learners")
                
            }
        
            
        }
        .onAppear {
            if self.learnerStore.isFetching {
                print(self.learnerStore.isFetching)
                learnerStore.getAllLearners()
            }
        }
        .navigationViewStyle(.stack)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LearnerList()
    }
}
