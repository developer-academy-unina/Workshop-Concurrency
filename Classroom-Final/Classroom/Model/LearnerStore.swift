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
    
    func getAllLearners() async {
        self.isFetching = true
        
        logger.info("Start Get all learners")
        
        let learners = await networkManager.getAllLearners()
        self.learners = learners ?? []
        self.isFetching = false
        
        logger.info("Complete Get all learners")

    }
    
    func create(learner: Learner) async {
        self.isFetching = true
        
        logger.info("Start Create new learner")

        let newLearner = await networkManager.create(learner)
        if let newLearner = newLearner { self.learners.append(newLearner)
        }
        self.isFetching = false
        logger.info("Complete Create new learner")

    }
}
