import SwiftUI

// MARK: - Album Structure
private struct Album: Codable, Identifiable {
    let id: Int
    let title: String
    let link: String
    let cover: String
    let coverSmall: URL
    let coverMedium: URL
    let coverBig: String
    let coverXl: URL
    let md5Image: URL
    let genreId: Int
    let fans: Int
    let releaseDate: String
    let recordType: String
    let tracklist: String
    let explicitLyrics: Bool
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, link, cover, coverSmall = "cover_small", coverMedium = "cover_medium", coverBig = "cover_big", coverXl = "cover_xl", md5Image = "md5_image", genreId = "genre_id", fans, releaseDate = "release_date", recordType = "record_type", tracklist, explicitLyrics = "explicit_lyrics", type
    }
}

// MARK: - AlbumData Structure
private struct AlbumData: Codable {
    let data: [Album]
}

// MARK: - ArtistDetail Structure
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

// MARK: - ArtistDetailView
struct ArtistDetailView: View {
    @State private var errorMessage = ""
    @State private var artistDetail: ArtistDetail?
    @State private var albums = [Album]()
    let artistId: Int
    
// MARK: - View Body
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .center) {
                    AsyncImage(url: artistDetail?.pictureXl ?? nil) { phase in
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
                    
                    ForEach(albums) { album in
                        NavigationLink(destination: SongsView(albumId: album.id)) {
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
                                    .frame(maxWidth: .infinity) // Bu satır, tüm hücrelerin eşit genişliğe sahip olduğunu sağlar
                                }
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .frame(width: UIScreen.main.bounds.width - 40)
                            }
                            .padding(.bottom, 10)
                            .navigationBarTitle(Text(artistDetail?.name ?? "NULL").font(.largeTitle).bold().foregroundColor(.black), displayMode: .inline)
                        }
                    }
                }
            }
            .onAppear(perform: {
                fetchArtistDetail()
                fetchAlbums()
            })
        }
    
// MARK: - Methods
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
                        artistDetail = response
                    }
                } catch let error {
                    errorMessage = error.localizedDescription
                }
            }.resume()
        }
        
        func fetchAlbums() {
            let url = URL(string: "https://api.deezer.com/artist/\(artistId)/albums/")!
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
                        albums = response.data
                    }
                } catch let error {
                    errorMessage = error.localizedDescription
                }
            }.resume()
        }
    }
