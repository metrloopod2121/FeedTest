//
//  StorageManager.swift
//  FeedTest
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 04.03.2025.
//

import Foundation
import CoreData

protocol StorageManagerProtocol {
    func fetchData(completion: @escaping ([Post]) -> Void)
    func loadDataFromJSON(completion: @escaping () -> Void)
}

class StorageManager: StorageManagerProtocol {
    
    private let persistenceController = PersistenceController.shared
    
    
    func fetchData(completion: @escaping ([Post]) -> Void) {
        let context = persistenceController.context
        
        DispatchQueue.global(qos: .background).async {
            let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
            
            do {
                let postsEntities = try context.fetch(request)
                
                let posts = postsEntities.map { postEntity in
                    Post(id: postEntity.id ?? UUID(),
                         title: postEntity.title ?? "",
                         body: postEntity.body ?? "",
                         createDate: postEntity.createDate ?? Date(),
                         avatarURL: postEntity.avatarURL ?? "")
                }
                
                
                DispatchQueue.main.async {
                    completion(posts)
                }
            } catch {
                print("Error fetching data from Core Data: \(error)")
                
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    
    func loadDataFromJSON(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = Bundle.main.url(forResource: "getPosts", withExtension: "json") else {
                print("JSON file not found.")
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let posts: [Post] = try decoder.decode([Post].self, from: data)
                
                self.savePostsToCoreData(posts) {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            } catch {
                print("Error loading or decoding JSON data: \(error)")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    
    func savePostsToCoreData(_ posts: [Post], completion: @escaping () -> Void) {
        let context = persistenceController.context
        
        DispatchQueue.global(qos: .background).async {
            for post in posts {
                let postEntity = PostEntity(context: context)
                postEntity.id = post.id
                postEntity.title = post.title
                postEntity.body = post.body
                postEntity.avatarURL = post.avatarURL
                postEntity.createDate = post.createDate
                
                do {
                    try context.save()
                } catch {
                    print("Error saving post to Core Data: \(error)")
                }
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
