//
//  Response.swift
//  RequestHelper
//
//  Created by  Work on 26.04.2023.
//

import Foundation

public extension Request {
    
    class Response {
        
        public var success = false
        public var code = 0
        public var result: Data?
        public var JSON: Any?
        public var headers: [AnyHashable: Any]?
        
        public init() {}
        
        public class func response(_ data: Data?, _ code: Int, _ headers: [AnyHashable: Any]?) -> Response {
            
            let item = Response()
            item.code = code
            item.success = (200...299).contains(item.code)
            item.result = data
            item.JSON = data?.JSONDecode
            item.headers = headers
            return item
            
        }
        
    }
    
}
