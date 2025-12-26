//
//  LocalFoodInfo.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/9/27.
//

import Foundation

public struct LocalFoodInfo: Codable {
    var id: Int?
    var name: String
    var address: String
    var tel: String
    var hostWords: String
    var price: String
    var openHours: String
    var creditCard: String
    var travelCard: String
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
    
    // 定義 CodingKeys 以映射 JSON 鍵名
    enum CodingKeys: String, CodingKey {
        case id
        case name = "Name"
        case address = "Address"
        case tel = "Tel"
        case hostWords = "HostWords"
        case price = "Price"
        case openHours = "OpenHours"
        case creditCard = "CreditCard"
        case travelCard = "TravelCard"
        case trafficGuidelines = "TrafficGuidelines"
        case parkingLot = "ParkingLot"
        case url = "Url"
        case email = "Email"
        case petNotice = "PetNotice"
        case reminder = "Reminder"
        case foodMonths = "FoodMonths"
        case foodCapacity = "FoodCapacity"
        case foodFeature = "FoodFeature"
        case city = "City"
        case town = "Town"
        case picURL = "PicURL"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case blogUrl = "BlogUrl"
    }
}

extension LocalFoodInfo {
    func toLocalFoodDB() -> LocalFoodDB {
        return LocalFoodDB(
            id: 0, // 根據需要分配 ID，通常是在插入後由數據庫生成
            name: self.name,
            address: self.address,
            tel: self.tel,
            hostWords: self.hostWords,
            price: self.price,
            openHours: self.openHours,
            creditCard: self.creditCard == "True",
            travelCard: self.travelCard == "True",
            trafficGuidelines: self.trafficGuidelines,
            parkingLot: self.parkingLot,
            url: self.url,
            email: self.email,
            petNotice: self.petNotice,
            reminder: self.reminder,
            foodMonths: self.foodMonths,
            foodCapacity: self.foodCapacity,
            foodFeature: self.foodFeature,
            city: self.city,
            town: self.town,
            picURL: self.picURL,
            latitude: self.latitude,
            longitude: self.longitude,
            blogUrl: self.blogUrl,
            isFavorite: false // 默認為不喜歡，可以根據需要調整
        )
    }
}
