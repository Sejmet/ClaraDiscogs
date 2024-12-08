//
//  ArtistAlbumsView.swift
//  Discogs
//
//  Created by Belen on 03/12/2024.
//

import SwiftUI

struct ArtistAlbumsView: View {
    @StateObject private var viewModel = ArtistAlbumsViewModel()
    let artistId: Int
    
    // Filter Inputs
    @State private var year: String = ""
    @State private var genre: String = ""
    @State private var title: String = ""
    
    var body: some View {
        VStack {
            // Filter Section
            VStack(alignment: .leading) {
                Text("Filters")
                    .font(.headline)
                    .padding(.bottom, 4)
                
                // TODO: request API to get albums by filters. 
                HStack {
                    TextField("Year", text: $year)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .onChange(of: year, { (oldValue, newValue) in
                            viewModel.selectedYear = newValue.isEmpty ? nil : Int(newValue)
                            viewModel.applyFilters()
                        })
       
                    TextField("Type (e.g., Master)", text: $genre)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: genre, { (oldValue, newValue) in
                            viewModel.selectedGenre = newValue.isEmpty ? nil : newValue
                            viewModel.applyFilters()
                        })
                    
                    TextField("Album title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: title, { (oldValue, newValue) in
                            viewModel.selectedTitle = newValue.isEmpty ? nil : newValue
                            viewModel.applyFilters()
                        })
                }
            }
            .padding()
            
            // Album List
            if viewModel.filteredAlbums.isEmpty {
                Spacer()
                Text("No albums found")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.filteredAlbums) { album in
                        HStack {
                            AsyncImage(url: URL(string: album.thumb)) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading) {
                                Text(album.title)
                                    .font(.headline)
                                if let year = album.year {
                                    Text("Year: \(year)")
                                        .font(.subheadline)
                                }
                                Text("Type: \(album.type)")
                                    .font(.footnote)
                                Text("Artist: \(album.artist)")
                                    .font(.footnote)
                            }
                        }
                        .onAppear {
                            if viewModel.filteredAlbums.last == album {
                                viewModel.loadMore(for: artistId)
                            }
                        }
                    }
                    
                    if viewModel.isLoadingMore {
                        HStack(alignment: .center) {
                            ProgressView()
                        }
                        .frame(height: 40)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchAlbums(for: artistId)
        }
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationTitle("Albums")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}
