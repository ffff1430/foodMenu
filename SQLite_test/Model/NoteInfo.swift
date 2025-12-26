//
//  NoteInfo.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/11/5.
//

import Foundation
import SQLite3

public struct NoteInfo: DatabaseModel {
    
    var id: Int?
    var level: String
    var date: String
    var addDate: String?
    var review: String
    var foodID: Int?
    
    static var tableName: String {
        return "Note"
    }
    
    static var getTableSQLStrForCreate: String {
        return """
                CREATE TABLE IF NOT EXISTS Note (
                    ID INTEGER PRIMARY KEY AUTOINCREMENT,
                    Level TEXT,
                    Date TEXT,
                    AddDate TEXT DEFAULT CURRENT_TIMESTAMP,
                    Review TEXT,
                    FoodID INTEGER
                );
            """
    }
    
    static var getSQLStrForDelete: String {
        return "DELETE FROM Note WHERE ID = ?;"
    }
    
    static var getSQLStrForInsert: String {
        return """
        INSERT INTO Note (Level, Date, Review, FoodID)
        VALUES (?, ?, ?, ?);
    """
    }
    
    static var getSQLStrForUpdate: String {
        return "UPDATE Note SET Level = ?, Date = ?, Review = ?, FoodID = ? WHERE ID = ?;"
    }
    
    static func bindValues(statement: OpaquePointer?, model: NoteInfo) {
        sqlite3_bind_text(statement, 1, (model.level as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (model.date as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, (model.review as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 4, Int32(model.foodID ?? 0))
    }
    
    static func bindUpdateValues(statement: OpaquePointer?, model: NoteInfo) {
        sqlite3_bind_text(statement, 1, (model.level as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (model.date as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, (model.review as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 4, Int32(model.foodID ?? 0))
        
        if let id = model.id {
            sqlite3_bind_int(statement, 5, Int32(id))
        }
        
    }
    
    static func bindDeleteValues(statement: OpaquePointer?, model: NoteInfo) {
        if let id = model.id {
            sqlite3_bind_int(statement, 1, Int32(id))
        }
    }
    
    static func createFromStatement(statement: OpaquePointer?) -> NoteInfo {
        let id = sqlite3_column_int(statement, 0)
        let level = checkValueIsNull(statement: statement, index: 1)
        let date = checkValueIsNull(statement: statement, index: 2)
        let addDate = checkValueIsNull(statement: statement, index: 3)
        let review = checkValueIsNull(statement: statement, index: 4)
        let foodID = sqlite3_column_int(statement, 5)
        
        let note = NoteInfo(
            id: Int(id),
            level: level,
            date: date,
            addDate: addDate,
            review: review,
            foodID: Int(foodID))
        
        return note
    }
    
    static func createFromStatement(values: [String], statement: OpaquePointer?) -> NoteInfo {
        var note = NoteInfo(id: nil, level: "", date: "", addDate: "", review: "", foodID: nil)
        
        let fieldMap: [String: (OpaquePointer?, Int32) -> Void] = [
            "ID": { note.id = Int(sqlite3_column_int($0, $1)) },
            "Level": { note.level = checkValueIsNull(statement: $0, index: $1) },
            "Date": { note.date = checkValueIsNull(statement: $0, index: $1) },
            "AddDate": { note.addDate = checkValueIsNull(statement: $0, index: $1) },
            "Review": { note.review = checkValueIsNull(statement: $0, index: $1) },
            "FoodID": { note.foodID = Int(sqlite3_column_int($0, $1)) },
        ]
        
        for (index, field) in values.enumerated() {
            if let setter = fieldMap[field] {
                setter(statement, Int32(index))
            }
        }
        
        return note
    }
    
}
