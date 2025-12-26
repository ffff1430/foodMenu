//
//  LocalFoodDB.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/9/27.
//

import Foundation
import SQLite3

public struct LocalFoodDB: DatabaseModel {
    
    static var getSQLStrForDelete: String = ""
    
    var id: Int?
    var name: String
    var address: String
    var tel: String
    var hostWords: String
    var price: String
    var openHours: String
    var creditCard: Bool
    var travelCard: Bool
    var trafficGuidelines: String
    var parkingLot: String
    var url: String
    var email: String
    var petNotice: String
    var reminder: String
    var foodMonths: String
    var foodCapacity: String
    var foodFeature: String
    var city: String
    var town: String
    var picURL: String
    var latitude: String
    var longitude: String
    var blogUrl: String
    var isFavorite: Bool
    
    static var tableName: String {
        return "Food"
    }
    
    static var getTableSQLStrForCreate: String {
        return """
                CREATE TABLE IF NOT EXISTS Food (
                    ID INTEGER PRIMARY KEY AUTOINCREMENT,
                    Name TEXT,
                    Address TEXT,
                    Tel TEXT,
                    HostWords TEXT,
                    Price TEXT,
                    OpenHours TEXT,
                    CreditCard INTEGER,
                    TravelCard INTEGER,
                    TrafficGuidelines TEXT,
                    ParkingLot TEXT,
                    URL TEXT,
                    Email TEXT,
                    PetNotice TEXT,
                    Reminder TEXT,
                    FoodMonths TEXT,
                    FoodCapacity TEXT,
                    FoodFeature TEXT,
                    City TEXT,
                    Town TEXT,
                    PicURL TEXT,
                    Latitude TEXT,
                    Longitude TEXT,
                    BlogUrl TEXT,
                    IsFavorite INTEGER
                );
            """
    }
    
    static var getSQLStrForInsert: String {
        return """
        INSERT INTO Food (Name, Address, Tel, HostWords, Price, OpenHours, CreditCard, TravelCard, TrafficGuidelines, ParkingLot, Url, Email, PetNotice, Reminder, FoodMonths, FoodCapacity, FoodFeature, City, Town, PicURL, Latitude, Longitude, BlogUrl, IsFavorite)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
    """
    }
    
    static var getSQLStrForUpdate: String {
        return "UPDATE Food SET IsFavorite = ? WHERE ID = ?;"
    }
    
    static func bindUpdateValues(statement: OpaquePointer?, model: LocalFoodDB) {
        // 绑定 isFavorite 的值 (1 表示 true, 0 表示 false)
        sqlite3_bind_int(statement, 1, model.isFavorite ? 1 : 0)
        // 绑定 foodID
        if let id = model.id {
            sqlite3_bind_int(statement, 2, Int32(id))
        }
    }
    
    static func bindDeleteValues(statement: OpaquePointer?, model: LocalFoodDB) {
        
    }
    
