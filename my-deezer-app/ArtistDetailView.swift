//
//  ArtistDetailView.swift
//  my-deezer-app
//
//  Created by Ahmet Tunahan Bekdaş on 10.05.2023.
//


import SwiftUI

 private struct Album: Codable, Identifiable {
    let id: Int
    let title: String
    let link: String
    let cover: String
    let coverSmall: String
    let coverMedium: URL
    let coverBig: String
    let coverXl: String
    let md5Image: URL
    let genreId: Int
    let fans: Int
    let releaseDate: String
    let recordType: String
    let tracklist: String
    let explicitLyrics: Bool
    let type: String
    

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case link
        case cover
        case coverSmall = "cover_small"
        case coverMedium = "cover_medium"
        case coverBig = "cover_big"
        case coverXl = "cover_xl"
        case md5Image = "md5_image"
        case genreId = "genre_id"
        case fans
        case releaseDate = "release_date"
        case recordType = "record_type"
        case tracklist
        case explicitLyrics = "explicit_lyrics"
        case type
    }
}


// gelen apiyi albüm data içerisinde depolar
private struct AlbumData: Codable{
    let data:[Album]
}



private struct ArtistDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let link: URL
    let picture: URL
    let pictureSmall: URL
    let pictureMedium: URL
    let pictureBig: URL
    let pictureXl: URL
    let nbAlbum: Int
    let nbFan: Int
    let radio: Bool
    let tracklist: URL
    let type: String

    enum CodingKeys: String, CodingKey {
        case id, name, link, picture, pictureSmall = "picture_small", pictureMedium = "picture_medium", pictureBig = "picture_big", pictureXl = "picture_xl", nbAlbum = "nb_album", nbFan = "nb_fan", radio, tracklist, type
    }
}


struct ArtistDetailView: View {
    @State private var errorMessage = ""
    @State private var artistDetail : ArtistDetail?
    @State private var albums = [Album]()
   
    let artistId:Int

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .center) {
                    Text(artistDetail?.name ?? "NULL" )
                        .opacity(0)
                        .padding()
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    AsyncImage(url: artistDetail?.pictureMedium ?? nil){ phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width * 0.7, alignment: .center)
                        case .failure(_):
                            Text("Failed to load image.")
                        case .empty:
                            Text("Loading...")
                        @unknown default:
                            Text("Loading...")
                        }
                    }
                    .padding(.bottom, 10)
                
                    ForEach(albums){ album in
                        NavigationLink(destination: SongsView(albumId:album.id)){
                            HStack{
                                AsyncImage(url: album.coverMedium) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    case .failure(_):
                                        Text("Failed to load image.")
                                    case .empty:
                                        Text("Loading...")
                                    @unknown default:
                                        Text("Loading...")
                                    }
                                }
                                VStack(alignment: .leading) {
                                    Text(album.title)
                                    Text(album.releaseDate)
                                }
                                .padding()
                                .frame(maxWidth: .infinity) // This line ensures that all cells have equal width
                            }
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .frame(width: UIScreen.main.bounds.width - 40)
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            .padding(.top, 60)
            
            Text(artistDetail?.name ?? "NULL" )
                .padding()
                .font(.largeTitle)
                .fontWeight(.bold)
                
        }
        .onAppear(perform: {
            fetchArtistDetail()
            fetchAlbums()
        })
    }
    //... the rest of your code






    
    func fetchArtistDetail() {
        let url = URL(string: "https://api.deezer.com/artist/\(artistId)")!
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
                let response = try JSONDecoder().decode(ArtistDetail.self, from: data)
                DispatchQueue.main.async {
                    artistDetail  = response
                }
            } catch let error {
                errorMessage = error.localizedDescription
            }
        }.resume()
    }
    
    func fetchAlbums(){
        let url = URL(string:"https://api.deezer.com/artist/\(artistId)/albums/")!
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
                let response = try JSONDecoder().decode(AlbumData.self, from: data)
                DispatchQueue.main.async {
                    albums  = response.data
                }
            } catch let error {
                errorMessage = error.localizedDescription
            }
    }.resume()
        
        
    }

}


    /*
     struct ArtistDetail_Previews: PreviewProvider {
     static var previews: some View {
     ArtistDetail()
     }
     }
     */

