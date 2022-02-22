//
//  StudentsViewModel.swift
//  Classroom
//
//  Created by Gianluca Orpello for the Developer Academy on 18/01/22.
//

import os
import SwiftUI

@MainActor
class LearnerStore: ObservableObject {
    
    @Published var isFetching: Bool = false
    @Published var learners: [Learner] = []
    
    lazy var networkManager = NetworkManager()
    lazy var logger = Logger(subsystem: "developer.academy.Classroom.LearnerStore", category: "ViewModel")
    
    func getAllLearners() {
        self.isFetching = true
        
        networkManager.getAllLearners { learners, error in
            guard error == nil, let learners = learners else { return }
            self.learners = learners
            self.isFetching = false
        }
        
    }
    
    func create(learner: Learner) {
        self.isFetching = true
        
        networkManager.create(learner) { newLearner, error in
            guard error == nil, let newLearner = newLearner else { return }
            self.learners.append(newLearner)
            self.isFetching = false
            
        }
    }
}
