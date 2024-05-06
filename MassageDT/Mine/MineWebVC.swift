//
//  MineWebVC.swift
//  MassageDT
//  
//  Created by wealon on 2024.
//  MassageDT.
//  
    

import UIKit
import WebKit

class MineWebVC: BaseViewController {
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        configuration.userContentController = userContentController
        configuration.userContentController.add(self, name: "startFunction")
        configuration.userContentController = userContentController
        let webView = WKWebView(frame: CGRectZero, configuration: configuration)
        webView.navigationDelegate = self
        return webView
    }()
    
    var urlString: String? {
        didSet{
            if let url = URL(string: urlString ?? "") {
                var request = URLRequest(url: url)
                // 加载网页
                self.webView.load(request)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MineWebVC: UIScrollViewDelegate {
}

extension MineWebVC: WKNavigationDelegate, WKScriptMessageHandler  {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "startFunction" {
            if let dict = message.body as? [String: Any] {
                let type = Int(dict["type"] as? String ?? "0") ?? 0
                if type == 5 {
                    let url_str = dict["url"] as? String ?? ""
                    if let url = URL(string: url_str) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                
            }
        }
    }
}
