//
//  FeedViewModel.swift
//  FinalProject
//
//  Created by Sofo Machurishvili on 18.01.24.
//

import SwiftUI

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var posts: [PostModel] = []
    @Published var searchTerm: String = ""
    
    func fetchPosts() async {
        do {
            posts = try await PostManager.shared.getPosts(searchTerm: searchTerm)
        } catch {
            print(error)
        }
    }
}
