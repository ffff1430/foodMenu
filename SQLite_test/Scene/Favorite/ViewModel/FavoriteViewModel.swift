//
//  FavoriteViewModel.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/10/1.
//

import Foundation

class FavoriteViewModel {
    
    @Published var foodItems: [LocalFoodDB] = []
    
    @Published var filterItems: [LocalFoodDB] = []
    
    var completionResultHandler: ((DBResult) -> Void)?
    
    var uniqueCities: [String] {
        // 使用 Set 來獲取不重複的城市
        let citiesSet = Set(foodItems.map { $0.city })
        // 將 Set 轉換為 Array，並排序
        return citiesSet.sorted()
    }
    
    public func fetchFavoriteFood(filter: [LocalFoodDB]) {
        foodItems = FoodDB.shared.fetchSpecificField(value: "ID, Name, PicURL, City", fieldName: "IsFavorite", fieldValue: "1", completion: { result in
            self.completionResultHandler?(result)
        })
        filterItems = foodItems.filter { food in
            // 使用 contains(where:) 来检查 filter 数组中是否有相同的 id
            return filter.contains(where: { $0.id == food.id })
        }
    }
    
    public func cityList(city: String, foodItems: [LocalFoodDB], completion: @escaping ([LocalFoodDB], Bool) -> Void) {
        var result: [LocalFoodDB] = []
        if city == "全部" || city == "" {
            completion(foodItems, false)
            return
        }
        for item in foodItems {
            if item.city == city {
                result.append(item)
            }
        }
        completion(result, true)
    }
    
    public func getCurrentIDItem(id: Int) -> LocalFoodDB {
        return FoodDB.shared.fetchSpecificField(value: "*", fieldName: "ID", fieldValue: "\(id)") { result in
            self.completionResultHandler?(result)
        }[0]
    }
    
}
