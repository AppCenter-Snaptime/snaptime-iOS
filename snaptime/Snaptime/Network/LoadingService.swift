//
//  LoadingIndicator.swift
//  Snaptime
//
//  Created by Bowon Han on 8/10/24.
//

import UIKit

class LoadingService {
    static func showLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .flatMap({ $0.windows })
                    .last else { return }

            let loadingIndicatorView: UIActivityIndicatorView
            /// 최상단에 이미 IndicatorView가 있는 경우 그대로 사용.
            if let existedView = window.subviews.first(
                where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                /// 다른 UI를 클릭하는 것 방지.
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.color = .gray

                window.addSubview(loadingIndicatorView)
            }
            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .flatMap({ $0.windows })
                    .last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView })
                .forEach { $0.removeFromSuperview() }
        }
    }
}
