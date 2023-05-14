import SwiftUI

// MARK: - FavoritesPage

struct FavoritesPage: View {
    @ObservedObject var favorites: Favorites
    
// MARK: - View Body

    var body: some View {
        NavigationView {
            List {
                ForEach(favorites.tracks) { track in
                    HStack {
                        AsyncImage(url: URL(string: track.cover)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(track.title)
                                .font(.headline)
                            Text("\(track.duration / 60).\((track.duration % 60 < 10 ? "0" : "") + String(track.duration % 60))")
                                .font(.subheadline)
                        }

                        Spacer()

                        Button(action: {
                            if let index = favorites.tracks.firstIndex(where: { $0.id == track.id }) {
                                favorites.tracks.remove(at: index)
                            }
                        }) {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle(Text("Favorites Songs").font(.largeTitle).bold().foregroundColor(.black), displayMode: .inline)
        }
    }
}


