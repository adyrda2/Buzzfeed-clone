import Foundation

struct Article {
  var author: String
  var title: String
  var url: String
  var urlToImage: String
  var publishedAt: String
  
  init?(json: [String: Any]) {
    guard let author = json["author"] as? String, let title = json["title"], let url = json["url"], let urlToImage = json["urlToImage"], let publishedAt = json["publishedAt"] else { return nil }
    self.author = author
    self.title = title as! String
    self.url = url as! String
    self.urlToImage = urlToImage as! String
    self.publishedAt = publishedAt as! String
  }
  
  static func fetchApiKey() -> String {
    var keys:NSDictionary?
    if let path = Bundle.main.path(forResource: "MyList", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
    }
    guard let dict = keys, let key = dict["buzzfeedApiKey"] as? String else { return "" }
    return key
  }

  static func fetchArticles() {
    let url = NSURL(string:"https://newsapi.org/v1/articles?source=the-next-web&sortBy=latest&apiKey=\(fetchApiKey())")
    URLSession.shared.dataTask(with: url! as URL) { data, response, error in
      let httpResponse = response as? HTTPURLResponse
      if httpResponse?.statusCode == 200 && data != nil {
        
        var json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
        print(json)
      }
    }.resume()
  }
}

  
