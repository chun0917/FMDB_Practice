//
//  Database.swift
//  FMDB_Practice
//
//  Created by 呂淳昇 on 2022/9/8.
//

import Foundation
import FMDB

class Database : NSObject{
    
    static let shared = Database()
    var fileName: String = "Resume.db" // 資料庫名稱
    var filePath: String = "" // 資料庫路徑
    var database: FMDatabase!
    
    private override init() {
        super.init()
        // 取得資料庫在Documents中的路徑
        self.filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/" + self.fileName
        print("filePath: \(self.filePath)")
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // 判斷是否成功連線至資料庫
    func connectDB() -> Bool {
        var isConnect: Bool = false
        self.database = FMDatabase(path: self.filePath)
        if self.database != nil {
            if self.database.open() {
                isConnect = true
            } else {
                print("未連線至資料庫")
            }
        }
        return isConnect
    }
    
    // 建立資料表
    func createTable() {
        let fileManager: FileManager = FileManager.default
        // 判斷Documents是否存在該db檔
        if !fileManager.fileExists(atPath: filePath) {
            if self.connectDB() {
                let createResumeTable = "CREATE TABLE RESUME(id Varchar(50) NOT NULL PRIMARY KEY,name Varchar(30) NOT NULL,age integer NOT NULL)"
                self.database.executeStatements(createResumeTable)
                print("成功建立資料表於\(self.filePath)")
            }
        } else {
            print("檔案已存在於\(self.filePath)")
        }
    }
    
    // 新增資料
    func insertData(id: String, name: String, age: Int) {
        if self.connectDB() {
            let insertData = "INSERT INTO RESUME(id,name,age) VALUES (?,?,?)"
            
            if self.database.executeUpdate(insertData, withArgumentsIn: [id,name,age]) {
                print("新增資料成功")
            }else{
                print("新增資料失敗")
                print(database.lastError(), database.lastErrorMessage())
            }
            self.database.close()
        }
    }
    
    // 刪除資料
    func deleteData(id: String){
        if self.connectDB() {
            let deleteData = "DELETE FROM RESUME WHERE id = ?"
            
            if self.database.executeUpdate(deleteData, withArgumentsIn: [id]) {
                print("刪除資料成功")
            }else{
                print("刪除資料失敗")
                print(database.lastError(), database.lastErrorMessage())
            }
            self.database.close()
        }
    }
    // 修改資料
    func updateData(id: String, name: String, age: Int){
        if self.connectDB() {
            let updateData = "UPDATE RESUME SET name = ?, age = ? WHERE id = ?"
            do {
                try self.database.executeUpdate(updateData, values: [name,age,id])
            } catch {
                print(error.localizedDescription)
            }
            self.database.close()
        }
    }
    
    func fetchData() -> [Resume]{
        var resume = [Resume]()
        if self.connectDB(){
            let fetchData = "SELECT * FROM RESUME"
            do {
                let dataLists: FMResultSet = try database.executeQuery(fetchData, values: nil)
                while dataLists.next() {
                    let data: Resume = Resume(id: dataLists.string(forColumn: "id")!, name: dataLists.string(forColumn: "name")!, age: dataLists.long(forColumn: "age"))
                    resume.append(data)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return resume
    }
}
