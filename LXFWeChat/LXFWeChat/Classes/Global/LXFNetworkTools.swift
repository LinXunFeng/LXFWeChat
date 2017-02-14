//
//  LXFNetworkTools.swift
//  Alamofire封装
//
//  Created by LXF on 2016/11/14.
//  Copyright © 2016年 林洵锋. All rights reserved.
//

import UIKit
import AFNetworking

/// 定义枚举类型
enum LXFRequestType: Int {
    case GET
    case POST
}

class LXFNetworkTools: AFHTTPSessionManager {
    static let shared: LXFNetworkTools = {
        let tools = LXFNetworkTools()
        tools.responseSerializer.acceptableContentTypes = [
            "application/json",
            "text/html",
            "text/plain",
            "image/jpeg",
            "image/png",
            "application/octet-stream",
            "text/json",
            ] as Set
        return tools
    }()
}

// MARK:- 封装请求方法
extension LXFNetworkTools {
    // MARK: 请求JSON数据
    // 将成功和失败的回调写在一个逃逸闭包中
    func request(methodType: LXFRequestType, urlString: String, parameters: [String : Any], resultBlock:@escaping ([String : Any]?, Error?) -> ()) {
        
        // 定义请求结果的回调闭包
        // 成功
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            resultBlock(responseObj as? [String : Any], nil)
        }
        // 失败
        let failureBlock = { (task: URLSessionDataTask?, error: Error?) in
            resultBlock(nil, error)
        }
        
        // 发送请求
        if methodType == .GET { // GET
            get(urlString, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        } else if methodType == .POST { // POST
            post(urlString, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
    }
    
    // MARK: 下载文件
    /**
     下载文件
     
     - parameter urlStr:      文件的网络地址
     - parameter savePath:    保存路径(包含文件名)
     - parameter progress:    进度
     - parameter resultBlock: 结果回调
     */
    func download(urlStr: String, savePath: String, progress: ((_ progress: Double) -> ())?, resultBlock: ((URL?, Error?)->())?) {
        let urlRequest = URLRequest(url: URL(string: urlStr)!)
        let task = self.downloadTask(with: urlRequest, progress: {
            if progress != nil {
                progress!(($0.fractionCompleted))
            }
        }, destination: { (url, response) -> URL in
            return URL(fileURLWithPath: savePath)
        }, completionHandler: { (response, url, error) in
            if resultBlock != nil {
                resultBlock!(url, error)
            }
        })
        
        task.resume()
    }
    
}



