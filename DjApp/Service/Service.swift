import Foundation
import Alamofire
import SwiftyJSON

class Service {
    enum Error: Swift.Error {
        case missingJsonProperty(name: String)
        case noNetwork
        case unexpectedStatusCode(code: Int, expected: Int)
        case missingResponseData
        case invalidJsonData(message: String)
        case other(Swift.Error)
    }
    
    static let shared = Service()
    
    private let url = URL(string: "http://localhost:3000/api/profiles/djs")!
    private let session = URLSession(configuration: .ephemeral)
    
    func getDjs(parameterUrl: String) -> [Dj] {
        var djs: [Dj] = []
        Alamofire.request("http://192.168.2.33:3000/api/profiles/djs\(parameterUrl)").responseJSON {
            response in
            print(response.result)
            
            if response.result.isSuccess {
                let resJson = JSON(response.result.value!)
                print(resJson)
                for (_, subjson) in resJson {
                    let djName = subjson["djName"].string!
                    let region = subjson["region"].string!
                    let price = subjson["price"].double!
                    let biography = subjson["biography"].string!
                    let genres: [String] = subjson["genres"].arrayValue.map{$0.string!}
                    let references: [String] = subjson["references"].arrayValue.map{$0.string!}
                    let image = subjson["image"].string!
                    
                    let dj = Dj.init(djName: djName, region: region, price: price, biography: biography, genres: genres, references: references, image: image)
                    djs.append(dj)
                }
            //     return djs
            } else {
            //    return []
            }
        }
       return djs
    }
    
    
    func loadDataTask(completionHandler: @escaping (Result<[Dj]>) -> Void) -> URLSessionTask {
        let task = session.dataTask(with: url) {
            data, response, error in
            
            let completionHandler: (Result<[Dj]>) -> Void = {
                result in
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.noNetwork))
                return
            }
            
            guard response.statusCode == 200 else {
                completionHandler(.failure(.unexpectedStatusCode(code: response.statusCode, expected: 200)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.missingResponseData))
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let results = json as? [[String: Any]] else {
                    completionHandler(.failure(.invalidJsonData(message: "Data does not contain an array of objects")))
                    return
            }
            
            do {
                let djs = try results.map{ try Dj.init(json: $0)}
                completionHandler(.succes(djs))
            } catch let error as Error {
                completionHandler(.failure(error))
            } catch {
                completionHandler(.failure(.other(error)))
            }
        }
        
        
        
        return task;
    }
    
}
