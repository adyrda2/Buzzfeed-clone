import Foundation
import UIKit

import UIKit
import Foundation

class LatestArticlesCollectionViewController: UICollectionViewController {
    
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArticles()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 100, left: 5, bottom: 10, right: 5)
        layout.itemSize = CGSize(width: 176, height: 147)
        collectionView!.collectionViewLayout = layout
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestArticleCell", for: indexPath) as! LatestArticleCell
        let article = articles[indexPath.row]
        cell.latestArticleImage.image = Article.convertToImage(urlToImage: article.urlToImage)
        return cell
    }
}

