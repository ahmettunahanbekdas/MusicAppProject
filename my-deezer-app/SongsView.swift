//
//  SongsView.swift
//  my-deezer-app
//
//  Created by Ahmet Tunahan Bekdaş on 11.05.2023.
//

import SwiftUI

private struct AlbumResponse: Codable,Identifiable {
    let id: Int
    let title: String
    let upc: String
    let link: String
    let share: String
    let cover: String
    let cover_small: String
    let cover_medium: String
    let cover_big: String
    let cover_xl: String
    let md5_image: String
    let genre_id: Int
    let genres: String //GenreData
    let label: String
    let nb_tracks: Int
    let duration: Int
    let fans: Int
    let release_date: String
    let record_type: String
    let available: Bool
    let tracklist: String
    let explicit_lyrics: Bool
    let explicit_content_lyrics: Int
    let explicit_content_cover: Int
    let contributors: String //[Artist]
    let artist: String //Artist
    let type: String
    let tracks: String //TrackData
}

private struct GenreData: Codable {
    let data: [Genre]
}

private struct Genre: Codable {
    let id: Int
    let name: String
    let picture: String
    let type: String
}

private struct Artist: Codable {
    let id: Int
    let name: String
    let link: String
    let share: String
    let picture: String
    let picture_small: String
    let picture_medium: String
    let picture_big: String
    let picture_xl: String
    let radio: Bool
    let tracklist: String
    let type: String
    let role: String?
}

private struct TrackData: Codable {
    let data: [Track]
}

private struct Track: Codable,Identifiable {
    let id: Int
    let readable: Bool
    let title: String
    let title_short: String
    let title_version: String
    let link: String
    let duration: Int
    let rank: Int
    let explicit_lyrics: Bool
    let explicit_content_lyrics: Int
    let explicit_content_cover: Int
    let preview: String
    let md5_image: String
    let artist: Artist
    let album: AlbumResponse
    let type: String
}




struct SongsView: View {
    @State private var tracks = [Track]()
    @State private var errorMessage = ""
    
    let albumId:Int
    
    var body: some View {
        VStack{
            ForEach(tracks){ track in
                Text(track.title)
                
            }
            Text(String(albumId))
        }.onAppear(perform: fetchArtist)
        
    }
   
    func fetchArtist(){
        
        let url = URL(string: "https://api.deezer.com/album/\(albumId)")!
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
                let response = try JSONDecoder().decode( AlbumResponse.self, from: data)
                DispatchQueue.main.async {
                    print(223432)
                    print(response)
                }
            } catch let error {
                errorMessage = error.localizedDescription
                print(errorMessage)
            }
        }.resume()
        
       
    }
   
}


