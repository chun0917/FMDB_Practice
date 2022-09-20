//
//  Resume.swift
//  FMDB_Practice
//
//  Created by 呂淳昇 on 2022/9/8.
//

import Foundation

class Resume : NSObject{
    var id = UUID().uuidString // 每筆資料的唯一識別碼
    var name : String // 姓名
    var age : Int //年齡
    
    init(id : String, name : String, age : Int) {
        self.id = id
        self.name = name
        self.age = age
    }
}
