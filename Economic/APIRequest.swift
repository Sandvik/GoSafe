import UIKit
import Alamofire

//MARK: protocol
public protocol APIRequestDelegate {
    func request(_ req: APIRequest, finishedWithResult : AnyObject)
    func request(_ req: APIRequest, failedWithError : NSError)
    func progress(_ req: APIRequest, bytesTotal : Int64, bytesRead : Int64)
}

open class APIRequest{
    //MARK: variables
    var delegate: APIRequestDelegate?
    open var requestID: String
    var serviceTxt:String
    var headers: [String: String]?
    var urlString: String
    open var parameters:[String: AnyObject]?
    //var searchCriteriaParameters:[String: String]?
    open var apiLoginHeader: [String:String]?
    open var remoteServer:String
    //MARK: init
    
    public init (dlg: APIRequestDelegate) {
        self.delegate = dlg
        self.requestID = ""
        self.serviceTxt = ""
        self.headers = [String: String]()
        self.urlString = ""
        self.parameters = [String: String]() as [String : AnyObject]?
        self.apiLoginHeader = [String: String]()
        self.remoteServer = ""
    }
    
    deinit {
    }
    
    open func loadGEOData(propertyID: Int, cellWidth : Int, geoType: String){
        serviceTxt = Constants.GoSafeApi.REGULAR_GET_GEOINFO["service"] as! String
        headers = Constants.GoSafeApi.REGULAR_GET_GEOINFO["headers"] as? Dictionary<String, String>
      //?id={id}&width={width}&type={type}
        urlString = String(format: "%@/%@?id=\(propertyID)&width=\(cellWidth)&type=\(geoType)", self.remoteServer, serviceTxt)
        self.executeRequestWithParameters(.get, urlString: urlString, headers: headers, parameters:parameters)
    }
    
    open func executeRequestWithParameters(_ method: Alamofire.HTTPMethod, urlString : String, headers: [String: String]? = nil, parameters: [String: AnyObject]? = nil, loginString:String? = nil){
        Alamofire.request(urlString,method:method,parameters: parameters, headers: headers)
            .responseJSON {
                response in guard response.result.isSuccess else {
                    if let delegate = self.delegate {
                        if response.response?.statusCode == 200{
                            //print("JSON could not be serialized. Input data was nil or zero length.")
                            delegate.request(self, finishedWithResult:response.data! as AnyObject)
                        }
                        else{
                            let datastring = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                            var eCode:NSInteger = 0
                  
                            if let erCode = response.response{
                                eCode = erCode.statusCode
                            }
                            delegate.request(self, failedWithError:NSError(domain:self.requestID, code: eCode, userInfo: ["message":datastring!]))
                        }
                    }
                    return
                }
                
                if let JSON = response.data {
                     if let delegate = self.delegate {
                        if response.response?.statusCode == 400 || response.response?.statusCode == 401  || response.response?.statusCode == 500{
                            let datastring = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                            delegate.request(self, failedWithError:NSError(domain:self.requestID, code: (response.response?.statusCode)!, userInfo: ["message":datastring!]))
                        }
                        else{
                            delegate.request(self, finishedWithResult:JSON as AnyObject)
                        }
                    }
                }
        }
    }
    
}
