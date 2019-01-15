//
//  DGCycleScrollView.swift
//  Components
//
//  Created by dd on 2018/12/11.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

protocol DGCycleViewDelegate: class{
    func dgcycleViewDidSelected(model: Any)
}

class DGCycleView: UIView {
    
    weak var delegate: DGCycleViewDelegate?
    
    var models:[Any]? {
        didSet{
            collectionView.reloadData()
            pageControl.numberOfPages = models?.count ?? 0
            resetScroll()
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
        
        let collectionView = UICollectionView(frame: self!.bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DGCycleCell.self, forCellWithReuseIdentifier: "\(DGCycleCell.self)")
        return collectionView
    }()
    
    private var cycleTimer:Timer?
    
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
        updateUI()
    }
}

extension DGCycleView{
    private func updateUI(){
        collectionView.frame = self.bounds
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = self.bounds.size
        resetScroll()
    }
    
    private func resetScroll(){
        guard models != nil else {return}
        removeCycleTimer()
        let offsetX = self.bounds.width * CGFloat(models!.count)
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        addCycleTimer()
    }
    
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
        let offsetX = currentOffsetX + self.bounds.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

extension DGCycleView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        let scrollViewW = self.bounds.width
        guard models != nil && scrollViewW != 0 else {return}
        let contentOffsetX = scrollView.contentOffset.x
        
        pageControl.currentPage = Int((contentOffsetX + scrollViewW * 0.5) / scrollViewW) % models!.count
     
        if contentOffsetX >= scrollViewW * CGFloat(models!.count * 2 - 1){
            collectionView.setContentOffset(CGPoint(x:contentOffsetX - scrollViewW * CGFloat(models!.count) , y: 0), animated: false)
        }else if contentOffsetX < scrollViewW && cycleTimer == nil{
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
        return models?.count != nil ? models!.count * 2 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DGCycleCell.self)", for: indexPath) as! DGCycleCell
        cell.model = models![indexPath.row % models!.count]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.dgcycleViewDidSelected(model: models![indexPath.row % models!.count])
    }
}
