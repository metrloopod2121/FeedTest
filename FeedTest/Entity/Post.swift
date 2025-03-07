//
//  Post.swift
//  FeedTest
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 04.03.2025.
//

import Foundation

struct Post: Decodable {
    let id: UUID
    let title: String
    let body: String
    let createDate: Date
    let avatarURL: String
    var liked: Bool
    
    init(id: UUID = UUID(), title: String, body: String, createDate: Date = Date(), avatarURL: String, liked: Bool = false) {
        self.id = id
        self.title = title
        self.body = body
        self.createDate = createDate
        self.avatarURL = avatarURL
        self.liked = liked
    }
}
