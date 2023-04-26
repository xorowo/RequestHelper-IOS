//
//  Body.swift
//  RequestHelper
//
//  Created by  Work on 26.04.2023.
//

public extension Request {
    
    struct Body {
        
       public var path: String? = nil
       public var body: Any? = nil
       public var param: [String: Any]? = nil
       public var host: String? = nil
       public var fromData: FormData? = nil
        
       public func closeBoundary() {
            fromData?.closeBoundary()
       }
    
    }
    
}
