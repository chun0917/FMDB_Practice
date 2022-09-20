//
//  Singleton.swift
//  FMDB_Practice
//
//  Created by 呂淳昇 on 2022/9/14.
//

import Foundation

class ResumeSingleton{
    static let shared = ResumeSingleton()
    var id: String = ""
    var name: String = ""
    var age: Int = 0
}
