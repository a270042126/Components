//
//  ViewController.swift
//  Components
//
//  Created by dd on 2018/12/11.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        return tableView
    }()

    let cycleView = DGCycleView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        setupCycleView()
        setupTableView()
    }

    private func setupCycleView(){
        var models = [Model]()
        for _ in 0..<4{
            let model = Model()
            models.append(model)
        }
        cycleView.models = models
        view.addSubview(cycleView)
        cycleView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(cycleView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "\(UITableViewCell.self)")
        }
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "WKWebView"
        default:
            break
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let vc = DGWebViewController()
            vc.urlStr = "http://www.taobao.com"
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
