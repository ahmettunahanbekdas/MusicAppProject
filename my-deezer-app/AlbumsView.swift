//
//  AlbumsView.swift
//  my-deezer-app
//
//  Created by Ahmet Tunahan Bekdaş on 10.05.2023.
//

import SwiftUI



struct AlbumApi:Codable{
    let data: [Album]
    let total:Int
    let next:String
}

struct Album: Codable {
    let id: Int
    let title: String
    let link: URL
    let cover: URL
    let coverSmall: URL
    let coverMedium: URL
    let coverBig: URL
    let coverXl: URL
    let md5Image: String
    let genreId: Int
    let fans: Int
    let releaseDate: String
    let recordType: String
    let tracklist: URL
    let explicitLyrics: Bool
    let type: String

    enum CodingKeys: String, CodingKey {
        case id, title, link, cover, coverSmall = "cover_small", coverMedium = "cover_medium", coverBig = "cover_big", coverXl = "cover_xl", md5Image = "md5_image", genreId = "genre_id", fans, releaseDate = "release_date", recordType = "record_type", tracklist, explicitLyrics = "explicit_lyrics", type
    }
}


struct ContentViewAlbum: View {
    
    @State private var albums = [Album]()
    @State private var errorMessage = ""
    @State private var imageUrl = ""
    //@Binding private var albumId: Int
    let genre:Genre
    
    var body: some View {
        VStack {
                  if albums.isEmpty {
                      Text(errorMessage)
                  } else {
                      List(albums, id: \.id) { album in
                          
                          HStack {
                              AsyncImage(url:album.coverSmall)
                              VStack(alignment: .center){ Text(album.title)
                                      .font(.headline)
                                  Text(album.title)
                                      .font(.subheadline)
                                  Text(String(genre.name))
                                      .font(.subheadline)}
                             
                              
                            HStack {
                               
                                  Spacer()
                               
                              }
                          }
                      }
                  }
              }
              .onAppear(perform: fetchAlbums)
        .padding()
    }
    
    
    func fetchAlbums() {
            let url = URL(string: "https://api.deezer.com/artist/1/albums")!
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        errorMessage = "No data received"
                    }
                    return
                }
                do {
                    let albumData = try JSONDecoder().decode(AlbumApi.self, from: data)
                    DispatchQueue.main.async {
                        albums  = albumData.data
                    }
                } catch let error {
                    errorMessage = error.localizedDescription
                }
            }.resume()
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


