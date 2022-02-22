//
//  Student.swift
//  Classroom
//
//  Created by Gianluca Orpello for the Developer Academy on 18/01/22.
//

import Foundation

struct Learner: Identifiable, Codable {
    var id: UUID
    var name: String
    var surname: String
    var imageName: String
    var shortBio: String
    
    init(
        id: UUID,
        name: String,
        surname: String,
        imageName: String,
        shortBio: String
    ) {
        self.id = id
        self.name = name
        self.surname = surname
        self.imageName = imageName
        self.shortBio = shortBio
    }
    
    init(_ data: Data) throws {
        let jsonDecoder = JSONDecoder()
        let learner = try jsonDecoder.decode(Learner.self, from: data)
        self.id = learner.id
        self.name = learner.name
        self.surname = learner.surname
        self.imageName = learner.imageName
        self.shortBio = learner.shortBio
    }
    
    static func decodeLearners(from data: Data) throws -> [Learner] {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode([Learner].self, from: data)
    }
}


enum LearnerInfoError: Error, LocalizedError {
    case itemNotFound, creationFailed, serverError
    
    var localizedDescription: String {
        switch self {
        case .itemNotFound:
            return "I could not find the item I was looking for, it could be a server problem or not..."
        case .creationFailed:
            return "I was unable to create the desired item, it could be a server problem or not..."
        case .serverError:
            return "This is definitely a server error, ask a mentor what is going on ..."
        }
    }
}
