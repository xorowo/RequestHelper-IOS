//
//  HTTPManager.swift
//  RequestHelper
//
//  Created by  Work on 26.04.2023.
//

import Foundation

open class HTTPManager {
    
    private class var shared: HTTPManager {
        initialization()
    }
    
    private static let _shared = HTTPManager()
    open class func initialization() -> HTTPManager {
        _shared
    }
    
    open var isEnableRefresh: Bool {
        false
    }
    
    public var refreshAction = false
    public var queueRequests = [Request]()
    
    required public init() {}
    
    open class func URLSessionHandler(data: Data?, response: URLResponse?, error: Error?) {}
    
    @discardableResult
    open class func load(_ request: Request) -> URLSessionDataTask? {
        
        var state = Self.shared.refreshAction
        if isRefreshMethods(request.methodId) {
            state = false
        }
        
        guard !state else {
            Self.shared.queueRequests.append(request)
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: request.urlRequest) { (data, resp, error) in
            
            let http = resp as? HTTPURLResponse
            let response = Request.Response.response(data, http?.statusCode ?? 0, http?.allHeaderFields)
            response.headers = http?.allHeaderFields
            
            URLSessionHandler(data: data, response: resp, error: error)
            
            guard [401,403].contains(response.code),
                  !isRefreshMethods(request.methodId),
                  Self.shared.isEnableRefresh else {
                
                DispatchQueue.main.async {
                    request.completion?(response)
                }
                
                HTTPManager.logs(urlRequest: request.urlRequest,
                                 error: error,
                                 data: data,
                                 response: response)
                
                return
            }
            
            HTTPManager.logs(urlRequest: request.urlRequest,
                             error: error,
                             data: data,
                             response: response)
            
            Self.shared.queueRequests.append(request)
            if !Self.shared.refreshAction {
                Self.shared.willStartRefresh()
            }
        
        }
        
        task.resume()
        return task
        
    }
    
    open func willStartRefresh() {
        refreshAction = true
    }
    
    public func didFinishRefresh(_ response: Request.Response) {
        
        refreshAction = false
        queueRequests.forEach {
            guard response.success else {
                $0.completion?(response)
                return
            }
            Self.load($0)
        }
        queueRequests.removeAll()
    
    }
    
    open class func isRefreshMethods(_ mId: MethodIdProtocol) -> Bool {
        false
    }
    
    //MARK: Console
    static func logs(urlRequest: URLRequest, error: Error?, data: Data?, response: Request.Response) {
        let defaultText = "nil"
        
        print("\n\n")
        print("-----------------------------------------------REQUEST-----------------------------------------------")
        print("URL ->", urlRequest.url ?? defaultText)
        print("allHTTPHeaderFields ->", urlRequest.allHTTPHeaderFields ?? defaultText)
        print("body ->", urlRequest.httpBody != nil ? String(bytes: urlRequest.httpBody!, encoding: .utf8) ?? defaultText : defaultText)
        print("code ->", response.code)
        print("data bytes ->", data ?? defaultText)
        if let data = data {
            print("decode data (prefix 500) ->", String(decoding: data, as: UTF8.self).prefix(500))
        }
        print("---------------------------------------------END_REQUEST---------------------------------------------")
        print("\n")
        
    }
    
}
