//
//  TodoRepository.swift
//  Reminder
//
//  Created by 여성은 on 7/5/24.
//

import UIKit
import RealmSwift

final class TodoRepository {
    private let realm = try! Realm()
    
    func getFileURL() {
        guard let fileURL = realm.configuration.fileURL else { return }
        print(fileURL)
    }
    
    
    func createItem(_ data: Todo) {
        
//        let folder = realm.objects(Folder.self).where {
//            $0.name == "공부"
//        }
//        do {
//            try realm.write {
//                folder.first?.detail.append(data)
//            }
//        } catch {
//            print("Realm Error")
//        }
        
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Realm Error")
        }
    }
   
    func updateItem(value: [String: Any]) {
        try! realm.write {
            realm.create(Todo.self, value: value, update: .modified)
        }
    }
    func updateItems(table: Results<Todo>!, value: Any?, forKey: String) {
        try! realm.write {
            table.setValue(value, forKey: forKey)
        }
    }
    
    func deleteItem(_ data: Todo) {
        try! realm.write {
            realm.delete(data)
        }
    }
    
    func fetchFolder() -> Results<Folder> {
        let value = realm.objects(Folder.self)
        return value
    }
    
    func fetchFolderDetail(folder: Folder) -> List<Todo>! {
        let id = folder.id
        let value = realm.object(ofType: Folder.self, forPrimaryKey: id)?.detail
        
        return value
    }
    
    func fetchAll() -> Results<Todo> {
        let value = realm.objects(Todo.self)
        return value
    }
    func fetchData(id: ObjectId) -> Todo? {
        guard let value = realm.object(ofType: Todo.self, forPrimaryKey: id) else { return nil }
        return value
    }
   
    func checkVersion() {
        print(try! Realm().configuration.fileURL)
    }
    
}
