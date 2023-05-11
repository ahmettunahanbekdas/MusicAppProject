import SwiftUI


struct AlbumDetail: Codable, Identifiable {
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
        case id, title, link, cover
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


struct AlbumDetailView: View {
    @State private var errorMessage = ""
    @State private var albums = [AlbumDetail]()
    @State private var albumDetail: AlbumDetail?
 
    
    let albumId: Int
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns:[GridItem(.adaptive(minimum: 120))]){
                    ForEach(albums) { album in
                        NavigationView {
                            Text(album.title)
                            EmptyView()
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchAlbumDetail()
        }
        
    }
    
    func fetchAlbumDetail() {
        let url = URL(string: "https://api.deezer.com/artist/\(albumId)/albums/")!
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
                let response = try JSONDecoder().decode([AlbumDetail].self, from: data)
                DispatchQueue.main.async {
                    albums = response
                }
            } catch let error {
                errorMessage = error.localizedDescription
            }
        }.resume()
    }
}

