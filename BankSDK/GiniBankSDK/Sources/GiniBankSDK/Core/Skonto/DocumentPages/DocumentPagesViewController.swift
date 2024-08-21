//
//  DocumentPagesViewController.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//

import GiniCaptureSDK
import UIKit

final class DocumentPagesViewController: UIViewController {
    private lazy var statusBarBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .GiniBank.dark1.withAlphaComponent(0.5)
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewItemSpacing
        return stackView
    }()

    private lazy var loadingIndicatorContainer: UIView = {
        let loadingIndicatorContainer = UIView(frame: CGRect.zero)
        return loadingIndicatorContainer
    }()

    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .whiteLarge
        return indicatorView
    }()

    private var viewModel: DocumentPagesViewModel?
    private let configuration = GiniBankConfiguration.shared

    // Constraints
    private var stackViewTopConstraint: NSLayoutConstraint?

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        startLoadingIndicatorAnimation()
    }

    func setData(viewModel: DocumentPagesViewModel) {
        self.viewModel = viewModel
        showProcessedImages()
    }

    // MARK: Toggle animation

    /// Start the loading activity indicator animation
    func startLoadingIndicatorAnimation() {
        if let loadingIndicator = configuration.customLoadingIndicator {
            loadingIndicator.startAnimation()
        } else {
            loadingIndicatorView.startAnimating()
        }
    }

    /// Stops the loading activity indicator
   func stopLoadingIndicatorAnimation() {
        if let loadingIndicator = configuration.customLoadingIndicator {
            loadingIndicator.stopAnimation()
        } else {
            loadingIndicatorView.stopAnimating()
        }
    }

    /**
     Set up the view elements on the screen
     */

    private func setupViews() {
        view.backgroundColor = .GiniCapture.dark1
        view.addSubview(scrollView)

        setupStatusBarBackground()

        setupNavigationBar()

        setupScrollView()
        scrollView.addSubview(contentStackView)
        configureLoadingIndicator()
    }

    private func setupStatusBarBackground() {
        view.addSubview(statusBarBackgroundView)

        NSLayoutConstraint.activate([
            statusBarBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBarBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBarBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    private func setupNavigationBar() {
        // Create and configure the navigation bar
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(navigationBar)

        // Create a navigation item with a title and a cancel button
        let screenTitle = NSLocalizedStringPreferredGiniBankFormat("ginibank.skonto.document.pages.screen.title",
                                                                   comment: "Skonto discount details")
        let navigationItem = UINavigationItem(title: screenTitle)
        // Add the Cancel button
        let cancelButton = GiniBarButton(ofType: .cancel)
        cancelButton.addAction(self, #selector(didTapClose))
        navigationItem.leftBarButtonItem = cancelButton.barButton

        // Apply title text attributes
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        // Assign the navigation item to the navigation bar
        navigationBar.setItems([navigationItem], animated: false)

        // Set constraints for the navigation bar
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: Constants.defaultNavigationBarHeight)
        ])
    }

    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = Constants.minimumZoomScale
        scrollView.maximumZoomScale = Constants.maximumZoomScale
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        let doubleTapRecognizer = UITapGestureRecognizer(target: self,
                                                         action: #selector(didRecognizeDoubleTap))
        doubleTapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapRecognizer)

    }

    private func setupLayout() {
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Stack view
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                               constant: Constants.containerHorizontalPadding),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                constant: -Constants.containerHorizontalPadding),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,
                                              constant: -Constants.stackViewBottomPadding),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor,
                                             constant: -2 * Constants.containerHorizontalPadding)

        ])

        let stackViewTopConstraintConstant = Constants.stackViewTopConstraintToNavBar
        stackViewTopConstraint = contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor,
                                                                constant: stackViewTopConstraintConstant)
        stackViewTopConstraint?.isActive = true
    }

    // MARK: - Handle Loading indicator
    private func configureLoadingIndicator() {
        loadingIndicatorView.color = GiniColor(light: .GiniCapture.light1,
                                               dark: .GiniCapture.dark1).uiColor()

        addLoadingContainer()
        addLoadingView(intoContainer: loadingIndicatorContainer)
    }

    private func addLoadingView(intoContainer container: UIView) {
        let loadingIndicator = configuration.customLoadingIndicator?.injectedView() ?? loadingIndicatorView
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(container)
        container.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.heightAnchor.constraint(equalToConstant: Constants.loadingIndicatorContainerHeight),
            container.widthAnchor.constraint(equalTo: container.heightAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }

    private func addLoadingContainer() {
        loadingIndicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicatorContainer)
        NSLayoutConstraint.activate([
            loadingIndicatorContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicatorContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicatorContainer.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            loadingIndicatorContainer.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor,
                                                               constant: Constants.padding)])
    }

    // MARK: Private methods

    private func showProcessedImages() {
        guard let viewModel else { return }
        let images = viewModel.processImages()

        for image in images {
            // Create a container view for the image view
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false

            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(imageView)

            // Constrain image view within its container view
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            contentStackView.addArrangedSubview(containerView)

            // Apply the dynamic height constraint just for iPhones
            if !UIDevice.current.isIpad {
                let imageViewHeight = UIScreen.main.bounds.height * 0.65
                imageView.heightAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
            }
            imageView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
        }

        adjustStackViewTopConstraint(for: images.count)

        adjustContentSize()
    }

    // MARK: - Utilities

    private func adjustContentSize() {
        var contentHeight: CGFloat = 0

        // Calculate the total height of the stackView content
        for view in contentStackView.arrangedSubviews {
            contentHeight += view.frame.size.height
        }

        // Update the scrollView contentSize
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width,
                                        height: max(contentHeight, scrollView.frame.size.height))

        adjustContentToCenter()
    }

    private func adjustContentToCenter() {
        let scrollViewSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize

        let verticalInset = max(0, (scrollViewSize.height - contentSize.height) / 2)
        let horizontalInset = max(0, (scrollViewSize.width - contentSize.width) / 2)

        scrollView.contentInset = UIEdgeInsets(top: verticalInset,
                                               left: horizontalInset,
                                               bottom: verticalInset,
                                               right: horizontalInset)
    }

    private func adjustStackViewTopConstraint() {
        let isZoomedOut = scrollView.zoomScale == Constants.minimumZoomScale
        stackViewTopConstraint?.constant = isZoomedOut
        ? Constants.navigationBarHeight + Constants.stackViewTopConstraintToNavBar
        : Constants.stackViewTopConstraintToNavBar
    }

    private func adjustStackViewTopConstraint(for imageCount: Int) {
        stackViewTopConstraint?.constant = imageCount == 1
        ? Constants.navigationBarHeight + Constants.stackViewTopConstraintToNavBar
        : Constants.stackViewTopConstraintToNavBar
    }

    // MARK: - Actions

    @objc private func didRecognizeDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let shouldZoomOut = scrollView.zoomScale != Constants.minimumZoomScale
        if shouldZoomOut {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            let tapPoint = gestureRecognizer.location(in: contentStackView)
            let newZoomScale = scrollView.maximumZoomScale
            let zoomedRectSize = CGSize(width: scrollView.bounds.size.width / newZoomScale,
                                        height: scrollView.bounds.size.height / newZoomScale)
            let zoomedRectOrigin = CGPoint(x: tapPoint.x - zoomedRectSize.width / 2,
                                           y: tapPoint.y - zoomedRectSize.height / 2)
            let rectToZoom = CGRect(origin: zoomedRectOrigin, size: zoomedRectSize)
            scrollView.zoom(to: rectToZoom, animated: true)
        }
    }

    @objc private func didTapClose() {
        dismiss(animated: true)
    }
}

extension DocumentPagesViewController: UIScrollViewDelegate {
    // Delegate method to specify the view to zoom
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentStackView
    }

    // UIScrollViewDelegate method to handle zooming
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustContentToCenter()
        adjustStackViewTopConstraint()
    }
}

private extension DocumentPagesViewController {
    enum Constants {
        static let padding: CGFloat = 24
        static let spacing: CGFloat = 36
        static let stackViewItemSpacing: CGFloat = 4
        static let containerHorizontalPadding: CGFloat = UIDevice.current.isIpad ? 31 : 4
        static let loadingIndicatorContainerHeight: CGFloat = 60
        static let navigationBarHeight: CGFloat = 90
        static let stackViewTopConstraintToNavBar: CGFloat = UIDevice.current.isIpad ? 0 : 56
        static let stackViewBottomPadding: CGFloat = 50
        static let minimumZoomScale: CGFloat = 1.0
        static let maximumZoomScale: CGFloat = 2.0
        static let defaultNavigationBarHeight: CGFloat = 44
    }
}
