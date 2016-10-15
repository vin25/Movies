//
//  BaseWebservice.swift
//  Movies
//
//  Created by Vinay Nair on 13/10/16.
//  Copyright © 2016 vinaynair. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol BaseWebserviceCallback {
    func webserviceCallDidSucceed(json: JSON, response: HTTPURLResponse)
    func webserviceCallDidFail(response: HTTPURLResponse?, error:Error)
}


class BaseWebservice {
    
    // MARK: Properties
    
    var callback: BaseWebserviceCallback!
    var appVersion: String!
    
    // MARK: Request methods
    
    func makePOSTWebserviceRequest(URL: String, parameters: [String: AnyObject]) {
        
        Alamofire.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            
            switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
            }
            
            print("Response: \(response)")
                
            self.handleResponse(result: response.result, response: response.response)
        }
        
    }
    
    
    func makeGETWebserviceRequest(URL: String, parameters: String) {
        
        let URLString = URL + "?api_key=" + Authentication.apiKey + "&" + parameters + "&language=en-US"
        
       Alamofire.request(URLString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in

            self.handleResponse(result: response.result, response: response.response)
        }

    }
    
    func handleResponse( result: Result<Any>, response: HTTPURLResponse?) {
        
        //Action based on success or failure
        switch result {
            
            case .success(let value):
                //print("Json: \(JSON(value))")
                self.requestSucceeded(json: JSON(value), response: response!)

            case .failure(let error):
                print(error)
                //self.requestFailed(response, error: err)
        }
        
    }
    
    func requestSucceeded(json: JSON, response: HTTPURLResponse) {
        
        self.callback.webserviceCallDidSucceed(json: json, response: response)
    }
    
    func requestFailed(response: HTTPURLResponse?, error:Error) {
    
        self.callback.webserviceCallDidFail(response:response, error: error)
    }

}
