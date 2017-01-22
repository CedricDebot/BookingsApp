import Foundation

class Dj {
    let image: String
    let djName: String
    let region: String
    let price: Double
    let biography: String
    let genres: [String]
    let references: [String]
    
    init(djName: String, region: String, price: Double, biography: String, genres: [String], references: [String], image: String) {
        self.djName = djName
        self.region = region
        self.price = price
        self.biography = biography
        self.genres = genres
        self.references = references
        self.image = image
    }
}


