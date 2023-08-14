//
//  Model.swift
//  APITeste
//
//  Created by Luca Lacerda on 07/08/23.
//

import Foundation

struct GitHubUser: Codable{
    let login: String
    let avatarUrl: String?
    let bio: String?
}

struct Repos: Codable{
    let name:String
    let description:String?
    let stargazersCount:Int?
}

struct Author: Codable{
    let name:String
    let email:String
}

struct Commit: Codable{
    let message:String?
    let author:Author
}
