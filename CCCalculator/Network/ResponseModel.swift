//
//  ResponseModel.swift
//  CCCalculator
//
//  Created by Amr Hesham on 22/04/2021.
//

import Foundation

struct ResponseModel<T: Codable>: Codable {
    
    // MARK: - Properties
    var isSuccess: Bool?
    var message: String?
    var error: ErrorModel {
        return ErrorModel(message ?? "")
    }
    var data: T?
    var request: RequestModel?
    
    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        isSuccess = (try? keyedContainer.decode(Bool.self, forKey: CodingKeys.isSuccess)) ?? false
        message = (try? keyedContainer.decode(String.self, forKey: CodingKeys.message)) ?? ""
        data = try? keyedContainer.decode(T.self, forKey: CodingKeys.data)
    }
}

// MARK: - Private Functions
extension ResponseModel {

    private enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case data
    }
}
