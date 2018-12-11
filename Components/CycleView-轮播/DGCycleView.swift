//
//  DGCycleScrollView.swift
//  Components
//
//  Created by dd on 2018/12/11.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class DGCycleView: UIView {
    
    var models:[Any]? {
        didSet{
            collectionView.reloadData()
            pageControl.numberOfPages = models?.count ?? 0
            removeCycleTimer()
            addCycleTimer()
        }
    }

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        return pageControl
    }()
    
    fileprivate lazy var collectionView:UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DGCycleCell.self, forCellWithReuseIdentifier: "\(DGCycleCell.self)")
        return collectionView
    }()
    
    private var cycleTimer:Timer?
    private var oldContentOffsetX: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        self.addSubview(collectionView)
        self.addSubview(pageControl)
        
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-|", options: .init(rawValue: 0), metrics: nil, views: ["view": pageControl])
        addConstraints(constraints)
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==20)]-|", options: .init(rawValue: 0), metrics: nil, views: ["view": pageControl])
        addConstraints(constraints)
    }
    
    override func layoutSubviews() {
        collectionView.frame = self.bounds
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = self.bounds.size
    }
}

extension DGCycleView{
    private func addCycleTimer(){
        cycleTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoop.Mode.common)
    }
    
    private func removeCycleTimer(){
        cycleTimer?.invalidate()
        cycleTimer = nil
    }
    
    @objc private func scrollToNext(){
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

extension DGCycleView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard models != nil else {return}
        let scrollViewW = scrollView.bounds.width
        let contentOffsetX = scrollView.contentOffset.x
        
        let isRight = oldContentOffsetX < contentOffsetX
        oldContentOffsetX = contentOffsetX
        
        if contentOffsetX > (scrollViewW * CGFloat(models!.count - 1) + scrollViewW * 0.5 ) && cycleTimer == nil{
            pageControl.currentPage = 0
        } else if contentOffsetX > scrollViewW * CGFloat(models!.count - 1) && cycleTimer != nil && isRight {
            pageControl.currentPage = 0
        }else{
            pageControl.currentPage = Int((contentOffsetX + scrollViewW * 0.5) / scrollViewW)
        }
        
        if contentOffsetX > scrollViewW * CGFloat(models!.count){
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }else if contentOffsetX < 0{
            collectionView.setContentOffset(CGPoint(x: contentOffsetX + scrollViewW * CGFloat(models!.count), y: 0), animated: false)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models?.count != nil ? models!.count + 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DGCycleCell.self)", for: indexPath) as! DGCycleCell
        if indexPath.row == models!.count{
            cell.model = models![0]
        }else{
            cell.model = models![indexPath.row]
        }
        return cell
    }
}
