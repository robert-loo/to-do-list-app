//
//  DB Helper.swift
//  ScreenFlowApp
//
//  Created by Robert Loo on 08/04/24.
//

import UIKit
import CoreData
import Foundation

class DBHelperModel {
    
    static let shared = DBHelperModel()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoListData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    private let entityName = "ModelToDoList"
    
    //Insert the search data
    func insertToDoListData(
        isSelected: Bool,
        date: Date?,
        title: String) {
        let context = persistentContainer.viewContext
        
        do {
            if let entity = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: context) as? ModelToDoList {
                // Try to avoid force casting like this,  it may crash the application when a simple warning that something went wrong could be enough.
                entity.isSelected = isSelected
                entity.title = title
                entity.date = date
                try context.save()
            }
        } catch {
            print("--- error : ", error.localizedDescription)
        }
    }
    
    //Get search list from the db
    func getToDoListData(completion: @escaping ([ModelToDoList]?, Error?) -> Void) {
        let context = persistentContainer.viewContext
        var results = [ModelToDoList]()
        do {
            results = try context.fetch(ModelToDoList.fetchRequest())
            completion(results, nil) // Call completion with success and pass the results
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error) // Call completion with error
        }
    }

    //Delete data using the object identifier
    func deleteWithId(id: ObjectIdentifier) {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        do {
            if let data = try context.fetch(request) as? [ModelToDoList], let selectedSearch = data.filter({ $0.id == id }).first {
                context.delete(selectedSearch)
                try context.save()
                print("--- file deleted successfully")
            }
        } catch {}
    }
    
    // Update data
    func updateToDoListData(id: ObjectIdentifier, newTitle: String, newDate: Date?, isSelected: Bool) {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        
        do {
            if let data = try context.fetch(request) as? [ModelToDoList], let selectedSearch = data.filter({ $0.id == id }).first {
                selectedSearch.title = newTitle
                selectedSearch.date = newDate
                selectedSearch.isSelected = isSelected
                try context.save()
                print("--- data updated successfully")
            }
        } catch {
            print("--- error : ", error.localizedDescription)
        }
    }
}
