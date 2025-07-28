//
//  SeanceExercice+CoreDataProperties.swift
//  Arista
//
//  Created by Perez William on 25/07/2025.
//
//

import Foundation
import CoreData


extension SeancesExercice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SeancesExercice> {
        return NSFetchRequest<SeancesExercice>(entityName: "SeancesExercice")
    }

    @NSManaged public var date: Date?
    @NSManaged public var dureeEnMinutes: Int64
    @NSManaged public var intensite: String?
    @NSManaged public var typeExercice: String?
    @NSManaged public var utilisateur_exercice: Utilisateur?

}

extension SeancesExercice : Identifiable {

}
