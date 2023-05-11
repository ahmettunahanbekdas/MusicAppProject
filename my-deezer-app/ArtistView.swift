//
//  ArtistView.swift
//  my-deezer-app
//
//  Created by Ahmet Tunahan Bekdaş on 10.05.2023.
//

import SwiftUI
struct Artist: Codable,Identifiable {
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

    enum CodingKeys: String, CodingKey {
        case id, name, picture, pictureSmall = "picture_small", pictureMedium = "picture_medium", pictureBig = "picture_big", pictureXl = "picture_xl", radio, tracklist, type
    }
}

struct ArtistData: Codable {
    let data: [Artist]
}




struct ArtistView : View {
    @State private var errorMessage = ""
    @State private var artists = [Artist]()
    let genre:Genre

    
    
    var body: some View {
        VStack{
            
            ScrollView{
                LazyVGrid(columns:[GridItem( .adaptive(minimum:130))]){
                    
                    ForEach(artists) { artist in
                        NavigationLink(destination:ArtistDetailView( artistId:artist.id)){
                            NavigationView{
                                    Text(artist.name)
                                    .frame(width: 200, height: 200)
                                    .background(Color.gray)
                                    .foregroundColor(.black)
                                EmptyView()
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform:fetchArtist)
       // .navigationBarBackButtonHidden(true)
    }
    
    func fetchArtist(){
        let url = URL(string: "https://api.deezer.com/genre/\(genre.id)/artists")!
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
                let artistData = try JSONDecoder().decode(ArtistData.self, from: data )
                DispatchQueue.main.async{
                    artists  = artistData.data
                }
            }catch let error {
                errorMessage = error.localizedDescription
            }
        }.resume()
    }
}




/*
 struct ArtistView_Previews: PreviewProvider {
 static var previews: some View {
 ArtistView()
 }
 }
 */
