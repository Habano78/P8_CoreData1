//
//  Exercise+CoreDataProperties.swift
//  Arista
//
//  Created by Perez William on 29/07/2025.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercice")
    }

    @NSManaged public var startDate: Date?
    @NSManaged public var duration: Int64
    @NSManaged public var intensity: Int64
    @NSManaged public var category: String?
    @NSManaged public var user: User?

}

extension Exercise : Identifiable {

}
