//
//  ContentView.swift
//  my-deezer-app
//
//  Created by Ahmet Tunahan Bekdaş on 10.05.2023.
//

// Bu kısım, müzik türlerini temsil eden bir Genre yapısını tanımlar. Codable ve Identifiable protokollerini uygular ve Deezer API'sinden alınan JSON verisini bu modele dönüştürmek için kullanılır.

import SwiftUI

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

//Bu kısım, Deezer API'sinden dönen müzik türü verilerini içeren bir GenreData yapısını tanımlar. Bu yapı, data adında bir diziye sahip olup, bu dizi içinde Genre nesnelerini içerir.
private struct GenreData: Codable{
    let data:[Genre]
}

//Bu bölümde, ana ContentView yapısı tanımlanır. Uygulamanın ana ekranını oluşturur. isActive, genres, errorMessage ve imageUrl olmak üzere dört adet @State değişkeni bulunur. isActive değişkeni, görünümdeki gezinme bağlantılarının etkinleştirilip etkinleştirilmeyeceğini kontrol eder. genres değişkeni, müzik türlerini depolar. errorMessage değişkeni, olası hataları depolar. imageUrl değişkeni, geçici olarak kullanılır ve şu anda kodda kullanılmamaktadır.
struct ContentView: View {
    @State private var isActive: Bool = false
    @State private var genres = [Genre]()
    @State private var errorMessage = ""
    @State private var imageUrl = ""
    
// Görünüm içinde NavigationView, ScrollView ve LazyVGrid kullanılır. genres dizisini dolaşarak her bir müzik türü için bir NavigationLink oluşturulur. NavigationLink tıklanıldığında, ilgili müzik türünün ayrıntılarını gösteren ArtistView'e geçiş yap
    var body: some View {

        NavigationView{ 
            ScrollView{
                Text("Deezer App")
                    .font(.headline)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))]){
                    
                    ForEach(genres) {genre in
                        NavigationLink(destination: ArtistView(genreId:genre.id)){
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
        let url = URL(string: "https://api.deezer.com/genre")! // Deezer API'sine istek yapılacak URL oluşturuluyor.

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                errorMessage = error.localizedDescription // Hata varsa hatayı yakala ve errorMessage değişkenine ata.
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received" // Veri yoksa hata mesajını errorMessage değişkenine ata.
                }
                return
            }
            
            do {
                let genreData = try JSONDecoder().decode(GenreData.self, from: data) // Gelen veriyi GenreData yapısına çöz ve genreData değişkenine ata.
                DispatchQueue.main.async {
                    genres = genreData.data // GenreData'dan alınan veriyi genres dizisine ata.
                }
            } catch let error {
                errorMessage = error.localizedDescription // Hata varsa hatayı yakala ve errorMessage değişkenine ata.
            }
        }.resume() // Veri isteğini başlat.
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}



