//
//  BaseRequest.swift
//



import UIKit

class BaseRequest: NSObject {

    
   class func requestWithHttp(url: String, body: NSData, finished: (json: JSON) -> ()) {
        println(urlHost+url)
        var request = NSMutableURLRequest(URL: NSURL(string:  urlHost+url)!)
        //request.HTTPBody = body
        request.HTTPMethod = kMethodGet
        request.timeoutInterval = kRequestTimeOut
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if data.length > 0 && error == nil {
                // 请求成功
                let json = JSON(data: data)
                finished(json: json)
            } else if data.length == 0 && error == nil {
                //没有数据
                //self.networkError(resp)
            } else if error != nil {
                //超时
                //self.networkError(resp)
            }
            
        })
        task.resume()
    }
//    
//    private func networkError(resp: BaseResponse) {
////        resp.retMsg = "服务器响应失败"
////        AppNotification.send(AppNotificationType.NetworkResponse, userInfo: ["resp" : resp])
//    }
//    
//    func sendNotify(resp: BaseResponse) {
//       // AppNotification.send(AppNotificationType.NetworkResponse, userInfo: ["resp" : resp])
//    }
    
    func deleteFiles(files: [[String]]) {
        let mgr = NSFileManager.defaultManager()
        for f in files {
            if f.count != 2 {
                continue
            }
            let filePath = f[1]
            if mgr.fileExistsAtPath(filePath) {
                mgr.removeItemAtPath(filePath, error: nil)
            }
        }
    }
    func deleteFile(filePath: String) {
        let mgr = NSFileManager.defaultManager()
     
        if mgr.fileExistsAtPath(filePath) {
             mgr.removeItemAtPath(filePath, error: nil)
         }
        
    }
}
enum BaseResult: Int {
    case succ,failure
}

