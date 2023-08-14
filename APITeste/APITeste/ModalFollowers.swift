//
//  ModalFollowers.swift
//  APITeste
//
//  Created by Luca Lacerda on 08/08/23.
//

import SwiftUI

struct ModalFollowers: View {
    var followers:[GitHubUser]?
    @Binding var isOpen:Bool
    
    var body: some View {
        NavigationStack{
            VStack{
                Button{
                    isOpen.toggle()
                }label: {
                    Text("Fechar Modal")
                }
                .padding(50)
                ScrollView{
                    VStack{
                        if let seguidores = followers{
                            ForEach(0..<seguidores.count, id:\.self){ i in
                                NavigationLink{
                                    ContentView(userName: seguidores[i].login)
                                }label: {
                                    VStack{
                                        AsyncImage(url: URL(string: seguidores[i].avatarUrl ?? "")) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit
                                                )
                                        } placeholder: {
                                            Circle()
                                                .foregroundColor(.secondary)
                                        }
                                        .frame(width: 120,height: 120)
                                        
                                        Text(seguidores[i].login)
                                        Text(seguidores[i].bio ?? "placeholder")
                                    }
                                }
                            }
                        }
                    }.frame(width: UIScreen.main.bounds.width)
                }.scrollIndicators(.hidden)
            }
        }
    }
}

struct ModalFollowers_Previews: PreviewProvider {
    static var previews: some View {
        ModalFollowers(followers: [], isOpen: .constant(true))
    }
}
