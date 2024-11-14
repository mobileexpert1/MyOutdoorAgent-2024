//
//  DropdownView.swift
//  MyOutdoorAgent
//
//  Created by Vishal on 08/07/24.
//

import Foundation
import UIKit

class DropdownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var items: [String] = []
    var tableView: UITableView!
    var didSelectItem: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTableView()
    }
    
//    func setupTableView() {
//        tableView = UITableView(frame: self.bounds - 100)
//        tableView.delegate = self
//        tableView.dataSource = self
//        self.addSubview(tableView)
//    }
    func setupTableView() {
      //  let tableViewHeight = self.bounds.height - 100
        let topInset: CGFloat = 20
        tableView = UITableView(frame: CGRect(x: 0, y: topInset, width: self.bounds.width, height: 150))
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItem?(items[indexPath.row])
        self.removeFromSuperview()
    }
}
