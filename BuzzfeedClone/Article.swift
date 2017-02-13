import Foundation
import UIKit

struct Article {
  var author: String
  var title: String
  var url: String
  var urlToImage: String
  var publishedAt: String
  static var articlesArray: [Article] = []
  
  init?(json: [String: Any]) {
    guard let author = json["author"] as? String, let title = json["title"], let url = json["url"], let urlToImage = json["urlToImage"], let publishedAt = json["publishedAt"] else { return nil }
    self.author = author
    self.title = title as! String
    self.url = url as! String
    self.urlToImage = urlToImage as! String
    self.publishedAt = publishedAt as! String
  }

  static func convertToImage(urlToImage: String) -> UIImage {
    let imageURL = UIImageView()
    let url = URL(string: urlToImage)
    let data = NSData(contentsOf:url!)
    if data != nil {
      imageURL.image = UIImage(data:data! as Data)
    }
    return imageURL.image!
  }

  static func fetchApiKey() -> String {
    var keys:NSDictionary?
    if let path = Bundle.main.path(forResource: "MyList", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
    }
    guard let dict = keys, let key = dict["buzzfeedApiKey"] as? String else { return "" }
    return key
  }
  
  static func fromJson(json: [String: Any]) -> [Article] {
    guard let articleObject = json["articles"] as? [[String: Any]] else { return [] }
    var articles: [Article] = []
    for articleNode in articleObject {
      guard let article = Article(json: articleNode) else { continue }
      articles.append(article)
    }
    return articles
  }
}
