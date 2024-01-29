//
//  LeisureDetailsVC.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/26.
//

import UIKit
import WebKit

class LeisureDetailsVC: BaseViewController {
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
    let url: String
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func initializeUIInfo() {
        super.initializeUIInfo()
        self.setBackButton()
        self.backButton.isHidden = true
        self.view.addSubview(self.wkWebView)
        wkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if let url = URL(string: self.url) {
            var request = URLRequest(url: url)
            request.addValue("image/webp", forHTTPHeaderField: "Accept")
            // 加载网页
            self.wkWebView.load(request)
        }
    }
    
}

extension LeisureDetailsVC: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let name = message.name
        let body = message.body as? [String: Any]
        if name == "startFunction" {
            JSInteraction.jumpToVC(self, body: body)
        }
    }
}

extension LeisureDetailsVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let title = webView.title {
            self.title = title.count > 0 ? title: ""
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
