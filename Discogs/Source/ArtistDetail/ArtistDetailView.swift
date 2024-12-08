//
//  ArtistDetailView.swift
//  Discogs
//
//  Created by Belen on 03/12/2024.
//

import SwiftUI

struct ArtistDetailView: View {
    @StateObject private var viewModel = ArtistDetailViewModel()
    let artistId: Int
    
    var body: some View {
        VStack {
            if let artist = viewModel.artistDetails {
                if let imageUrl = artist.images?.first?.uri {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Text(artist.name)
                    .font(.title)
                    .bold()
                    .padding()
                
                Text(artist.profile)
                    .font(.body)
                    .padding()
                
                if let members = artist.members {
                    Section(header: Text("Band Members").font(.headline)) {
                        List(members) { member in
                            HStack {
                                Text(member.name)
                                Spacer()
                                if member.active {
                                    Text("Active").foregroundColor(.green)
                                }
                            }
                        }
                        .frame(height: CGFloat(members.count) * 44)
                    }
                }
                
                NavigationLink(destination: ArtistAlbumsView(artistId: artistId)) {
                    Text("View Albums")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Spacer()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.fetchArtistDetails(id: artistId)
        }
        .navigationTitle("Artist Details")
        .navigationBarTitleDisplayMode(.inline)
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
