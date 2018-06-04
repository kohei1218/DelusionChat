//
//  TalkApi.swift
//  mousouChat
//
//  Created by 齋藤　航平 on 2018/06/01.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import Moya

enum TalkApi {
    case sendTalk(talkStr: String)
}

extension TalkApi: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.a3rt.recruit-tech.co.jp")!
    }
    
    var path: String {
        return "/talk/v1/smalltalk"
    }
    
    var method: Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .sendTalk(let talkStr):
            let apikey = MultipartFormData(provider: .data(getApiKeyFromUserdefaults().data(using: .utf8)!), name: "apikey")
            let query = MultipartFormData(provider: .data(talkStr.data(using: .utf8)!), name: "query")
            let multipartData = [apikey, query]
            return .uploadMultipart(multipartData)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/json"]
    }
    
    func getApiKeyFromUserdefaults() -> String {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: "api_key")!
    }
}
