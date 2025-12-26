//
//  NoteDB.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/11/5.
//

import Foundation
import SQLite3

public class NoteDB {
    
    static let shared = NoteDB()
    
    private var db: OpaquePointer?
    
    private func getDatabasePath() -> String {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("noteDB.sqlite").path
    }
    
    private var noteDatabase: GenericDB<NoteInfo> = GenericDB<NoteInfo>.shared()
    
    public func createNoteDB(completion: @escaping (DBResult) -> Void) {
        noteDatabase.createDB { result in
            completion(result)
        }
    }
    
    public func insertNote(notes: [NoteInfo], completion: @escaping (DBResult) -> Void) {
        noteDatabase.insert(models: notes) { result in
            completion(result)
        }
    }
    
    public func fetchNote(completion: @escaping (DBResult) -> Void) -> [NoteInfo] {
        return noteDatabase.fetchAll { result in
            completion(result)
        }
    }
    
    public func updateNote(model: NoteInfo, completion: @escaping (DBResult) -> Void) {
        noteDatabase.update(model: model) { result in
            completion(result)
        }
    }
    
    public func isNoteTableCreated() -> Bool {
        return noteDatabase.isTableCreated()
    }
    
    public func deleteNote(model: NoteInfo, completion: @escaping (DBResult) -> Void) {
        noteDatabase.delete(model: model) { result in
            completion(result)
        }
    }
    
    private init() { }
}
