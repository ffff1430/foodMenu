//
//  NoteViewModel.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/11/5.
//

import Foundation

class NoteViewModel {
    
    @Published var noteItems: [NoteInfo] = []
    
    var completionResultHandler: ((DBResult) -> Void)?
    
    func createNoteTable() {
        NoteDB.shared.createNoteDB { result in
            self.completionResultHandler?(result)
        }
        noteItems = NoteDB.shared.fetchNote { result in
            self.completionResultHandler?(result)
        }.reversed()
    }
    
    func deleteNote(model: NoteInfo) {
        NoteDB.shared.deleteNote(model: model) { result in
            self.completionResultHandler?(result)
        }
        noteItems = NoteDB.shared.fetchNote { result in
            self.completionResultHandler?(result)
        }
    }
    
    func getFoodDBInfo(id: Int, completion: @escaping (LocalFoodDB?) -> Void) {
        let food = FoodDB.shared.fetchSpecificField(value: "Name, Address, PicURL", fieldName: "ID", fieldValue: "\(id)") { result in
            self.completionResultHandler?(result)
        }
        completion(food.isEmpty ? nil : food[0])
    }
    
}
