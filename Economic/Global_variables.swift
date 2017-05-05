import UIKit

struct Constants {
  
  struct ApiName{
    static let API_SERVER = "https://api..dk"
  }
  
  struct ApiRequestNames{
    //MARK: APIRequest konstanter
    static let kLoadGEOData = "loadGEOData"
    static let kSaveUnSafe = "saveUnSafe"
  }
  
  struct CellNames {
    
  }
  
  struct Configuration {
    }
    
    struct GoSafeApi {
        static let REGULAR_GET_GEOINFO: NSDictionary = ["service" : "api/Get/GetGeoData", "transferMethod" : "GET" ,  "headers" : API_DEFAULT_HEADERS]
        
         static let REGULAR_ADD_UNSAFE: NSDictionary = ["service" : "api/Add/AddUnsafe", "transferMethod" : "POST"]
    }

}

let API_DEFAULT_HEADERS = [
    "AppId": "GoSafeIphone",
    "AppSecret": "315cf38a052147687fcfc94e0a2f3c7c",
    "Accept-Encoding" : "gzip;q=1.0,compress;q=0.5"
]

//MARK: Animationshastighed konstant
let animationSpeed = 0.3

//MARK: Altitude konstant
let  kMaxZoomLevelValueIphone:UInt = 14
let  kMaxZoomLevelValueIPad:UInt = 15
let kMaxZoomLevelValue = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) ? kMaxZoomLevelValueIphone : kMaxZoomLevelValueIPad
let  kMinZoomLevelValue:UInt = 18

