//
//  SleepRepositoryProtocol.swift
//  Arista
//
//  Created by Perez William on 12/08/2025.
//

import Foundation

protocol SleepRepositoryProtocol {
    /// Récupère toutes les sessions de sommeil, triées par date.
    func getSleepSessions() async throws -> [Sleep]
}
