//
//  MD_MessageVC.swift
//  MassageDT
//  
//  Created by wealon on 2024.
//  MassageDT.
//  
    

import UIKit
import WebKit

class MD_MessageVC: BaseViewController {
    lazy var wkWebView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        configuration.userContentController = userContentController
        configuration.userContentController.add(self, name: "startFunction")
        configuration.userContentController.add(self, name: "anotherFunction") // 添加额外的消息处理函数
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        return webView
    }()
    var isHidenBack = true {
        didSet {
            self.backButton.isHidden = isHidenBack
            BaseTabBarControllerView.tab.tabBar.isHidden = !isHidenBack
        }
    }
    var urlString: String = ""
    init() {
        super.init(nibName: nil, bundle: nil)
        layoutUIView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "消息"
        self.urlString = glaModel?.chat_url ?? ""
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.urlString.count == 0 {
            self.urlString = glaModel?.chat_url ?? ""
            if let url = URL(string: glaModel?.chat_url ?? "") {
                var request = URLRequest(url: url)
                request.addValue("image/webp", forHTTPHeaderField: "Accept")
                // 加载网页
                self.wkWebView.load(request)
            }
        }
        wkWebView.reload()
    }
    func layoutUIView() {
        self.view.addSubview(self.wkWebView)
        wkWebView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    override func initializeUIInfo() {
        super.initializeUIInfo()
        self.setBackButton()
        self.backButton.isHidden = true
       
    }
//    func loadURL() {
//        if let url = URL(string: glaModel?.chat_url ?? "") {
//            var request = URLRequest(url: url)
//            request.addValue("image/webp", forHTTPHeaderField: "Accept")
//            // 加载网页
//            self.wkWebView.load(request)
//        }
//    }
    
    override func backButtonClick() {
        if self.wkWebView.canGoBack {
            self.wkWebView.goBack()
        }
    }
    
    
}

extension MD_MessageVC: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let name = message.name
        let body = message.body as? [String: Any]
        debugPrint("name = \(name)")
        debugPrint("body = \(String(describing: body))")
        let isBack = self.wkWebView.backForwardList.backList.count == 0
        self.isHidenBack = !self.wkWebView.canGoBack && isBack
        if name == "startFunction" {
            JSInteraction.jumpToVC(self, body: body)
        }
    }
}

extension MD_MessageVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载网页")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("网页加载完成")
        let isBack = webView.backForwardList.backList.count == 0
        self.isHidenBack = !webView.canGoBack && isBack
        if let title = webView.title {
            self.title = title.count > 0 ? title: "消息"
        }
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
    }
    // 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let urlStr = navigationResponse.response.url?.absoluteString
        debugPrint("当前跳转地址：\(String(describing: urlStr))")
        decisionHandler(.allow)
    }
}
