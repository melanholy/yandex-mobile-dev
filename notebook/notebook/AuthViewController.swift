//
//  AuthViewController.swift
//  notebook
//
//  Created by Павел Кошара on 15/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

private let appClientId = "40be302e95bb4a84ae22bd4b8aabbc0f"

class AuthViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let authUrl = URL(string: "https://oauth.yandex.ru/authorize?response_type=token&client_id=\(appClientId)") else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        var authRequest = URLRequest(url: authUrl)
        authRequest.httpMethod = "POST"
        
        let webView = UIWebView(frame: view.frame)
        webView.loadRequest(authRequest)
        view.addSubview(webView)
    }
}
