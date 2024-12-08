//
//  SearchView.swift
//  Discogs
//
//  Created by Belen on 03/12/2024.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for an artist...", text: $searchQuery, onCommit: {
                    viewModel.searchArtists(query: searchQuery)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                if viewModel.artists.isEmpty && searchQuery.isEmpty {
                    Spacer()
                    Text("Search for your favorite artists!")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List(viewModel.artists) { artist in
                        NavigationLink(destination: ArtistDetailView(artistId: artist.id)) {
                            HStack {
                                AsyncImage(url: URL(string: artist.thumb)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                                Text(artist.title)
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Artist Search")
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
}
