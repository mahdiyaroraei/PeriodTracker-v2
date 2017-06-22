//
//  PeriodTrackerAPI.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/22/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Moya

let PeriodTrackerProvider = MoyaProvider<PeriodTrackerAPI>()

public enum PeriodTrackerAPI {
    case upload
}

extension PeriodTrackerAPI: TargetType{
    public var baseURL: URL { return URL(string: "https://upload.giphy.com")! }
    public var path: String {
        switch self {
        case .upload:
            return "/v1/gifs"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .upload:
            return .post
        }
    }
    public var parameters: [String: Any]? {
        switch self {
        case .upload:
            return ["api_key": "dc6zaTOxFJmzC", "username": "Moya"]
        }
    }
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var task: Task {
        return .request
    }
    public var sampleData: Data {
        switch self {
        case .upload:
            return "{\"data\":{\"id\":\"your_new_gif_id\"},\"meta\":{\"status\":200,\"msg\":\"OK\"}}".data(using: String.Encoding.utf8)!
        }
    }
}