    static func bindValues(statement: OpaquePointer?, model: LocalFoodDB) {
        sqlite3_bind_text(statement, 1, (model.name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (model.address as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, (model.tel as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 4, (model.hostWords as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 5, (model.price as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 6, (model.openHours as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 7, model.creditCard == true ? 1 : 0)
        sqlite3_bind_int(statement, 8, model.travelCard == true ? 1 : 0)
        sqlite3_bind_text(statement, 9, (model.trafficGuidelines as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 10, (model.parkingLot as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 11, (model.url as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 12, (model.email as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 13, (model.petNotice as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 14, (model.reminder as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 15, (model.foodMonths as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 16, (model.foodCapacity as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 17, (model.foodFeature as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 18, (model.city as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 19, (model.town as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 20, (model.picURL as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 21, (model.latitude as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 22, (model.longitude as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 23, (model.blogUrl as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 24, model.isFavorite == true ? 1 : 0)
    }
    
    static func createFromStatement(statement: OpaquePointer?) -> LocalFoodDB {
        let id = sqlite3_column_int(statement, 0)
        let name = checkValueIsNull(statement: statement, index: 1)
        let address = checkValueIsNull(statement: statement, index: 2)
        let tel = checkValueIsNull(statement: statement, index: 3)
        let hostWords = checkValueIsNull(statement: statement, index: 4)
        let price = checkValueIsNull(statement: statement, index: 5)
        let openHours = checkValueIsNull(statement: statement, index: 6)
        let creditCard = sqlite3_column_int(statement, 7) != 0
        let travelCard = sqlite3_column_int(statement, 8) != 0
        let trafficGuidelines = checkValueIsNull(statement: statement, index: 9)
        let parkingLot = checkValueIsNull(statement: statement, index: 10)
        let url = checkValueIsNull(statement: statement, index: 11)
        let email = checkValueIsNull(statement: statement, index: 12)
        let petNotice = checkValueIsNull(statement: statement, index: 13)
        let reminder = checkValueIsNull(statement: statement, index: 14)
        let foodMonths = checkValueIsNull(statement: statement, index: 15)
        let foodCapacity = checkValueIsNull(statement: statement, index: 16)
        let foodFeature = checkValueIsNull(statement: statement, index: 17)
        let city = checkValueIsNull(statement: statement, index: 18)
        let town = checkValueIsNull(statement: statement, index: 19)
        let picURL = checkValueIsNull(statement: statement, index: 20)
        let latitude = checkValueIsNull(statement: statement, index: 21)
        let longitude = checkValueIsNull(statement: statement, index: 22)
        let blogUrl = checkValueIsNull(statement: statement, index: 23)
        let isFavorite = sqlite3_column_int(statement, 24) != 0
        
        let food = LocalFoodDB(
            id: Int(id),
            name: name,
            address: address,
            tel: tel,
            hostWords: hostWords,
            price: price,
            openHours: openHours,
            creditCard: creditCard,
            travelCard: travelCard,
            trafficGuidelines: trafficGuidelines,
            parkingLot: parkingLot,
            url: url,
            email: email,
            petNotice: petNotice,
            reminder: reminder,
            foodMonths: foodMonths,
            foodCapacity: foodCapacity,
            foodFeature: foodFeature,
            city: city,
            town: town,
            picURL: picURL,
            latitude: latitude,
            longitude: longitude,
            blogUrl: blogUrl,
            isFavorite: isFavorite
        )
        
        return food
    }
    
    static func createFromStatement(values: [String], statement: OpaquePointer?) -> LocalFoodDB {
        var food = LocalFoodDB(
            id: nil, name: "", address: "", tel: "", hostWords: "", price: "",
            openHours: "", creditCard: false, travelCard: false, trafficGuidelines: "",
            parkingLot: "", url: "", email: "", petNotice: "", reminder: "",
            foodMonths: "", foodCapacity: "", foodFeature: "", city: "", town: "",
            picURL: "", latitude: "", longitude: "", blogUrl: "", isFavorite: false
        )
        
        let fieldMap: [String: (OpaquePointer?, Int32) -> Void] = [
            "ID": { food.id = Int(sqlite3_column_int($0, $1)) },
            "Name": { food.name = checkValueIsNull(statement: $0, index: $1) },
            "Address": { food.address = checkValueIsNull(statement: $0, index: $1) },
            "Tel": { food.tel = checkValueIsNull(statement: $0, index: $1) },
            "HostWords": { food.hostWords = checkValueIsNull(statement: $0, index: $1) },
            "Price": { food.price = checkValueIsNull(statement: $0, index: $1) },
            "OpenHours": { food.openHours = checkValueIsNull(statement: $0, index: $1) },
            "CreditCard": { food.creditCard = sqlite3_column_int($0, $1) != 0 },
            "TravelCard": { food.travelCard = sqlite3_column_int($0, $1) != 0 },
            "TrafficGuidelines": { food.trafficGuidelines = checkValueIsNull(statement: $0, index: $1) },
            "ParkingLot": { food.parkingLot = checkValueIsNull(statement: $0, index: $1) },
            "URL": { food.url = checkValueIsNull(statement: $0, index: $1) },
            "Email": { food.email = checkValueIsNull(statement: $0, index: $1) },
            "PetNotice": { food.petNotice = checkValueIsNull(statement: $0, index: $1) },
            "Reminder": { food.reminder = checkValueIsNull(statement: $0, index: $1) },
            "FoodMonths": { food.foodMonths = checkValueIsNull(statement: $0, index: $1) },
            "FoodCapacity": { food.foodCapacity = checkValueIsNull(statement: $0, index: $1) },
            "FoodFeature": { food.foodFeature = checkValueIsNull(statement: $0, index: $1) },
            "City": { food.city = checkValueIsNull(statement: $0, index: $1) },
            "Town": { food.town = checkValueIsNull(statement: $0, index: $1) },
            "PicURL": { food.picURL = checkValueIsNull(statement: $0, index: $1) },
            "Latitude": { food.latitude = checkValueIsNull(statement: $0, index: $1) },
            "Longitude": { food.longitude = checkValueIsNull(statement: $0, index: $1) },
            "BlogUrl": { food.blogUrl = checkValueIsNull(statement: $0, index: $1) },
            "IsFavorite": { food.isFavorite = sqlite3_column_int($0, $1) != 0 }
        ]
        
        for (index, field) in values.enumerated() {
            if let setter = fieldMap[field] {
                setter(statement, Int32(index))
            }
        }
        
        return food
    }
    
}
