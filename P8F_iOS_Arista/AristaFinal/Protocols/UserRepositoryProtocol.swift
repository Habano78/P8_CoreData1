//
//  UserRepositoryProtocol.swift
//  Arista
//
//  Created by Perez William on 12/08/2025.
//

import Foundation

protocol UserRepositoryProtocol {
    /// Récupère l'unique utilisateur de la base de données.
    func getUser() async throws -> User?
}
