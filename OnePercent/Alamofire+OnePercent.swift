//
//  Alamofire+OnePercent.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 10. 31..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper


extension Alamofire.Request {
    
//    public func response() -> (request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: NSError?) {
//        let semaphore = DispatchSemaphore(value: 0)
//        var result: (request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: NSError?)!
//        
//        self.response(completionHandler: { request, response, data, error in
//            result = (
//                request: request,
//                response: response,
//                data: data,
//                error: error
//            )
//            semaphore.signal()
//        })
//        
//        semaphore.wait(timeout: DispatchTime.distantFuture)
//        return result
//    }
//
//    public func responseData() -> Response<Data, NSError> {
//        let semaphore = DispatchSemaphore(value: 0)
//        var result: Response<Data, NSError>!
//        
//        self.responseData { response in
//            result = response
//            semaphore.signal()
//        }
//        
//        semaphore.wait(timeout: DispatchTime.distantFuture)
//        return result
//    }
//    
//    public func responseJSON(options: JSONSerialization.ReadingOptions = .allowFragments) -> Response<AnyObject, NSError> {
//        let semaphore = DispatchSemaphore(value: 0)
//        var result: Response<AnyObject, NSError>!
//        
//        self.responseJSON(options: options, completionHandler: {response in
//            result = response
//            semaphore.signal()
//        })
//        
//        semaphore.wait(timeout: DispatchTime.distantFuture)
//        return result
//    }
//    
//    public func responseString(encoding: String.Encoding? = nil) -> Response<String, NSError> {
//        let semaphore = DispatchSemaphore(value: 0)
//        var result: Response<String, NSError>!
//        
//        self.responseString(encoding: encoding, completionHandler: { response in
//            result = response
//            semaphore.signal()
//        })
//        
//        semaphore.wait(timeout: DispatchTime.distantFuture)
//        return result
//    }
//    
//    public func responsePropertyList(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Response<AnyObject, NSError> {
//        let semaphore = DispatchSemaphore(value: 0)
//        var result: Response<AnyObject, NSError>!
//        
//        self.responsePropertyList(options: options, completionHandler: { response in
//            result = response
//            semaphore.signal()
//        })
//        
//        semaphore.wait(timeout: DispatchTime.distantFuture)
//        return result
//    }
//    
//    public func responseObject<T: Mappable>(encoding: String.Encoding? = nil) -> DataResponse<T> {
//        let semaphore = DispatchSemaphore(value: 0)
//        var result: DataResponse<T>!
//
//        self.responseObject { (response: DataResponse<T>) -> Void in
//            result = response
//            semaphore.signal()
//        }
//        
//        semaphore.wait(timeout: DispatchTime.distantFuture)
//        return result
//    }
    
//    public func responseObject<T: Mappable>(queue: DispatchQueue? = nil, keyPath: String? = nil, mapToObject object: T? = nil, completionHandler: (DataResponse<T>) -> Void) -> Self {
//        return responseObject { (response: DataResponse<T>) -> Void in
//            response
//        }
//    }
    
    
//    
//    public func responseObject<T: Mappable>(completionHandler: (DataResponse<T>) -> Void) -> Self {
//        return responseObject { (response: DataResponse<T>) -> Void in
//            response
//        }
//    }

}
