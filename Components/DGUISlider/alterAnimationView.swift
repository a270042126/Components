//
//  alterAnimationView.swift
//  滑动改变数值
//
//  Created by 高诚 on 2017/11/8.
//  Copyright © 2017年 高诚. All rights reserved.
//

import UIKit

class alterAnimationView: UIView {
   private lazy var imageView: UIImageView = {
       let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: self.bounds.size.width, height: self.bounds.size.width)))
        imageView.image = #imageLiteral(resourceName: "对话框")
        return imageView
    }()
   private lazy var numLabel: UILabel = {
        let label = UILabel(frame:CGRect(x: 15, y: 10, width:  self.bounds.size.width-30, height: self.bounds.size.height-30))
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        numLabel.text = "0"
        self.addSubview(numLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sliderScroll(value:Int) {
        numLabel.text = String(value)
    }
    
}
