//
//  LikeManager.swift
//  FinalProject
//
//  Created by Sofo Machurishvili on 27.01.24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class LikeManager {
    static let shared = LikeManager()
    
    private init() {}
    
    func checkIfLikes(postId: String) async throws -> Bool {
        let count = try await Firestore.firestore().collection("likes")
            .whereField("post_id", isEqualTo: postId)
            .whereField("user_id", isEqualTo: AuthManager.shared.getAuthenticagedUser()?.uid ?? "")
            .count.getAggregation(source: .server).count
        
        return Int(truncating: count) > 0
    }
    
    func createLike(postId: String) async throws {
        let id = UUID().uuidString
        let likeData: [String:Any] = [
            "user_id" : AuthManager.shared.getAuthenticagedUser()?.uid ?? "",
            "post_id" : postId
        ]
        
        try await Firestore.firestore().collection("likes").document(id).setData(likeData, merge: false)
    }
    
    func deleteLike(postId: String) async throws {
        
        let snapshot = try await Firestore.firestore().collection("likes")
            .whereField("post_id", isEqualTo: postId)
            .whereField("user_id", isEqualTo: AuthManager.shared.getAuthenticagedUser()?.uid ?? "")
            .getDocuments()
        
        var ids: [String] = []
        snapshot.documents.forEach { document in
            ids.append(document.documentID)
        }
        if ids.count > 0 {
            try await Firestore.firestore().collection("likes").document(ids[0]).delete()
        }
    }
    
    func countLikes(postId: String) async throws -> Int {
        let count = try await Firestore.firestore()
            .collection("likes")
            .whereField("post_id", isEqualTo: postId)
            .count.getAggregation(source: .server).count
        return Int(truncating: count)
    }
}

