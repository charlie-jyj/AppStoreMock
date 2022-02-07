//
//  AppViewController.swift
//  AppStoreMock
//
//  Created by UAPMobile on 2022/02/04.
//

import UIKit
import SnapKit

final class AppViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0.0
        
        let feature1 = FeatureSectionView(frame: .zero)
        let feature2 = RankingFeatureSection(frame: .zero)
        let feature3 = ExchangeCodeButtonView(frame: .zero)
        
        // 스크롤의 여유 공간을 주기 위한 spacing
        let spacingView = UIView()
        spacingView.snp.makeConstraints {
            $0.height.equalTo(100.0)
        }
        
        [
            feature1,
            feature2,
            feature3,
            spacingView
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationContoller()
        setupLayout()
    }
}

private extension AppViewController {
    func setupNavigationContoller() {
        navigationItem.title = "앱 스토어"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()  // vertical 스크롤이 되도록
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
