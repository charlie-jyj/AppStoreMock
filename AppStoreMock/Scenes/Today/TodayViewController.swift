//
//  TodayViewController.swift
//  AppStoreMock
//
//  Created by UAPMobile on 2022/02/04.
//

import SnapKit
import UIKit

class TodayViewController: UICollectionViewController {
    private var todayList: [Today] = [Today]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        fetchData()
    }
}

// Datasource
extension TodayViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        todayList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCollectionViewCell", for: indexPath) as? TodayCollectionViewCell else { return UICollectionViewCell()}
        cell.setupSubviews(today: todayList[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
            let reusableView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "TodayCollectionHeaderView",
                for: indexPath) as? TodayCollectionHeaderView else { return UICollectionReusableView() }
        reusableView.setupSubviews()
        return reusableView
    }
}

// DelegateFlowLayout
extension TodayViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // detail
        print("show detail: \(todayList[indexPath.row])")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGFloat = collectionView.frame.width - 32.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32.0, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 16.0
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    
}

private extension TodayViewController {
    func configCollectionView() {
        // collection view layout 설정
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.frame = .zero
        
        // collection view header, cell register
        collectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: "TodayCollectionViewCell")
        collectionView.register(TodayCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TodayCollectionHeaderView")
        
        // 기타
        collectionView.backgroundColor = .systemBackground
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func fetchData() {
        // plist 에서 collection view 를 만들 data 가져오기
        guard let path = Bundle.main.path(forResource: "Today", ofType: "plist"),
              let pfile = FileManager.default.contents(atPath: path),
              let data = try? PropertyListDecoder().decode([Today].self, from: pfile) else { return }
        
        todayList = data
    }
}
