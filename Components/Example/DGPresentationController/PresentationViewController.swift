//
//  PresentationViewController.swift
//  Components
//
//  Created by dd on 2019/1/17.
//  Copyright © 2019年 dd. All rights reserved.
//

import UIKit

class PresentationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    deinit {
        print("PresentationViewController deinit")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                self.dg_bottomPresentController(vc: FirstVC(), presentedHeight: 200) { (isPresented) in
                    print(isPresented)
                }
//        self.dg_centerPresentController(vc: FirstVC(), presentedSize: CGSize(width: 200, height: 300)) { (isPresented) in
//            if isPresented{
//                print("出现")
//            }else{
//                print("消失")
//            }
//        }
    }
}
