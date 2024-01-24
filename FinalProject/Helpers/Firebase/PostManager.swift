//
//  PostManager.swift
//  FinalProject
//
//  Created by Sofo Machurishvili on 21.01.24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class PostManager {
    
    static let shared = PostManager()
    private init() {}
    
    func savePost(post: PostModel, postId: String? = nil) async throws -> PostModel {
        var postData: [String:Any] = [
            "title" : post.title,
            "description" : post.description
        ]
        
        if postId == nil {
            postData["user_id"] = AuthManager.shared.getAuthenticagedUser()?.uid ?? ""
            postData["date_created"] = Timestamp()
        }
        
        if let photoUrl = post.photoUrl {
            postData["photo_url"] = photoUrl
        }
        
        let id = postId ?? post.id
        
        try await Firestore.firestore().collection("posts").document(id).setData(postData, merge: postId != nil)
        
        return PostModel(id: id, title: post.title, description: post.description, photoUrl: post.photoUrl)
    }
    
    func deletePost(postId: String) async throws {
        try await Firestore.firestore().collection("posts").document(postId).delete()
    }
    
    func getPosts() async throws -> [PostModel] {
        let snapshot = try await Firestore.firestore().collection("posts").getDocuments()
        var posts: [PostModel] = []
        snapshot.documents.forEach { document in
            let dictionary = document.data()
            let post = PostModel(
                id: document.documentID,
                title: dictionary["title"] as! String,
                description: dictionary["description"] as! String,
                photoUrl: dictionary["photo_url"] as? String
            )
            posts.append(post)
        }
        return posts
    }
}
