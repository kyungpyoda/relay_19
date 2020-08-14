//
//  DBManager.swift
//  boost_project
//
//  Created by Byoung-Hwi Yoon on 2020/08/07.
//  Copyright © 2020 남기범. All rights reserved.
//

import Foundation
import SQLite3
import FMDB


// 사용시 DBManager.getInstance()를 사용하여 생성
class DBManager : NSObject {
    
    
    private static var database : DBManager?
    
    var dbPath : String = ""
    let dbName : String = "boost1.db"
    
    var docPath : String = ""
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    
    let database : FMDatabase?
    
    override private init() {
        docPath = dirPath[0]
        dbPath = docPath+"/"+dbName
        database = FMDatabase(path: dbPath as String)
    }

    public func createDB() {
        
        let createRealEstateItemTableQuery : String = "CREATE TABLE IF NOT EXISTS RealEstateItem ( "
            + " ID    INTEGER PRIMARY KEY AUTOINCREMENT , "
            + " Address  TEXT , "
            + " Type TEXT , "
            + " Struct TEXT , "
            + " DepositPrice INTEGER , "
            + " MonthlyPrice INTEGER , "
            + " ManagementFee INTEGER , "
            + " Area INTEGER , "
            + " ImageName TEXT , "
            + " FurnitureOptions INTEGER"
            + ")"
        
        let createItem_KeywordTableQuery : String = "CREATE TABLE IF NOT EXISTS ItemKeyword ( "
            + " ID    INTEGER PRIMARY KEY AUTOINCREMENT , "
            + " IID  INTEGER , "
            + " Keyword TEXT"
            + ")"
        
        dbPath = docPath+"/"+dbName
                
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath as String) {
            //DB 객체 생성
            let database : FMDatabase? = FMDatabase(path: dbPath as String)
                 
            if let db = database {
                        //DB 열기
                db.open()
                        //TABLE 생성
                db.executeStatements(createRealEstateItemTableQuery)
                db.executeStatements(createItem_KeywordTableQuery)
                        //DB 닫기
                db.close()
                        
                NSLog("TABLE 생성 성공")
            }else{
                NSLog("TABLE 생성 실패")
            }
        }
    }
    
    public func insertRealEstateItem(item : RealEstateItem) -> Int {
        var createdId = 0
        let sqlInsert : String = "INSERT INTO RealEstateItem (Address, Type, Struct, DepositPrice, MonthlyPrice, ManagementFee, Area, ImageName, FurnitureOptions) VALUES ('\(item.address)' , '\(item.type)' , '\(item.structType)' , '\(item.depositPrice)' , '\(item.monthlyPrice)' , '\(item.managementFee)' , '\(item.area)' , '\(item.imageName)' , '\(item.furnitureOptions)')"

        if let db = database {
            //DB 열기
            db.open()
            db.executeUpdate(sqlInsert, withArgumentsIn: [])
                
            if db.hadError() {
                NSLog("Fail Insert")
            }else{
                db.commit()
                createdId = Int(db.lastInsertRowId)
                NSLog("INSERT SUCCESS")
            }
            //DB 닫기
            db.close()
        }else{
            NSLog("DB 객체 생성 실패")
        }
        return createdId
    }
    
    public func insertKeyword(iid : Int, keyword : String) {
        let sqlInsert : String = "INSERT INTO ItemKeyword (IID, Keyword) VALUES ('\(iid)' , '\(keyword)')"
        if let db = database {
            //DB 열기
            db.open()
            db.executeUpdate(sqlInsert, withArgumentsIn: [])
                
            if db.hadError() {
                NSLog("Fail Insert")
            }else{
                db.commit()
                NSLog("INSERT SUCCESS")
            }
            //DB 닫기
            db.close()
        }else{
            NSLog("DB 객체 생성 실패")
        }
    }
    
    public func findByIID(iid : Int) -> [RealEstateItem]{
        
        let sqlSelect : String = "SELECT * FROM RealEstateItem WHERE ID = '\(iid)'"
        var itemList = [RealEstateItem]()
        
        if let db = database {
            //DB 열기
            db.open()
            let result : FMResultSet? = db.executeQuery(sqlSelect, withArgumentsIn: [])
            if let rs = result {
                while rs.next(){
                    let item = RealEstateItem()
                    item.id = Int(rs.int(forColumn: "ID"))
                    item.address = rs.string(forColumn: "Address") ?? ""
                    item.type = rs.string(forColumn: "Type") ?? ""
                    item.structType = rs.string(forColumn: "Struct") ?? ""
                    item.depositPrice = Int(rs.int(forColumn: "DepositPrice"))
                    item.monthlyPrice = Int(rs.int(forColumn: "MonthlyPrice"))
                    item.managementFee = Int(rs.int(forColumn: "ManagementFee"))
                    item.area = Int(rs.int(forColumn: "Area"))
                    // imageName이 "" 이면 큰일남!
                    item.imageName = rs.string(forColumn: "ImageName")!
                    item.furnitureOptions = Int(rs.int(forColumn: "FurnitureOptions"))
                    itemList.append(item)
                }
            }
            //DB 닫기
            db.close()
        }else{
            NSLog("DB 객체 생성 실패")
        }
        return itemList
    }
    
    public func findByKeyword(keyword : String) -> [Item_KeywordVO]{
        
        let sqlSelect : String = "SELECT * FROM ItemKeyword WHERE Keyword = '\(keyword)'"
        var itemList = [Item_KeywordVO]()
        
        if let db = database {
            //DB 열기
            db.open()
            let result : FMResultSet? = db.executeQuery(sqlSelect, withArgumentsIn: [])
            if let rs = result {
                while rs.next(){
                    let item = Item_KeywordVO()
                    item.id = Int(rs.int(forColumn: "ID"))
                    item.iid = Int(rs.int(forColumn: "IID"))
                    item.keyword = rs.string(forColumn: "Keyword") ?? ""
                    itemList.append(item)
                }
            }
            //DB 닫기
            db.close()
        }else{
            NSLog("DB 객체 생성 실패")
        }
        return itemList
    }

    public static func getInstance() -> DBManager {
        
        if let db = database {
            return db
        }
        return DBManager()
    }
}
