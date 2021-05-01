//
//  InProgressView.swift
//  CCCalculator
//
//  Created by Amr Hesham on 01/05/2021.
//

import UIKit

/// Configurable UI properties for `InProgressView`.
///
struct InProgressViewProperties {
    let title: String?
    let message: String?
    let style: UIBlurEffect.Style?
    
    init(title: String? = nil, message: String? = nil, style: UIBlurEffect.Style?) {
        self.title = title
        self.message = message
        self.style = style
    }
}

/// Used to indicate a task is in progress and prevent other user interactions.
///
final class InProgressView: UIView {
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var backgroundVisualEffectView: UIVisualEffectView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    private let viewProperties: InProgressViewProperties
    
    init(viewProperties: InProgressViewProperties) {
        self.viewProperties = viewProperties
        super.init(frame: .zero)
        
        addAndFixContentView()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        configureBackgroundView()
        configureContentView()
        configureStackView()
        configureTitle()
        configureActivityIndicator()
        configureMessage()
        
        activityIndicatorView.startAnimating()
    }
}

// MARK: - Helpers
//
private extension InProgressView {
    
    func addAndFixContentView() {
        Bundle.main.loadNibNamed(String(describing: InProgressView.self), owner: self, options: nil)
        addSubview(parentView)
        parentView.frame = bounds
        parentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configureBackgroundView() {
        backgroundColor = .clear
        
        if let style = viewProperties.style {
            let blurEffect = UIBlurEffect(style: style)
            backgroundVisualEffectView.effect = blurEffect
            backgroundVisualEffectView.alpha = 0.7
        } else {
            backgroundVisualEffectView.isHidden = true
            isUserInteractionEnabled = false
        }
    }
    
    func configureContentView() {
        contentView.alpha = 0.9
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    func configureStackView() {
        contentStackView.alignment = .center
        contentStackView.spacing = 24
    }
    
    func configureTitle() {
        //        titleLabel.applyHeadlineStyle()
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        titleLabel.text = viewProperties.title
    }
    
    func configureActivityIndicator() {
        if #available(iOS 13.0, *) {
            activityIndicatorView.style = .medium
        } else {
            activityIndicatorView.style = .gray
        }
        //        activityIndicatorView.color = .gray(.shade10)
    }
    
    func configureMessage() {
        //        messageLabel.applyFootnoteStyle()
        //        messageLabel.textColor = .gray(.shade10)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        messageLabel.text = viewProperties.message
    }
}

// MARK: - Animations
//
extension InProgressView {
    
    func animateIfPossible(_ animated: Bool) {
        if animated {
            fade(fromValue: 0.5, toValue: 1.0)
            contentView.scaleToIdentity(fromValue: 0.6)
        }
    }
    
    func deinimateIfPossible(_ animated: Bool, onCompletion: @escaping (() -> Void)) {
        if animated {
            contentView.scaleFromIdentity(toValue: 0.6)
            fade(fromValue: 1.0, toValue: 0, onCompletion: onCompletion)
        }
    }
}

// MARK: - Static Helpers
//
extension InProgressView {
    
    static func showAdded(
        to view: UIView,
        properties: InProgressViewProperties,
        animated: Bool = true
    ) {
        guard progressViews(in: view).isEmpty else { return }
        let progressView = InProgressView(viewProperties: properties)
        view.addSubview(progressView)
        progressView.frame = view.bounds
        progressView.animateIfPossible(animated)
    }
    
    static func hide(
        for view: UIView,
        animated: Bool = true
    ) {
        progressViews(in: view).forEach { subview in
            subview.deinimateIfPossible(animated) {
                subview.removeFromSuperview()
            }
        }
    }
    
    private static func progressViews(in view: UIView) -> [InProgressView] {
        return view.subviews.compactMap { subview in
            return subview as? InProgressView
        }
    }
}

// MARK: - UIView+Animation Helpers
//
private extension UIView {
    
    func fade(fromValue: CGFloat, toValue: CGFloat, onCompletion: (() -> Void)? = nil) {
        alpha = fromValue
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = toValue
        }, completion: { _ in
            onCompletion?()
        })
    }

    func scaleToIdentity(fromValue: CGFloat) {
        self.transform = CGAffineTransform(scaleX: fromValue, y: fromValue)
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: { _ in })
    }
    
    func scaleFromIdentity(toValue: CGFloat) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: toValue, y: toValue)
        }, completion: { _ in })
    }
}
