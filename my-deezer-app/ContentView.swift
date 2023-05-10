//
//  ContentView.swift
//  my-deezer-app
//
//  Created by Ahmet Tunahan Bekdaş on 10.05.2023.
//

import SwiftUI
struct Genre: Codable, Identifiable {
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
struct GenreData: Codable{
    let data:[Genre]
}




struct ContentView: View {
    @State private var isActive: Bool = false
    @State private var genres = [Genre]()
    @State private var errorMessage = ""
    @State private var imageUrl = ""
    
    
    var body: some View {

        NavigationView{
            
            ScrollView{
                Text("Deezer App")
                    .font(.headline)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))]){
                    
                    ForEach(genres) { genre in
                        
                        NavigationLink(destination: ArtistView(genre:genre)){
                            NavigationView{
                                Text(genre.name)
                                    .frame(width: 200, height: 200)
                                    .background(Color.gray)
                                    .foregroundColor(.black)
                                EmptyView()
                            }
                        }


                    }
                }
                .onAppear(perform:fetchGenres)
                //.navigationBarBackButtonHidden(true)
            }
        }
    }
    
    
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
                    genres  = genreData.data
                }
            } catch let error {
                errorMessage = error.localizedDescription
            }
        }.resume()
       
        
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}



