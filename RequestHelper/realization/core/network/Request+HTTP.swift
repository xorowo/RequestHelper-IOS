//
//  Request+HTTP.swift
//  RequestHelper
//
//  Created by  Work on 26.04.2023.
//

import Foundation

public protocol MethodIdProtocol {
    var value: String { get }
}

public enum MethodId: String, MethodIdProtocol {
    case unowned
    public var value: String { rawValue }
}

public enum HttpId: String {
    case unowned, GET, PUT, POST, DELETE, PATCH
}

public enum ProtocolId: String {
    case HTTPS = "https:",
         HTTP = "http:",
         WSS = "wss:",
         WS = "ws:"
}
