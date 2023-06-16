import SwiftUI

// MARK: - Artist Structure
private struct Artist: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case id, name, picture, pictureSmall = "picture_small", pictureMedium = "picture_medium", pictureBig = "picture_big", pictureXl = "picture_xl", radio, tracklist, type
    }
    let id: Int
    let name: String
    let picture: URL
    let pictureSmall: URL
    let pictureMedium: URL
    let pictureBig: URL
    let pictureXl: URL
    let radio: Bool
    let tracklist: URL
    let type: String
}

// MARK: - ArtistData Structure
private struct ArtistData: Codable {
    let data: [Artist]
}

// MARK: - ArtistView
struct ArtistView: View {
    
    // MARK: - Properties
    @State private var errorMessage = ""
    @State private var artists = [Artist]()
    @State private var showFavorites = false

    let genreId: Int

    // MARK: - View Body
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 150), spacing: 5),
                    GridItem(.adaptive(minimum: 150), spacing: 5)
                ], spacing: 10) {
                    ForEach(artists) { artist in
                        NavigationLink(destination: ArtistDetailView(artistId: artist.id)) {
                            VStack {
                                AsyncImage(url: artist.pictureMedium) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxHeight: UIScreen.main.bounds.height * 0.15)
                                            .overlay(
                                                Text(artist.name)
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .padding(5)
                                                    .background(Color.black.opacity(0.5))
                                                    .cornerRadius(5)
                                                    .padding(5),
                                                alignment: .center
                                            )
                                    case .failure(_):
                                        Color.gray
                                    case .empty:
                                        Text("Loading...")
                                    @unknown default:
                                        Text("Loading...")
                                    }
                                }
                            }
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .navigationBarTitle(Text("ARTISTS").font(.largeTitle).bold().foregroundColor(.black), displayMode: .inline)
                        }
                    }
                }
            }
        }
        .onAppear(perform: fetchArtists)
    }

    // MARK: - Methods
    func fetchArtists() {
        let url = URL(string: "https://api.deezer.com/genre/\(genreId)/artists")!
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
                let artistData = try JSONDecoder().decode(ArtistData.self, from: data)
                DispatchQueue.main.async {
                    artists = artistData.data
                }
            } catch let error {
                errorMessage = error.localizedDescription
            }
        }.resume()
    }
}

