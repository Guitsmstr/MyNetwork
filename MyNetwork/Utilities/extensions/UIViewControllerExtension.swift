//
//  UIViewControllerExtension.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//


import UIKit

extension UIViewController {
    func showHideLoadingView(_ isVisible: Bool, withMessage message: String = "Loading") {
        if isVisible {
            showLoadingView(withMessage: message)
        } else {
            hideLoadingView()
        }
    }
    
    private func showLoadingView(withMessage message: String = "loading") {
        let containerView = UIView(frame: view.bounds)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        containerView.tag = 100
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        containerView.addSubview(activityIndicator)
        
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        containerView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(containerView)
    }
    
    private func hideLoadingView() {
        if let containerView = view.viewWithTag(100) {
            containerView.removeFromSuperview()
        }
    }
}
