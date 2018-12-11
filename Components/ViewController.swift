//
//  ViewController.swift
//  Components
//
//  Created by dd on 2018/12/11.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let cycleView = DGCycleView()
    override func viewDidLoad() {
        super.viewDidLoad()
        var models = [Model]()
        for _ in 0..<4{
            let model = Model()
            models.append(model)
        }
        cycleView.models = models
        self.view.addSubview(cycleView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cycleView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200)
    }
}

