//
//  NetworkManager.swift
//  Classroom
//
//  Created by Gianluca Orpello for the Developer Academy on 18/01/22.
//
//

import os
import SwiftUI

enum HTTPMethods: String {
    case post = "POST"
    case get = "GET"
}

class NetworkManager {
    
    private var urlComponents = URLComponents(string: "https://mc3-ws-http.herokuapp.com/")!
    lazy var jsonDecoder = JSONDecoder()
    lazy var jsonEncoder = JSONEncoder()
    lazy var logger = Logger(subsystem: "developer.academy.Classroom.NetworkManager", category: "ViewModel")
    
    private func getRequest(url: URL, method: HTTPMethods = HTTPMethods.get) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        logger.log("Create a new URLRequest")
        return request
    }
    
    @available(*, deprecated, message: "Prefer async alternative instead")
    func getAllLearners(_ completionHandler: @escaping ([Learner]?, Error?) -> Void ) {
        Task{
            guard let learners = await getAllLearners() else { completionHandler(nil, LearnerInfoError.itemNotFound)
                return
            }
            completionHandler(learners, nil)
        }
    }
    
    
    func getAllLearners() async -> [Learner]? {
        
        urlComponents.path = "/classroom"
        do {
            let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                      throw LearnerInfoError.creationFailed
                  }
            return try Learner.decodeLearners(from: data)
        }catch{
            logger.error("Error getting all Learners: \(error.localizedDescription)")
            return nil
        }
    }
    
    @available(*, deprecated, message: "Prefer async alternative instead")
    func create(_ learner: Learner, _ completionHandler: @escaping (Learner?, Error?) -> Void ) {
        Task{
            guard let newLearner = await create(learner) else { completionHandler(nil, LearnerInfoError.creationFailed)
                return
            }
            completionHandler(newLearner, nil)
        }
    }
    
    func create(_ learner: Learner) async -> Learner? {
        urlComponents.path = "/classroom"
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(learner) else {
            logger.error("Error: Trying to convert model to JSON data")
            //throw LearnerInfoError.creationFailed
            return nil
        }
        
        var request = getRequest(url: urlComponents.url!, method: .post)
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                return nil
            }
            
            let newLearner = try Learner(data)
            
            return newLearner
        }catch{
            logger.error("Error create new learner: \(LearnerInfoError.creationFailed.localizedDescription)")
            return nil
            
        }
        
    }
}
