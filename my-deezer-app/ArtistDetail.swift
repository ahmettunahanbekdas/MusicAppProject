//
//  ArtistDetail.swift
//  my-deezer-app
//
//  Created by Ahmet Tunahan Bekdaş on 10.05.2023.
//

import SwiftUI








struct ArtistApi: Codable {
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





struct ArtistDetail: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    
    
    
    
    func FetchArtistDetail() {
        let url = URL(string:"https://api.deezer.com/artist/152")!
        URLSession.shared.dataTask(with: url) { data,
            response, error in
            if let error = error {
                errorMessage = "No data received"
            }
            return
        }
    }
    
}

struct ArtistDetail_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetail()
    }
}
