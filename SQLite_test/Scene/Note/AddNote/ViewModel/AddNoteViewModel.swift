//
//  AddNoteViewModel.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/11/6.
//

import Foundation

enum AddNoteType {
    case insert
    case edit
}

class AddNoteViewModel {
    
    var completionResultHandler: ((DBResult) -> Void)?
    
    func insertNoteToDB(note: NoteInfo, completion: @escaping () -> Void) {
        NoteDB.shared.insertNote(notes: [note]) { result in
            self.completionResultHandler?(result)
            completion()
        }
    }
    
    func updateNoteDB(model: NoteInfo,  completion: @escaping () -> Void) {
        NoteDB.shared.updateNote(model: model) { result in
            self.completionResultHandler?(result)
            completion()
        }
    }
    
    func getFoodDBInfo(id: Int, completion: @escaping (LocalFoodDB?) -> Void) {
        let food = FoodDB.shared.fetchSpecificField(value: "Name", fieldName: "ID", fieldValue: "\(id)") { result in
            self.completionResultHandler?(result)
        }
        completion(food.isEmpty ? nil : food[0])
    }
    
}
