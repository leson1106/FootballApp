//
//  LoadingIndicatorPresentable.swift
//  FootBallApp
//
//  Created by Son Le on 19/01/2024.
//

import UIKit
import SnapKit

protocol LoadingIndicatorPresentable: AnyObject {
    var loadingView: UIActivityIndicatorView? { get set }
    func showActivityIndicator()
    func hideActivityIndicator()
}

extension LoadingIndicatorPresentable {
    func createLoadingView() -> UIActivityIndicatorView {
        let _loadingView = loadingView ?? {
            let loadingView = UIActivityIndicatorView()

            defer {
                self.loadingView = loadingView
            }

            return loadingView
        }()

        _loadingView.color = .black
        _loadingView.hidesWhenStopped = true
        return _loadingView
    }
}

extension LoadingIndicatorPresentable where Self: UIViewController {
    func showActivityIndicator() {
        let loadingView = createLoadingView()
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        loadingView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50).priority(.medium)
        }
        loadingView.startAnimating()
    }

    func hideActivityIndicator() {
        loadingView?.stopAnimating()
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
