//
//  ProtocolPolicyVC.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/19.
//

import UIKit
import WebKit

class ProtocolPolicyVC: BaseViewController {
    lazy var wkWebView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        // 设置 WKWebView 的导航代理
        webView.navigationDelegate = self
        return webView
    }()
    var urlStr: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initializeUIInfo() {
        super.initializeUIInfo()
        view.addSubview(self.wkWebView)
        wkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 创建一个 URL 对象，加载网页
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            wkWebView.load(request)
        }
    }
}

extension ProtocolPolicyVC: WKNavigationDelegate {
    // 添加 WKNavigationDelegate 方法，以处理页面加载过程中的事件
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // 网页开始加载时的处理
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // 网页加载完成时的处理
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            // 网页加载失败时的处理
        }
}
