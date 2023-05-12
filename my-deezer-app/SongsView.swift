//
//  SongsView.swift
//  my-deezer-app
//
//  Created by Ahmet Tunahan Bekdaş on 11.05.2023.
//

import SwiftUI

private struct AlbumResponse: Codable {
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
    let genres: GenreData
    let label: String
    let nbTracks: Int
    let duration: Int
    let fans: Int
    let releaseDate: String
    let recordType: String
    let tracklist: URL
    let explicitLyrics: Bool
    let tracks: TrackData
    
    
    enum CodingKeys: String, CodingKey {
        case id, title, link, cover
        case coverSmall = "cover_small"
        case coverMedium = "cover_medium"
        case coverBig = "cover_big"
        case coverXl = "cover_xl"
        case md5Image = "md5_image"
        case genreId = "genre_id"
        case genres, label, nbTracks, duration, fans, releaseDate, recordType, tracklist
        case explicitLyrics = "explicit_lyrics"
        case tracks = "tracks"
    }
}



private struct GenreData: Codable {
    let data: [Genre]
}

private struct TrackData:Codable{
    let data:[Track]
}

 private struct Genre: Codable {
    let id: Int
    let name: String
    let picture: URL
    let type: String
}

private struct Track: Codable,Identifiable {
    let id: Int
    let readable: Bool
    let title: String
    let titleShort: String
    let titleVersion: String
    let link: URL
    let duration: Int
    let rank: Int
    let explicitLyrics: Bool
    let explicitContentLyrics: Int
    let explicitContentCover: Int
    let preview: URL
    let md5Image: String
    let artist: Artist
    let album: Album
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id, readable, title, link, duration, rank, preview
        case titleShort = "title_short"
        case titleVersion = "title_version"
        case explicitLyrics = "explicit_lyrics"
        case explicitContentLyrics = "explicit_content_lyrics"
        case explicitContentCover = "explicit_content_cover"
        case md5Image = "md5_image"
        case artist, album, type
    }
}

private struct Artist: Codable {
    let id: Int
    let name: String
    let tracklist: URL
    let type: String
}

private struct Album: Codable,Identifiable {
    let id: Int
    let title: String
    let cover: URL
    let coverSmall: URL
    let coverMedium: URL
    let coverBig: URL
    let coverXl: URL
    let md5Image: String
    let tracklist: URL
    let type: String
}


struct SongsView: View {
    @State private var albumResponse:AlbumResponse
    @State private var errorMessage = ""
    let albumId:Int
    
    var body: some View {
        VStack{
            ForEach(albumResponse.tracks.data){ track in
                Text(track.title)
                
            }
            Text(String(1))
        }.onAppear(perform: {
            fetchArtist()
        })
        
    }
   
    func fetchArtist(){
        let url = URL(string: "https://api.deezer.com/album/\(albumId)")!
        URLSession.shared.dataTask(with: url) {data,
            response, error in
            if let error = error{
                errorMessage = error.localizedDescription
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received"
                }
                return
            }
            do{
                let response = try JSONDecoder().decode(AlbumResponse.self, from: data )
                DispatchQueue.main.async{
                   albumResponse  = response
                }
            }catch let error {
                errorMessage = error.localizedDescription
            }
        }.resume()
    }
   
}


