//
//  FirestoreOrder.swift
//  FirebaseFirestoreProvider
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import Foundation

public struct FirestoreOrder {
    let field: String
    let descending: Bool
    
    public init(
        field: String,
        descending: Bool
    ) {
        self.field = field
        self.descending = descending
    }
}
