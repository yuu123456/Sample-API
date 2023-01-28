//
//  ViewController.swift
//  SampleAPI
//
//  Created by 秋山悠 on 2023/01/28.
//

import UIKit

//JSONをSwiftに変換：デコーダブル
struct User: Decodable {
    let name: String
    let profileImageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImageURL = "profile_image_url"
    }
}

struct Item: Decodable {
    let title: String
    let createdAt: String
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case title
        case createdAt = "created_at"
        case user
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            let url = URL(string: "https://qiita.com/api/v2/items?page=1&per_page=10")!
            let (data, _) = try await URLSession.shared.data(from: url)

            
            DispatchQueue.main.async {
                do {
                    self.items = try JSONDecoder().decode([Item].self, from: data)
                    self.tableView.reloadData()
                } catch {
                    
                }

            }

        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        
        configuration.text = items[indexPath.row].title
        
        cell.contentConfiguration = configuration
        
        return cell
        
    }
    

}
