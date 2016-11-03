////
////  AlamofireLogger.swift
////  OnePercent
////
////  Created by 김혜원 on 2016. 10. 31..
////  Copyright © 2016년 김혜원. All rights reserved.
////
import Alamofire

// MARK: AlamofireLogger extension

extension DataRequest {
    
    /// The logging level. `Simple` prints only a brief request/response description; `Verbose` prints the request/response body as well.
    public enum LogLevel {
        /// Prints the request and response at their respective `Simple` levels.
        case simple
        /// Prints the request and response at their respective `Verbose` levels.
        case verbose
    }
    
    /// Log the request and response at the specified `level`.
    public func log(level: LogLevel = .simple) -> Self {
        switch level {
        case .simple:
            return logRequest(level: .simple).logResponse(level: .simple)
        case .verbose:
            return logRequest(level: .verbose).logResponse(level: .verbose)
        }
    }
    
    /// The request logging level. `Simple` prints only the HTTP method and path; `Verbose` prints the request body as well.
    public enum RequestLogLevel {
        /// Print the request's HTTP method and path.
        case simple
        /// Print the request's HTTP method, path, and body.
        case verbose
    }
    
    /// Log the request at the specified `level`.
    public func logRequest(level: RequestLogLevel = .simple) -> Self {
        guard let request = request else {
            return self
        }
        
        guard let method = request.httpMethod, let path = request.url?.absoluteString else {
            return self
        }
        
        if let data = request.httpBody, let body = NSString(data: data, encoding: String.Encoding.utf8.rawValue), level == .verbose {
            print("\(method) \(path): \"\(body)\"")
        } else {
            print("\(method) \(path)")
        }
        
        return self
    }
    
    /// The response logging level. `Simple` prints only the HTTP status code and path; `Verbose` prints the response body as well.
    public enum ResponseLogLevel {
        /// Print the response's HTTP status code and path, or error if one is returned.
        case simple
        /// Print the response's HTTP status code, path, and body, or error if one is returned.
        case verbose
    }
    
    /// Log the response at the specified `level`.
    public func logResponse(level: ResponseLogLevel = .simple) -> Self {
        
        response { dataResponse in // request, response, data, error in
            guard let response = dataResponse.response else {
                if let path = dataResponse.request?.url?.absoluteString, let description = dataResponse.error?.localizedDescription {
                    print("XXX \(path): \"\(description)\"")
                }
                return
            }
            
            guard let path = dataResponse.response?.url?.absoluteString else {
                return
            }
            
            if let data = dataResponse.data, let body = NSString(data: data, encoding: String.Encoding.utf8.rawValue), level == .verbose {
                print("\(response.statusCode) \(path): \"\(body)\"")
            } else {
                print("\(response.statusCode) \(path)")
            }
        }
        
        return self
    }
    
}
