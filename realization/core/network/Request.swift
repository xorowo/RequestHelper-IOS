//
//  Request.swift
//  RequestHelper
//
//  Created by  Work on 26.04.2023.
//

import Foundation

open class Request: NSObject {
    
    public var httpId = HttpId.GET
    public var methodId: MethodIdProtocol = MethodId.unowned
    public var protocolId = ProtocolId.HTTPS
    public var headers: [String: String]?
    
    public var body: Request.Body?
    public var completion: ((Response) -> Void)?
    
    required public init(_ httpId: HttpId,
                         _ methodId: MethodIdProtocol,
                         _ body: Request.Body?,
                         _ completion: ((Response) -> Void)? = nil,
                         _ headers: [String: String]? = nil,
                         _ protocolId: ProtocolId = .HTTPS) {
        
        super.init()
        
        self.body = body
        self.httpId = httpId
        self.methodId = methodId
        self.completion = completion
        self.protocolId = protocolId
        self.headers = headers
        
    }
    
    public var urlRequest: URLRequest {
        
        var url = URL
        
        if let body = body {
            if let path = body.path {
                url += path
            }
            if let param = body.param {
                url += "?" + param.toParamToString
            }
        }
        
        if let enecode = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
            url = enecode.replacingOccurrences(of: "+", with: "%2B")
        }
        
        var request = URLRequest(url: url.urlValue!)
        if httpId != .unowned {
            request.httpMethod = httpId.rawValue
        }
        
        AUTHORIZATION.keys.forEach {
            guard let value = AUTHORIZATION[$0] else { return }
            request.addValue(value, forHTTPHeaderField: $0)
        }
        
        headers?.keys.forEach {
            guard let value = headers?[$0] else { return }
            request.addValue(value, forHTTPHeaderField: $0)
        }
        
        guard let body = body else { return request }
        
        if httpId != .GET, let fromData = body.fromData {
            request.httpBody = fromData.fromdata as Data
            request.addValue("multipart/form-data; boundary=\(fromData.boundary)", forHTTPHeaderField: "Content-Type")
            request.addValue(String(fromData.fromdata.count), forHTTPHeaderField: "Content-Length")
        } else if httpId != .GET, let jsonBody = body.body {
            
            if let v = jsonBody as? [String: Any?] {
                request.httpBody = v.JSONEnecode
            } else if let v = jsonBody as? [Any] {
                request.httpBody = v.JSONEnecode
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
        }
        return request
        
    }
    
    public var URL: String {
        if methodId.value.isEmpty {
            return String()
        }
        let host:String = {
            guard let value = body?.host else { return HOST }
            return value
        }()
        return protocolId.rawValue + "//" + host + "/" + methodId.value
    }
    
    open var HOST: String {
        String()
    }
    
    open var AUTHORIZATION: [String: String] {
        [:]
    }

}
