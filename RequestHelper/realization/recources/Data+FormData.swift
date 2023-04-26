//
//  Data+FormData.swift
//  RequestHelper
//
//  Created by  Work on 26.04.2023.
//

import Foundation

private extension Data {
    
    var mimeType: String? {
        var first: UInt8 = 0
        copyBytes(to: &first, count: 1)
        
        switch first {
        case 0xFF:
            return "image/jpeg";
        case 0x89:
            return "image/png";
        case 0x47:
            return "image/gif";
        case 0x49, 0x4D:
            return "image/tiff";
        case 0x25:
            return "application/pdf";
        case 0xD0:
            return "application/vnd";
        case 0x46:
            return "text/plain";
        default:
            return "application/octet-stream"
        }
    }

}

open class FormData {
    
    public var boundary = UUID().uuidString
    private var data = Data(capacity: 1024)
    
    public static func create() -> FormData {
        FormData()
    }
    
    public var fromdata: Data {
        data
    }
    
    public func closeBoundary() {
        __closeBoundary()
    }
    
    public func addStringValue(_ value: String, _ forKey: String) {
        guard let data = value.data(using: .utf8) else { return }
        addValue(data, forKey)
    }
    
    public func addValue(_ data: Data, _ forKey: String) {
        
        let header = "Content-Disposition: form-data; name=\"\(forKey)\""
        guard data.count != 0, forKey.count != 0, let headerData = header.data(using: .utf8) else { return }
        
        __addBoundary()
        self.data.append(headerData)
        __addLineBreak(2)
        self.data.append(data)
        __addLineBreak(1)
    
    }
    
    @discardableResult
    public func addFileData(_ data: Data, _ forName: String,_ forKey: String) -> Bool {
        let header = "Content-Disposition: form-data; name=\"\(forKey)\"; filename=\"\(forName)\""
        guard let mimiType = data.mimeType,
              data.count != 0, forKey.count != 0,
              let headerData = header.data(using: .utf8),
              let typeData = "Content-Type: \(mimiType)".data(using: .utf8) else { return false }
       
        __addBoundary()
        self.data.append(headerData)
        __addLineBreak(1)
        self.data.append(typeData)
        __addLineBreak(2)
        self.data.append(data)
        __addLineBreak(1)
        return true
    }
    
    private func __addBoundary() {
        guard let data = "--\(boundary)".data(using: .utf8) else { return }
        self.data.append(data)
        __addLineBreak(1)
    }
    
    private func __closeBoundary() {
        guard let data = "--\(boundary)--".data(using: .utf8) else { return }
        self.data.append(data)
        __addLineBreak(1)
    }
    
    private func __addLineBreak(_ number: NSInteger) {
        for _ in 0 ..< number {
            guard let data = "\r\n".data(using: .utf8) else { return }
            self.data.append(data)
        }
    }
 }


