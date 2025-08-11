//
//  Sleep+CoreDataProperties.swift
//  Arista
//
//  Created by Perez William on 11/08/2025.
//
//

import Foundation
import CoreData


extension Sleep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sleep> {
        return NSFetchRequest<Sleep>(entityName: "Sleep")
    }

    @NSManaged public var startDate: Date?
    @NSManaged public var duration: Int64
    @NSManaged public var quality: Int64
    @NSManaged public var user: User?

}

extension Sleep : Identifiable {

}
