//
//  ModelToDoList+CoreDataProperties.swift
//  ToDoListApp
//
//  Created by Robert Loo
//
//

import Foundation
import CoreData


extension ModelToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ModelToDoList> {
        return NSFetchRequest<ModelToDoList>(entityName: "ModelToDoList")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isSelected: Bool
    @NSManaged public var title: String?

}

extension ModelToDoList : Identifiable {

}
