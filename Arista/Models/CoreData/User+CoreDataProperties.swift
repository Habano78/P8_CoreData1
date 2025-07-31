//
//  User+CoreDataProperties.swift
//  Arista
//
//  Created by Perez William on 29/07/2025.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var lastName: String?
    @NSManaged public var firstName: String?
    @NSManaged public var sleeps: NSSet?
    @NSManaged public var exercices: NSSet?

}

// MARK: Generated accessors for sleeps
extension User {

    @objc(addSleepsObject:)
    @NSManaged public func addToSleeps(_ value: Sleep)

    @objc(removeSleepsObject:)
    @NSManaged public func removeFromSleeps(_ value: Sleep)

    @objc(addSleeps:)
    @NSManaged public func addToSleeps(_ values: NSSet)

    @objc(removeSleeps:)
    @NSManaged public func removeFromSleeps(_ values: NSSet)

}

// MARK: Generated accessors for exercices
extension User {

    @objc(addExercicesObject:)
    @NSManaged public func addToExercices(_ value: Exercise)

    @objc(removeExercicesObject:)
    @NSManaged public func removeFromExercices(_ value: Exercise)

    @objc(addExercices:)
    @NSManaged public func addToExercices(_ values: NSSet)

    @objc(removeExercices:)
    @NSManaged public func removeFromExercices(_ values: NSSet)

}

extension User : Identifiable {

}
