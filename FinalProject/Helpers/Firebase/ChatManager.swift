//
//  ChatManager.swift
//  FinalProject
//
//  Created by Sofo Machurishvili on 28.01.24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class ChatManager {
    static let shared = ChatManager()
    
    private init() { }
    
    func createChat(participantId: String) async throws {
        let id = UUID().uuidString
        let chatData: [String:Any] = [
            "participants" : [participantId, AuthManager.shared.getAuthenticagedUser()?.uid ?? ""]
        ]
        
        try await Firestore.firestore().collection("chats").document(id).setData(chatData, merge: false)
    }
    
    func getChatById(chatId: String) async throws -> ChatModel? {
        let document = try await Firestore.firestore().collection("chats").document(chatId).getDocument()
        
        if document.exists {
            let dictionary = document.data()
            
            let chat = ChatModel(participants: dictionary?["participants"] as! [String])
            
            return chat
        }
        return nil
    }
    
    
    
    func getChatByParticipants(participantId: String) async throws -> ChatModel? {
        let snapshot = try await Firestore.firestore()
            .collection("chats")
            .whereField("participants", arrayContains: participantId)
            .whereField("participants", arrayContains: AuthManager.shared.getAuthenticagedUser()?.uid ?? "")
            .getDocuments()
        
        var chats: [ChatModel] = []
        
        snapshot.documents.forEach { document in
            let dictionary = document.data()
         
            let chat = ChatModel(participants: dictionary["participants"] as! [String])
            chats.append(chat)
        }
        
        return chats.count > 0 ? chats[0] : nil
    }
    
    func getChats(participantId: String) async throws -> [ChatModel] {
        let snapshot = try await Firestore.firestore()
            .collection("chats")
            .whereField("participants", arrayContains: AuthManager.shared.getAuthenticagedUser()?.uid ?? "")
            .getDocuments()
        
        var chats: [ChatModel] = []
        
        snapshot.documents.forEach { document in
            let dictionary = document.data()
         
            let chat = ChatModel(participants: dictionary["participants"] as! [String])
            chats.append(chat)
        }
        
        return chats
    }
}