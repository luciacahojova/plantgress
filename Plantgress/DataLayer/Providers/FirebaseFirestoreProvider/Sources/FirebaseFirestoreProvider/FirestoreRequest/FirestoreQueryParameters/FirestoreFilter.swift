//
//  FirestoreFilter.swift
//  FirebaseFirestoreProvider
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import Foundation

public struct FirestoreFilter {
    let field: String
    let `operator`: FirestoreOperator
    let value: Any
    
    public init(
        field: String,
        operator: FirestoreOperator,
        value: Any
    ) {
        self.field = field
        self.`operator` = `operator`
        self.value = value
    }
}
