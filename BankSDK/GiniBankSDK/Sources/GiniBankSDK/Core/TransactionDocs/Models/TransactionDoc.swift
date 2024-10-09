//
//  TransactionDoc.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//

import Foundation

struct TransactionDoc {
    let documentId: String
    let fileName: String
    let type: TransactionDocType
}

extension TransactionDoc {
    static func createMockDocuments() -> [TransactionDoc] {
        let doc1 = TransactionDoc(documentId: "doc1", fileName: "filename1", type: .document)
        let doc2 = TransactionDoc(documentId: "doc2", fileName: "filename2", type: .document)
        return [doc1, doc2]
    }
}
