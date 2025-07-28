//
//  EnregistrementSommeil+CoreDataProperties.swift
//  Arista
//
//  Created by Perez William on 25/07/2025.
//
//

import Foundation
import CoreData


extension EnregistrementSommeil {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EnregistrementSommeil> {
        return NSFetchRequest<EnregistrementSommeil>(entityName: "EnregistrementSommeil")
    }

    @NSManaged public var date: Date?
    @NSManaged public var heureDebut: Date?
    @NSManaged public var heureFin: Date?
    @NSManaged public var utilisateur_sommeil: Utilisateur?

}

extension EnregistrementSommeil : Identifiable {

}
