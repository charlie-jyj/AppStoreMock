//
//  ExchangeCodeButtonView.swift
//  AppStoreMock
//
//  Created by UAPMobile on 2022/02/07.
//

import UIKit

class ExchangeCodeButtonView: UIView {
    private lazy var exchangeCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("코드 교환", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.layer.cornerRadius = 7.0
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 하나의 컴포넌트이기 때문에 따로 private method로 빼지 않았다.
        addSubview(exchangeCodeButton)
        exchangeCodeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32.0)
            $0.bottom.equalToSuperview().offset(32.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(40.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
