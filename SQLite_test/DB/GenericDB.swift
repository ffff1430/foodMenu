//
//  GenericDB.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/10/9.
//

import Foundation
import SQLite3

protocol DatabaseModel {
    static var tableName: String { get }
    static var getTableSQLStrForCreate: String { get }
    static var getSQLStrForInsert: String { get }
    static var getSQLStrForUpdate: String { get }  // 新增
    static var getSQLStrForDelete: String { get }
    static func bindValues(statement: OpaquePointer?, model: Self)
    static func bindUpdateValues(statement: OpaquePointer?, model: Self) // 新增
    static func bindDeleteValues(statement: OpaquePointer?, model: Self) // 新增
    static func createFromStatement(statement: OpaquePointer?) -> Self
    static func createFromStatement(values: [String], statement: OpaquePointer?) -> Self
}

public enum DBResult {
    case success(String)
    case failure(String)
}

class GenericDB<T: DatabaseModel> {
    
    static func shared() -> GenericDB {
        return GenericDB()
    }
    
    private var db: OpaquePointer?
    
    private func getDatabasePath() -> String {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("genericDB.sqlite").path
    }
    
    public func createDB(completion: @escaping (DBResult) -> Void) {
        db = nil
        let dbPath = getDatabasePath()
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("成功打開資料庫 \(dbPath)")
            
            // 創建表格
            if sqlite3_exec(db, T.getTableSQLStrForCreate, nil, nil, nil) == SQLITE_OK {
                completion(.success("創建表格成功"))
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                completion(.failure("創建表格成功：\(errmsg)"))
            }
            
            sqlite3_close(db)
        } else {
            completion(.failure("無法打開資料庫"))
        }
    }
    
    public func insert(models: [T], completion: @escaping (DBResult) -> Void) {
        let dbPath = getDatabasePath()
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            var statement: OpaquePointer?
            
            for model in models {
                //
                if sqlite3_prepare_v2(db, T.getSQLStrForInsert, -1, &statement, nil) == SQLITE_OK {
                    T.bindValues(statement: statement, model: model)
                    
                    if sqlite3_step(statement) == SQLITE_DONE {
                        completion(.success("插入成功"))
                    } else {
                        completion(.failure("插入失敗"))
                    }
                } else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    completion(.failure("預編譯失敗：\(errorMessage)"))
                }
            }
            
            sqlite3_finalize(statement)
            sqlite3_close(db)
        } else {
            completion(.failure("無法打開資料庫"))
        }
    }
    
    public func fetchAll(completion: @escaping (DBResult) -> Void) -> [T] {
        var result = [T]()
        let dbPath = getDatabasePath()
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            var statement: OpaquePointer?
            
            let fetchSQL = "SELECT * FROM \(T.tableName);"
            if sqlite3_prepare_v2(db, fetchSQL, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let model = T.createFromStatement(statement: statement)
                    result.append(model)
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                completion(.failure("查詢預編譯失敗：\(errorMessage)"))
            }
            
            sqlite3_finalize(statement)
            sqlite3_close(db)
        } else {
            completion(.failure("無法打開資料庫"))
        }
        
        return result
    }
    
    public func isTableCreated() -> Bool {
        let dbPath = getDatabasePath()
        var result = false
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            var statement: OpaquePointer?
            let query = "SELECT name FROM sqlite_master WHERE type='table' AND name='\(T.tableName)';"
            
            //数据库句柄、SQL 查詢語句、字符串的長度、準備好的SQL語句、SQL 查詢語句的剩餘部分
            //將 SQL 查詢從文本形式編譯成可執行的 SQL 語句，這個過程被稱為「預編譯」，statement會把已編譯成可執行的 SQL 語句儲存起來方便重複利用
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_ROW {
                    result = true  // 表格存在
                }
            }
            
            //執行完後要把statement儲存的已編譯成可執行的 SQL 語句給釋放掉
            sqlite3_finalize(statement)
            sqlite3_close(db)
        } else {
            print("無法打開資料庫")
        }
        
        return result
    }
    
    public func delete(model: T, completion: @escaping (DBResult) -> Void) {
        let dbPath = getDatabasePath()
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, T.getSQLStrForDelete, -1, &statement, nil) == SQLITE_OK {
                T.bindDeleteValues(statement: statement, model: model)
                
                //SQLite 會開始執行編譯好的 SQL 語句
                if sqlite3_step(statement) == SQLITE_DONE {
                    completion(.success("刪除成功"))
                } else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    completion(.failure("刪除失败：\(errorMessage)"))
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                completion(.failure("刪除失败：\(errorMessage)"))
            }
            
            sqlite3_finalize(statement)
            sqlite3_close(db)
        } else {
            completion(.failure("無法打開資料庫"))
        }
    }
    
    public func update(model: T, completion: @escaping (DBResult) -> Void) {
        let dbPath = getDatabasePath()
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, T.getSQLStrForUpdate, -1, &statement, nil) == SQLITE_OK {
                T.bindUpdateValues(statement: statement, model: model)
                
                //SQLite 會開始執行編譯好的 SQL 語句
                if sqlite3_step(statement) == SQLITE_DONE {
                    completion(.success("更新成功"))
                } else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    completion(.failure("更新失败：\(errorMessage)"))
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                completion(.failure("更新失败：\(errorMessage)"))
            }
            
            sqlite3_finalize(statement)
            sqlite3_close(db)
            
        } else {
            completion(.failure("無法打開資料庫"))
        }
    }
    
    public func fetchSpecificField(selectValue: String, fieldName: String, fieldValue: String, completion: @escaping (DBResult) -> Void) -> [T] {
        var result = [T]()
        let dbPath = getDatabasePath()
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            var statement: OpaquePointer?
            let fetchSQL = "SELECT \(selectValue) FROM \(T.tableName) WHERE \(fieldName) = ?;"
            
            if sqlite3_prepare_v2(db, fetchSQL, -1, &statement, nil) == SQLITE_OK {
                // Bind the fieldValue to the prepared statement (assuming it is a string).
                sqlite3_bind_text(statement, 1, (fieldValue as NSString).utf8String, -1, nil)
                
                while sqlite3_step(statement) == SQLITE_ROW {
                    // Create a model from the current statement
                    if (selectValue == "*") {
                        let model = T.createFromStatement(statement: statement)
                        result.append(model)
                    } else {
                        let valuesArray = selectValue.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                        let model = T.createFromStatement(values: valuesArray, statement: statement)
                        result.append(model)
                    }
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                completion(.failure("查询失败：\(errorMessage)"))
            }
            
            sqlite3_finalize(statement)
            sqlite3_close(db)
        } else {
            completion(.failure("無法打開資料庫"))
        }
        
        return result
    }
    
    public func fetchFilterField(selectValue: String, city: String, searchText: String, completion: @escaping (DBResult) -> Void) -> [T] {
        var result = [T]()
        var parameters: [String] = []
        let dbPath = getDatabasePath()
        var citySql = ""
        var nameSql = ""
        
        // 如果 city 不是 "全部" 且不是空字串，則根據 city 過濾
        if !city.isEmpty && city != "全部" {
            citySql = "AND City LIKE '%\(city)%'"
            parameters.append(city)
        }
        
        // 根據 searchText 過濾
        if !searchText.isEmpty {
            nameSql = "AND Name LIKE '%\(searchText)%'"
            parameters.append(searchText)
        }
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            var statement: OpaquePointer?
            let fetchSQL = "SELECT \(selectValue) FROM \(T.tableName) WHERE 1 = 1 \(citySql) \(nameSql);"
            print("parameters: \(parameters)")
            print("fetchSQL: \(fetchSQL)")
            
            if sqlite3_prepare_v2(db, fetchSQL, -1, &statement, nil) == SQLITE_OK {
                // Bind the fieldValue to the prepared statement (assuming it is a string).
//                for (index, param) in parameters.enumerated() {
//                    sqlite3_bind_text(statement, Int32(index + 1), param.lowercased(), -1, nil)
//                }
                
                while sqlite3_step(statement) == SQLITE_ROW {
                    // Create a model from the current statement
                    if (selectValue == "*") {
                        let model = T.createFromStatement(statement: statement)
                        result.append(model)
                    } else {
                        let valuesArray = selectValue.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                        let model = T.createFromStatement(values: valuesArray, statement: statement)
                        result.append(model)
                    }
                }
                completion(.success("查詢成功"))
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                completion(.failure("查询失败：\(errorMessage)"))
            }
            
            sqlite3_finalize(statement)
            sqlite3_close(db)
        } else {
            completion(.failure("無法打開資料庫"))
        }
        
        return result
    }
    
    private init() { }
}
