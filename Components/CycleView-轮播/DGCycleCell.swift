//
//  DGCycleCell.swift
//  Components
//
//  Created by dd on 2018/12/11.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class DGCycleCell: UICollectionViewCell {
    
    var model: Any?{
        didSet{
            
        }
    }
    
    private var imageView:UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: "timg")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.contentView.bounds
    }
}
