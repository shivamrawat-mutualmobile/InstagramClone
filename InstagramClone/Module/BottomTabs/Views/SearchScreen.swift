//
//  Searchscreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 10/09/23.
//

import SwiftUI

struct SearchScreen: View {
    @State var search = ""

    @StateObject var searchStore = SearchStore()

    func renderUser(email: String, userName: String) -> some View {
        NavigationLink(destination: MessageDetailScreen(email: email, username: userName)){
            UserTab(title: email, caption: userName)
                .padding()
        }
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 14)
                    .padding(.trailing, 4)
                TextField("Search" ,text: $search)
                    .foregroundColor(.gray)
                    .padding(.vertical)
                    .onChange(of: search) {
                        searchStore.dispatch(.filter(search))
                    }
            }
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("lightgray"))
            }
            .padding()
            if searchStore.state.searchStatus == .success {
                ForEach(searchStore.state.filteredNames, id: \.self.0) { names in
                    renderUser(email: names.0, userName: names.1)
                }
            }
            Spacer()
        }
        .onAppear {
            searchStore.dispatch(.fetchAll)
        }

    }
}

#Preview {
    SearchScreen()
}