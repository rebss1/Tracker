//
//  PageViewController.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.09.2024.
//

import Foundation
import UIKit

final class PageViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var pageExample: PageExamples
    var tapHandler: (() -> Void)?
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.text = pageExample.buttonTitle
        label.numberOfLines = PageExamples.allCases.count
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView(image: pageExample.backgroundImage)
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.currentPage = pageExample.rawValue
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypBlack.withAlphaComponent(0.3)
        return pageControl
    }()
    
    private lazy var doneButton = Button(
        title: "This is technology!",
        style: .normal,
        color: .ypBlack
    ) {
        self.tapHandler?()
    }
    
    // MARK: - Initializers
    
    init(with pageExample: PageExamples,
         _ tapHandler: (() -> Void)?)
    {
        self.pageExample = pageExample
        self.tapHandler = tapHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: - Configure
    
    private func setUp() {
        view.addSubviews([imageView,
                          titleLabel,
                          pageControl,
                          doneButton])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            pageControl.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -16),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}
