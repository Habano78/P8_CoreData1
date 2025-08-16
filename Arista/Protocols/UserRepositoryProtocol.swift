//
//  UserRepositoryProtocol.swift
//  Arista
//
//  Created by Perez William on 12/08/2025.
//

import Foundation

protocol UserRepositoryProtocol {
    func getUser() async throws -> User?
}
