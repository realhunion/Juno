//
//  FeedCell.swift
//  Juno
//
//  Created by Hunain Ali on 5/18/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import UIKit
import WebKit
import SafariServices


class FeedCell: UICollectionViewCell {
    
    let HeightCallback = "heightCallback"
    let ClickCallback = "clickCallback"
    
    let TweetPadding: CGFloat = 20
    let HtmlTemplate = "<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head><body><div id='wrapper'></div></body></html>"
    
    var tweetID : String = "1190287688685047808"
    
    var webView : WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: CGRect.zero, configuration: config)
        
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        webView.clipsToBounds = true
        
        return webView
    }()
    
    var titleLabel : UILabel = {
        let height : CGFloat = 28.0
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        label.backgroundColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.text = "The Family Room"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var memberStackView : MembersStackView = {
        let height : CGFloat = 110.0
        let m = MembersStackView(frame: CGRect(x: 0, y: 0, width: 0, height: height),
                                 collectionViewLayout: UICollectionViewFlowLayout())
        m.backgroundColor = .black
        return m
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame.integral)
        
        self.clipsToBounds = true
        
        setupWebview()
        
        self.contentView.addSubview(titleLabel)
        titleLabel.frame.size.width = self.bounds.width
        
        self.contentView.addSubview(memberStackView)
        self.memberStackView.frame.size.width = self.bounds.width
        self.memberStackView.frame.size.height = 100.0 //110 to 100 FIX FUTURE
        self.memberStackView.frame.origin.y = titleLabel.bounds.height
        
        //        self.memberStackView.backgroundColor = .red
        //        self.titleLabel.backgroundColor = .purple
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.60).cgColor,
                           UIColor.black.withAlphaComponent(0.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        let v = UIView(frame: CGRect(x: 0, y: self.bounds.height*0.8, width: self.bounds.width, height: self.bounds.height*0.2))
        gradient.frame = v.bounds
        //        v.backgroundColor = .yellow
        v.layer.addSublayer(gradient)
        v.clipsToBounds = false
        self.contentView.insertSubview(v, aboveSubview: webView)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWebview() {
        
        self.contentView.insertSubview(webView, at: 0)
        webView.frame = CGRect(x: 0, y: 0, width: self.bounds.width-20, height: 0)
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.configuration.userContentController.add(self, name: ClickCallback)
        webView.configuration.userContentController.add(self, name: HeightCallback)
    }
    
    func loadWebview() {
        self.webView.isHidden = true
        
        self.webView.loadHTMLString(HtmlTemplate, baseURL: nil)
        
//        let myURL = URL(string: "https://www.youtube.com/embed/BY-aB72nONA?playsinline=1")
//        var youtubeRequest = URLRequest(url: myURL!)
//        webView.load(youtubeRequest)
        
    }
    
    private func adjustWebviewHeight(newHeight : CGFloat) {
        self.webView.frame.size.height = newHeight + TweetPadding
        
        self.webView.isHidden = false
        self.centerWebview()
        
        return
            
            print("tessir 1 \(newHeight)")
        if newHeight > 500 {
            print("tessir 2 \(webView.frame.size.width)")
            webView.frame.size.width = 400
            
            self.webView.evaluateJavaScript("document.getElementById('wrapper').offsetHeight.toString()") {
                (value, err) in
                guard let adjHeight = value as? String else { return }
                
                let intAdjHeight = (adjHeight as NSString).integerValue
                let cgAdjHeight = CGFloat(intAdjHeight)
                print("tessir 3 \(cgAdjHeight)")
                
                self.webView.frame.size.height = cgAdjHeight// - 40
                
                //                self.adjustWebviewHeight(newHeight: cgAdjHeight)
                
                self.centerWebview()
                
            }
            
            
            
        }
    }
    
    func centerWebview() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let reactBarMinY = self.contentView.bounds.height - ReactBar.shared.frame.height - window.safeAreaInsets.bottom
        
        let titleLabelMaxY = self.titleLabel.frame.maxY
        let memberStackMaxY = self.memberStackView.frame.maxY
        
        let webViewHeight = self.webView.frame.height
        
        
        if memberStackView.userArray.isEmpty {
            
            let diff = reactBarMinY - titleLabelMaxY
            let theY = (diff / 2) + titleLabelMaxY
            
            self.webView.center.y = theY
            
        } else {
            
            let availableHeight = reactBarMinY - memberStackMaxY
            
            if webViewHeight < availableHeight {
                
                let theY = (availableHeight / 2) + memberStackMaxY
                self.webView.center.y = theY
                
            } else {
                
                self.webView.frame.origin.y = memberStackMaxY + 10.0
                //                self.webView.frame.size.height = availableHeight - 22
            }
            
        }
        
        self.webView.center.x = self.contentView.center.x
        
    }
    
    
}


extension FeedCell: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case HeightCallback:
            let height = (message.body as! String)
            if let intHeight = Int(height) {
                let cgHeight = CGFloat(intHeight)
                self.adjustWebviewHeight(newHeight: cgHeight)
            }
        default:
            print("Unhandled callback")
        }
    }
    
}


extension FeedCell : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, navigationAction.navigationType == .linkActivated {
            openInSafarViewController(url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("bono loadTweet")
        loadTweetInWebView()
    }
    
    // Tweet Loader
    func loadTweetInWebView() {
        
        if let widgetsJsScript = WidgetsJsManager.shared.getScriptContent() {
            webView.evaluateJavaScript(widgetsJsScript)
            webView.evaluateJavaScript("twttr.widgets.load();")

            // Documentation:
            // https://developer.twitter.com/en/docs/twitter-for-websites/embedded-tweets/guides/embedded-tweet-javascript-factory-function
            webView.evaluateJavaScript("""
                twttr.widgets.createTweet(
                '\(self.tweetID)',
                document.getElementById('wrapper'),
                { align: 'center' }
                ).then(el => {
                window.webkit.messageHandlers.heightCallback.postMessage(el.offsetHeight.toString())
                });
                """)
        }
        //            , theme: 'dark'
    }
}

extension FeedCell : WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("cool 3")
        // Allow links with target="_blank" to open in SafariViewController
        //   (includes clicks on the background of Embedded Tweets
        if let url = navigationAction.request.url, navigationAction.targetFrame == nil {
            openInSafarViewController(url)
        }
        
        return nil
    }
    
    
    //Helpers
    
    
    func openInSafarViewController(_ url: URL) {
        let vc = SFSafariViewController(url: url)
        print("cool 1")
        if let topVC = UIApplication.topViewController() {
            print("cool 2")
            topVC.showDetailViewController(vc, sender: topVC)
        }
    }
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

