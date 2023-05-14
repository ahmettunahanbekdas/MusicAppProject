import SwiftUI

// MARK: - Models

private struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
    let picture: String
    let pictureSmall: String
    let pictureMedium: String
    let pictureBig: String
    let pictureXL: String
    let type: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, picture, type
        case pictureSmall = "picture_small"
        case pictureMedium = "picture_medium"
        case pictureBig = "picture_big"
        case pictureXL = "picture_xl"
    }
}

private struct GenreData: Codable {
    let data: [Genre]
}

// MARK: - Views

struct ContentView: View {
    @State private var genres = [Genre]()
    @State private var errorMessage = ""
    @State private var imageUrl = ""
    @State private var showingFavoritesPage = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 120))
                ], spacing: 10) {
                    ForEach(genres) { genre in
                        NavigationLink(destination: ArtistView(genreId: genre.id)) {
                            VStack {
                                AsyncImage(url: URL(string: genre.pictureMedium)!) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 120)
                                            .clipped()
                                            .overlay(
                                                Text(genre.name)
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .padding(8)
                                                    .background(Color.black.opacity(0.5))
                                                    .cornerRadius(8)
                                                    .padding(8),
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
                        }
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .onAppear(perform: fetchGenres)
                .navigationBarTitle("GENRES")
                .navigationBarTitle(Text("GENRES").font(.largeTitle).bold().foregroundColor(.black), displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            showingFavoritesPage = true
                        }) {
                            Image(systemName: "heart.fill")
                        }
                        .sheet(isPresented: $showingFavoritesPage) {
                            FavoritesPage(favorites: Favorites())
                        }
                    }
                }
            }
        }
    }
    
// MARK: - Methods
    
    func fetchGenres() {
        let url = URL(string: "https://api.deezer.com/genre")!
        
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
                let genreData = try JSONDecoder().decode(GenreData.self, from: data)
                DispatchQueue.main.async {
                    genres = genreData.data
                }
            } catch let error {
                errorMessage = error.localizedDescription
            }
        }.resume()
    }
}

