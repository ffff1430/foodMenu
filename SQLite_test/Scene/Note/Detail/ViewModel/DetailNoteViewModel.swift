//
//  DetailNoteViewModel.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/11/8.
//

import Foundation

class DetailNoteViewModel {
    
    var completionResultHandler: ((DBResult) -> Void)?
    
    func deleteNote(model: NoteInfo, completion: @escaping () -> Void) {
        NoteDB.shared.deleteNote(model: model) { result in
            self.completionResultHandler?(result)
            completion()
        }
    }
    
    func getFoodDBInfo(id: Int, completion: @escaping (LocalFoodDB?) -> Void) {
        let food = FoodDB.shared.fetchSpecificField(value: "Name, Address, PicURL", fieldName: "ID", fieldValue: "\(id)") { result in
            self.completionResultHandler?(result)
        }
        completion(food.isEmpty ? nil : food[0])
    }
    
}
