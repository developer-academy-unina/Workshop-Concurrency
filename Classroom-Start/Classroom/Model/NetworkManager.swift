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
        urlComponents.path = "/classroom"

        logger.info("Start Getting all Learners")
        URLSession.shared.dataTask(with: urlComponents.url!) { [weak self] (data, response, error) in
            guard error == nil, let data = data else {
                completionHandler(nil, error)
                self?.logger.error("Failed Getting all Learners \(#function): \(error!.localizedDescription)")
                return
            }
            
            self?.logger.info("Finish get all Learners")
            let learners = try? Learner.decodeLearners(from: data)
            completionHandler(learners, nil)
            
        }.resume()
    }
    
    @available(*, deprecated, message: "Prefer async alternative instead")
    func create(_ learner: Learner, _ completionHandler: @escaping (Learner?, Error?) -> Void ) {
        urlComponents.path = "/classroom"

        guard let jsonData = try? JSONEncoder().encode(learner) else {
            logger.error("Error: Trying to convert model to JSON data")
            completionHandler(nil, LearnerInfoError.creationFailed)
            return
        }
        
        var request = getRequest(url: urlComponents.url!, method: .post)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            
            guard error == nil, let data = data else {
                completionHandler(nil, error)
                self?.logger.error("Failed Create Learner \(#function): \(error!.localizedDescription)")
                return
            }
            
            self?.logger.info("Finish get all Learners")
            let learner = try? Learner(data)
            completionHandler(learner, nil)
            
        }
    }
    
}
