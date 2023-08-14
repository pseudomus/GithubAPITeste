//
//  ContentView.swift
//  APITeste
//
//  Created by Luca Lacerda on 04/08/23.
//

import SwiftUI

struct ContentView: View {
    @State private var user: GitHubUser?
    @State private var followers:[GitHubUser]?
    @State private var repos:[Repos]?
    @State private var isOpen:Bool = false
    var userName: String
    var body: some View {
        NavigationStack{
            VStack {
                AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit
                        )
                } placeholder: {
                    Circle()
                        .foregroundColor(.secondary)
                }
                .frame(width: 120,height: 120)
                
                Text(user?.login ?? "placeholder")
                Text(user?.bio ?? "placeholder")
                
                Button{
                    isOpen.toggle()
                }label: {
                    Text("Followers")
                }
                .padding(50)
                
                if let rep = repos{
                    List {
                        ForEach(0..<rep.count, id: \.self) { i in
                            NavigationLink{
                                if let us = user{
                                    RepDescription(user: us,repo: rep[i])
                                }
                            }label: {
                                Text(rep[i].name)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isOpen){
                ModalFollowers(followers: followers, isOpen: $isOpen)
            }
            .padding()
            .task {
                do{
                    user = try await getUser()
                    followers = try await getFollowers()
                    repos = try await getRepos()
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
    }
    
    func getUser() async throws -> GitHubUser{
        let endpoint = "https://api.github.com/users/\(userName)"
        guard let url = URL(string: endpoint) else { throw GHError.invalidURl }
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw GHError.invalidREsponse
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    func getFollowers() async throws -> [GitHubUser]{
        let endpoint = "https://api.github.com/users/\(userName)/followers"
        guard let url = URL(string: endpoint) else { throw GHError.invalidURl }
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw GHError.invalidREsponse
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([GitHubUser].self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    func getRepos() async throws -> [Repos]{
        
        let endpoint = "https://api.github.com/users/\(userName)/repos"
        guard let url = URL(string: endpoint) else { throw GHError.invalidURl}
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw GHError.invalidREsponse
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([Repos].self, from: data)
        }catch{
            throw GHError.invalidREsponse
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userName: "TheNopera")
    }
}

enum GHError: Error {
    case invalidURl
    case invalidREsponse
    case invalidData
}
