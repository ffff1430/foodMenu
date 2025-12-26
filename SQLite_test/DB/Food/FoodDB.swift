//
//  FoodDB.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/9/23.
//

import Foundation
import SQLite3

public class FoodDB {
    
    static let shared = FoodDB()
    
    private var db: OpaquePointer?
    
    private func getDatabasePath() -> String {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("foodDB.sqlite").path
    }
    
    private var foodDatabase: GenericDB<LocalFoodDB> = GenericDB<LocalFoodDB>.shared()
    
    public func createFoodDB(completion: @escaping (DBResult) -> Void) {
        foodDatabase.createDB { result in
            completion(result)
        }
    }
    
    public func insertFood(foods: [LocalFoodInfo], completion: @escaping (DBResult) -> Void) {
        let foodDBModels = foods.map { $0.toLocalFoodDB() }
        foodDatabase.insert(models: foodDBModels) { result in
            completion(result)
        }
    }
    
    public func fetchFood(completion: @escaping (DBResult) -> Void) -> [LocalFoodDB] {
        return foodDatabase.fetchAll { result in
            completion(result)
        }
    }
    
    public func isFoodTableCreated() -> Bool {
        return foodDatabase.isTableCreated()
    }
    
    public func updateIsFavorite(model: LocalFoodDB, completion: @escaping (DBResult) -> Void) {
        foodDatabase.update(model: model, completion: { result in
            completion(result)
        })
    }
    
    public func fetchSpecificField(value: String, fieldName: String, fieldValue: String, completion: @escaping (DBResult) -> Void) -> [LocalFoodDB] {
        return foodDatabase.fetchSpecificField(selectValue: value, fieldName: fieldName, fieldValue: fieldValue) { result in
            completion(result)
        }
    }
    
    public func fetchFilterField(value: String, city: String, searchText: String, completion: @escaping (DBResult) -> Void) -> [LocalFoodDB] {
        return foodDatabase.fetchFilterField(selectValue: value, city: city, searchText: searchText) { result in
            completion(result)
        }
    }
    
    private init() { }
    
}
