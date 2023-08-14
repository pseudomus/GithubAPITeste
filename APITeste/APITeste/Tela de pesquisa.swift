//
//  Tela de pesquisa.swift
//  APITeste
//
//  Created by Luca Lacerda on 07/08/23.
//

import SwiftUI

struct Tela_de_pesquisa: View {
    @State private var user:String = ""
    var body: some View {
        NavigationStack{
            VStack{
                TextField("texto", text: $user)
                    .padding(50)
                NavigationLink{
                    ContentView(userName: user)
                }label: {
                    Text("Pesquisar")
                }
            }
        }
    }
}

struct Tela_de_pesquisa_Previews: PreviewProvider {
    static var previews: some View {
        Tela_de_pesquisa()
    }
}
