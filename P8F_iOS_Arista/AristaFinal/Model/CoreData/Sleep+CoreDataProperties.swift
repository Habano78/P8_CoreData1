//
//  Sleep+CoreDataProperties.swift
//  AristaFinal
//
//  Created by Perez William on 14/08/2025.
//
//

import Foundation
import CoreData


extension Sleep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sleep> {
        return NSFetchRequest<Sleep>(entityName: "Sleep")
    }

    @NSManaged public var duration: Int64
    @NSManaged public var quality: Int64
    @NSManaged public var startDate: Date?
    @NSManaged public var user: User?

}

extension Sleep : Identifiable {

}
