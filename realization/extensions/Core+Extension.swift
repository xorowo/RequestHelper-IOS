//
//  Core+Extension.swift
//  RequestHelper
//
//  Created by  Work on 26.04.2023.
//

import Foundation

public extension Data {
    
    var JSONDecode: Any? {
        try? JSONSerialization.jsonObject(with: self)
    }
    
}

public extension Dictionary {
    
    var JSONEnecode: Data? {
        try? JSONSerialization.data(withJSONObject: self, options: [])
    }
    
    var JSONString: String? {
        guard let json = JSONEnecode else { return nil }
        return String(data: json, encoding: .ascii)
    }
    
}

public extension Array {
    
    var JSONEnecode: Data? {
        try? JSONSerialization.data(withJSONObject: self, options: [])
    }
    
}

public extension String {
    
    var urlValue:URL? {
        URL(string: self)
    }
    
}

public extension Dictionary where Key == String {
    
    var toParamToString: String {
        var result = String()
        self.keys.forEach { key in
            guard let value = self[key] else { return }
            if let array = value as? [Any] {
                array.forEach {
                    result += "\(key)=\($0)&"
                }
            } else {
                result += "\(key)=\(value)&"
            }
        }
        return result
    }
    
}
