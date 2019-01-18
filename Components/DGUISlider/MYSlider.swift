//
//  MYSlider.swift
//  滑动改变数值
//
//  Created by 高诚 on 2017/11/8.
//  Copyright © 2017年 高诚. All rights reserved.
//

import UIKit
public let SliderH:CGFloat = 20.0
class MYSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(origin: .zero, size: CGSize(width:bounds.size.width , height: SliderH))
        
    }

}
