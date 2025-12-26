//
//  MenuViewModel.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/9/27.
//

import Foundation

enum Action {
    case none
    case search
    case pick
}

enum MethodType {
    case main
    case addFood
}

class MenuViewModel {
    
    private var netWork: NetWork?
    
    @Published var foodItems: [LocalFoodDB] = []
    
    @Published var filterItems: [LocalFoodDB] = []
    
    @Published var isShowLoading: Bool = false
    
    private var currentCityList: [LocalFoodDB] = []
    
    var completionResultHandler: ((DBResult) -> Void)?
    
    var uniqueCities: [String] {
        // 使用 Set 來獲取不重複的城市
        let citiesSet = Set(foodItems.map { $0.city })
        // 將 Set 轉換為 Array，並排序
        return citiesSet.sorted()
    }
    
    public func getLocalFoodInfo(url: String, completion: @escaping (Error) -> Void) {
        netWork = NetWork()
        isShowLoading = true
        if !FoodDB.shared.isFoodTableCreated() {
            if let url = URL(string: url) {
                netWork?.fetchData(from: url) { (result: Result<[LocalFoodInfo], Error>) in
                    self.isShowLoading = false
                    switch result {
                    case .success(let foodInfo):
                        FoodDB.shared.createFoodDB { result in
                            self.completionResultHandler?(result)
                        }
                        FoodDB.shared.insertFood(foods: foodInfo) { result in
                            self.completionResultHandler?(result)
                        }
                        self.foodItems = FoodDB.shared.fetchFood { result in
                            self.completionResultHandler?(result)
                        }
                    case .failure(let error):
                        completion(error)
                    }
                }
            }
        } else {
            isShowLoading = false
            self.foodItems = FoodDB.shared.fetchFood { result in
                self.completionResultHandler?(result)
            }
        }
    }
    
    public func checkHeartStatus(index: Int, filterList: [LocalFoodDB], foodList: [LocalFoodDB], isSearching: Bool, isPicking: Bool, completion: @escaping (Bool) -> Void) {
        if isSearching || isPicking {
            if filterList[index].isFavorite {
                completion(true)
            } else {
                completion(false)
            }
        } else {
            if foodList[index].isFavorite {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    public func fetchFoodDB(filter: [LocalFoodDB]) {
        if !FoodDB.shared.isFoodTableCreated() {
            return
        }
        foodItems = FoodDB.shared.fetchFood { result in
            self.completionResultHandler?(result)
        }
        filterItems = foodItems.filter { food in
            // 使用 contains(where:) 来检查 filter 数组中是否有相同的 id
            return filter.contains(where: { $0.id == food.id })
        }
    }
    
    public func updateFilterItems(action: Action, foodItems: [LocalFoodDB], searchText: String, city: String) {
        isShowLoading = true
        filterItems = FoodDB.shared.fetchFilterField(value: "*", city: city, searchText: searchText) { result in
            self.isShowLoading = false
            self.completionResultHandler?(result)
        }
    }
    
    
    //從Detail頁面回來後更新愛心狀態
    public func updateSpecificItem(item: LocalFoodDB, isSearching: Bool, isPicking: Bool) {
        if isSearching || isPicking {
            for index in 0 ..< filterItems.count {
                if filterItems[index].id == item.id {
                    filterItems[index].isFavorite = item.isFavorite
                }
            }
        } else {
            for index in 0 ..< foodItems.count {
                if foodItems[index].id == item.id {
                    foodItems[index].isFavorite = item.isFavorite
                }
            }
        }
    }
    
    public func updateIsFavoriteInfo(isFavorite: Bool, item: LocalFoodDB, completion: @escaping () -> Void) {
        var updateItem = item
        updateItem.isFavorite = isFavorite
        FoodDB.shared.updateIsFavorite(model: updateItem) { result in
            self.completionResultHandler?(result)
            completion()
        }
    }
    
}
