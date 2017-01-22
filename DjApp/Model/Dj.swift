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

extension Dj {
    convenience init(json: [String: Any]) throws {
        guard let djName = json["djName"] as? String else {
            throw Service.Error.missingJsonProperty(name: "djName")
        }
        guard let region = json["region"] as? String else {
            throw Service.Error.missingJsonProperty(name: "region")
        }
        guard let price = json["price"] as? Double else {
            throw Service.Error.missingJsonProperty(name: "price")
        }
        guard let biography = json["biography"] as? String else {
            throw Service.Error.missingJsonProperty(name: "biography")
        }
        guard let genres = json["genres"] as? String else {
            throw Service.Error.missingJsonProperty(name: "genres")
        }
        guard let references = json["references"] as? String else {
            throw Service.Error.missingJsonProperty(name: "references")
        }
        guard let image = json["image"] as? String else {
            throw Service.Error.missingJsonProperty(name: "image")
        }
        
        self.init(djName: djName,
                  region: region,
                  price: price,
                  biography: biography,
                  genres: [genres],
                  references: [references],
                  image: image)
    }
}
