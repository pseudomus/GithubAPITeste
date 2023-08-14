//
//  RepDescription.swift
//  APITeste
//
//  Created by Luca Lacerda on 08/08/23.
//

import SwiftUI

struct RepDescription: View {
    var user:GitHubUser
    var repo:Repos
    @State var commits:[Commit]?
    
    var body: some View {
        VStack{
            Text(repo.name)
            
            if let star = repo.stargazersCount{
                Text("Estrelas:\(star)")
            }
            
            if let descricao = repo.description{
                Text(descricao)
            }
            
            if let com = commits{
                Text(String(com.count))
                
//                ForEach(0...com.count, id: \.self) { i in
//                    Text(com[i].author.name)
//                }
            }
            
        }.task {
            do{
               commits = try await getCommits()
            }catch GHError.invalidURl{
                print("invlaidURL")
            }catch GHError.invalidREsponse{
                print("invalid response")
            }catch GHError.invalidData{
                print("invalid data")
            } catch{
                print("unexpected error")
            }
        }
    }
    
    func getCommits() async throws -> [Commit]{
        
        let endpoint = "https://api.github.com/repos/\(user.login)/\(repo.name)/commits"
        guard let url = URL(string: endpoint) else { throw GHError.invalidURl}
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw GHError.invalidREsponse
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([Commit].self, from: data)
        }catch{
            throw GHError.invalidREsponse
        }
        
    }
}

struct RepDescription_Previews: PreviewProvider {
    static var previews: some View {
        RepDescription(user: GitHubUser(login: "123", avatarUrl: nil, bio: nil) ,repo: Repos(name: "", description: "", stargazersCount: 2))
    }
}
