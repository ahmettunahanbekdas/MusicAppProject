import SwiftUI

// MARK: - Track Structure
struct Track: Codable, Identifiable {
    let id: Int
    let title: String
    let duration: Int
    let preview: String
    let cover: String
}

class Favorites: ObservableObject {
    @Published var tracks: [Track] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(tracks) {
                UserDefaults.standard.set(encoded, forKey: "Favorites")
            }
        }
    }

    init() {
        if let items = UserDefaults.standard.data(forKey: "Favorites") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Track].self, from: items) {
                self.tracks = decoded
                return
            }
        }

        self.tracks = []
    }
}

// MARK: - SongsView

struct SongsView: View {
    @StateObject var favorites = Favorites()
    @State var tracks = [Track]()
    @State var album_title = ""
    @State var errorMessage = ""
    let albumId: Int
    
// MARK: - View Body
    var body: some View {
        NavigationView {
            VStack {
                List(tracks) { track in
                    HStack {
                        HStack {
                            AsyncImage(url: URL(string: track.cover)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text(track.title)
                                    .font(.headline)
                                Text("\(track.duration / 60).\((track.duration % 60 < 10 ? "0" : "") + String(track.duration % 60))")
                                    .font(.subheadline)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if favorites.tracks.contains(where: { $0.id == track.id }) {
                                favorites.tracks.removeAll(where: { $0.id == track.id })
                            } else {
                                favorites.tracks.append(track)
                            }
                        }) {
                            Image(systemName: favorites.tracks.contains(where: { $0.id == track.id }) ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .navigationBarTitle(Text(album_title).font(.largeTitle).bold().foregroundColor(.black), displayMode: .inline)
                .navigationBarItems(trailing: NavigationLink(destination: FavoritesPage(favorites: favorites)) {
                    Image(systemName: "heart")
                })
            }
        }
        .onAppear(perform: fetch2)
    }
    
// MARK: - Methods
    func fetch2() {
        if let url = URL(string: "https://api.deezer.com/album/\(albumId)") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        errorMessage = "Hata oluştu: \(error)"
                    }
                } else if let data = data {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            DispatchQueue.main.async {
                                album_title = jsonObject["title"] as? String ?? ""
                                let main_cover = jsonObject["cover_small"] as? String ?? ""
                                
                                if let _tracks = jsonObject["tracks"] as? [String: Any],
                                   let tracksData = _tracks["data"] as? [[String: Any]] {
                                    for dataItem in tracksData {
                                        let id = dataItem["id"] as? Int ?? 0
                                        let title = dataItem["title"] as? String ?? ""
                                        let duration = dataItem["duration"] as? Int ?? 0
                                        let preview = dataItem["preview"] as? String ?? ""
                                        
                                        let newTrack = Track(id: id, title: title, duration: duration, preview: preview, cover: main_cover)
                                        tracks.append(newTrack)
                                    }
                                }
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            errorMessage = "JSON verisini çözme hatası: \(error)"
                        }
                    }
                }
            }.resume()
        } else {
            DispatchQueue.main.async {
                errorMessage = "Geçersiz URL"
            }
        }
    }
}
