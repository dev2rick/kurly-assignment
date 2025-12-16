//
//  DefaultNetworkLogger.swift
//  Data
//
//  Created by rick on 12/16/25.
//

import Foundation

public final class DefaultNetworkLogger: NetworkLogger {
    public init() { }
    
    public func log(request: URLRequest) {
        let method = request.httpMethod ?? "unknown method"
        let url = request.url?.absoluteString ?? ""
        print("------- Start Request -------")
        print("request: \(url)")
        print("method: \(method)")
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("headers: \(headers)")
        }
        
        if
            let httpBody = request.httpBody,
            let result = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject] {
            print("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            print("body: \(String(describing: resultString))")
        }
        print("------- End Request -------")
    }
    
    public func log(responseData data: Data?, response: URLResponse?) {
        print("------- Start Response -------")
        
        let reqURL = response?.url?.absoluteString ?? ""
        print("request: \(reqURL)")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("status: \(httpResponse.statusCode)")
        }
        
        if let data, let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            print("responseData: \(String(describing: dataDict))")
        }
        print("------- End Response -------")
    }
    
    public func log(error: Error) {
        print(error)
    }
}
