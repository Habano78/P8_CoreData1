//
//  Utilisateur+CoreDataProperties.swift
//  Arista
//
//  Created by Perez William on 25/07/2025.
//
//

import Foundation
import CoreData


extension Utilisateur {
        
        @nonobjc public class func fetchRequest() -> NSFetchRequest<Utilisateur> {
                return NSFetchRequest<Utilisateur>(entityName: "Utilisateur")
        }
        
        @NSManaged public var dateDeNaissance: Date?
        @NSManaged public var email: String?
        @NSManaged public var nom: String?
        @NSManaged public var prenom: String?
        @NSManaged public var poids: Double
        @NSManaged public var taille: Int64
        @NSManaged public var enregistrementsSommeil: NSSet?
        @NSManaged public var seancesExcercice: NSSet?
        
}

// MARK: Generated accessors for enregistrementsSommeil
extension Utilisateur {
        
        @objc(addEnregistrementsSommeilObject:)
        @NSManaged public func addToEnregistrementsSommeil(_ value: EnregistrementSommeil)
        
        @objc(removeEnregistrementsSommeilObject:)
        @NSManaged public func removeFromEnregistrementsSommeil(_ value: EnregistrementSommeil)
        
        @objc(addEnregistrementsSommeil:)
        @NSManaged public func addToEnregistrementsSommeil(_ values: NSSet)
        
        @objc(removeEnregistrementsSommeil:)
        @NSManaged public func removeFromEnregistrementsSommeil(_ values: NSSet)
        
}

// MARK: Generated accessors for seancesExcercice
extension Utilisateur {
        
        @objc(addSeancesExcerciceObject:)
        @NSManaged public func addToSeancesExcercice(_ value: SeancesExercice)
        
        @objc(removeSeancesExcerciceObject:)
        @NSManaged public func removeFromSeancesExcercice(_ value: SeancesExercice)
        
        @objc(addSeancesExcercice:)
        @NSManaged public func addToSeancesExcercice(_ values: NSSet)
        
        @objc(removeSeancesExcercice:)
        @NSManaged public func removeFromSeancesExcercice(_ values: NSSet)
        
}

extension Utilisateur : Identifiable {
        
}
