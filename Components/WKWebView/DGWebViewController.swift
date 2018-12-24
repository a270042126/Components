//
//  DGWebView.swift
//  Components
//
//  Created by dd on 2018/12/16.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import WebKit

class DGWebViewController: UIViewController {
    
    var urlStr: String?

    private lazy var webView: WKWebView = { [unowned self] in
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.backgroundColor = UIColor.white
        webView.autoresizingMask = UIView.AutoresizingMask(rawValue: 1|4)
        webView.isMultipleTouchEnabled = true
        webView.autoresizesSubviews = true
        webView.scrollView.alwaysBounceVertical = true
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    private lazy var progress: UIProgressView = {
        let progress = UIProgressView()
        progress.tintColor = UIColor.red
        progress.backgroundColor = UIColor.gray
        return progress
    }()
    
    private lazy var negativeSpacer: UIBarButtonItem = {
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -5
        return negativeSpacer
    }()
    
    private lazy var backBarButton: UIBarButtonItem = {
        let backBarButton = UIBarButtonItem(title: "‹", style: UIBarButtonItem.Style.done, target: self, action: #selector(goBackClicked))
        backBarButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40)], for: UIControl.State.normal)
        return backBarButton
    }()
    
    private lazy var closeBarButton: UIBarButtonItem = {
        let closeBarButton = UIBarButtonItem(title: "×", style: UIBarButtonItem.Style.done, target: self, action: #selector(closeClicked))
        closeBarButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40)], for: UIControl.State.normal)
        return closeBarButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(progress)
        addKVOObserver()
        loadWeb()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let items = [self.negativeSpacer,self.backBarButton]
        self.navigationItem.leftBarButtonItems = items
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        progress.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 2)
    }
    
    deinit {
        removeKVOObserver()
    }
}

extension DGWebViewController{
    
    private func loadWeb(){
        let request = URLRequest(url: URL(string: urlStr!)!)
        webView.load(request)
    }
    
    @objc private func goBackClicked(){
        if webView.canGoBack {
            webView.goBack()
        }else{
            navigationController?.popViewController(animated: false)
        }
    }
    
    @objc private func closeClicked(){
        navigationController?.popViewController(animated: false)
    }
}

extension DGWebViewController{
    private func addKVOObserver(){
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [NSKeyValueObservingOptions.new,NSKeyValueObservingOptions.old], context: nil)
        webView.addObserver(self, forKeyPath: "canGoBack", options:[NSKeyValueObservingOptions.new,NSKeyValueObservingOptions.old], context: nil)
    }
    
    private func removeKVOObserver(){
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "canGoBack")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progress.isHidden = webView.estimatedProgress >= 1
            progress.setProgress(Float(webView.estimatedProgress), animated: true)
            
        }else if keyPath == "canGoBack"{
            if webView.canGoBack == true{ //创建返回键 关闭键
                let items = [negativeSpacer, backBarButton, closeBarButton]
                navigationItem.leftBarButtonItems = items
            }else{
                let items = [negativeSpacer, backBarButton]
                navigationItem.leftBarButtonItems = items
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}

extension DGWebViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progress.setProgress(0, animated: false)
        navigationItem.title = title ?? (webView.title ?? webView.url?.host)
    }
}
