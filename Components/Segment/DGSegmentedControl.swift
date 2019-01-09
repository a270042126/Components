//
//  DGSegmentedControl.swift
//  Components
//
//  Created by dd on 2019/1/7.
//  Copyright © 2019年 dd. All rights reserved.
//

import UIKit

protocol DGSegmentedControlDelegate: class {
    func dgSegmentedControl(_ segmentedControl: DGSegmentedControl, selectedIndex index: Int)
}

class DGSegmentedControl: UIView {
    
    weak var delegate: DGSegmentedControl?
}
