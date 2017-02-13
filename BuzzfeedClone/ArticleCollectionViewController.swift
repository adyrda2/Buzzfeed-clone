import UIKit
import Foundation

class ArticleCollectionViewController: UICollectionViewController {

  var articles = [Article]()

  override func viewDidLoad() {
    super.viewDidLoad()
    fetchArticles()
  }

  func fetchArticles() {
    let url = URL(string:"https://newsapi.org/v1/articles?source=the-next-web&sortBy=latest&apiKey=\(Article.fetchApiKey())")
    URLSession.shared.dataTask(with: url! as URL) { data, response, error in
      let httpResponse = response as? HTTPURLResponse
      if httpResponse?.statusCode == 200 && data != nil {
        guard let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else { return }
        self.articles = Article.fromJson(json: json)
        self.collectionView?.reloadData()
      }
    }.resume()
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return articles.count
  }

  // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
    let article = articles[indexPath.row]
    cell.urlImage.image = Article.convertToImage(urlToImage: article.urlToImage)
    return cell
  }
}
