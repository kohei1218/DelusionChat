//
//  Talk.swift
//  mousouChat
//
//  Created by 齋藤　航平 on 2018/06/01.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import Foundation

struct Talk: Codable {
    let status: Int
    let message: String
    let results: [Result]
}

struct Result: Codable {
    let perplexity: Double
    let reply: String
}
