//
//  AlbumAndTagListView.swift
//  Snaptime
//
//  Created by Bowon Han on 2/23/24.
//

import UIKit
import SnapKit

/// 프로필 내부 album, tag list tabButton 과 각각 화면을 나타내는 View
final class TopTapBarView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
        self.setupConstraints()
        
        self.listScrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tapBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TopTapBarCollectionViewCell.self, forCellWithReuseIdentifier: TopTapBarCollectionViewCell.identifier)
        
        return collectionView
    }()
        
    private lazy var indicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    private lazy var listScrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        
        return scrollView
    }()
    
    private lazy var tagListView = TagListView()
    private lazy var albumListView = AlbumListView()
    
    private lazy var contentView = UIView()
    
    // MARK: - setup UI
    private func setupLayouts() {
        [albumListView,
         tagListView].forEach {
            contentView.addSubview($0)
        }
        
        listScrollView.addSubview(contentView)
        
       [tapBarCollectionView,
        indicatorView,
        listScrollView].forEach {
           addSubview($0)
       }
    }
    
    private func setupConstraints() {
        tapBarCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        let scrollViewWidth = UIScreen.main.bounds.width

        indicatorView.snp.makeConstraints {
            $0.top.equalTo(tapBarCollectionView.snp.bottom)
            $0.height.equalTo(2)
            $0.centerX.equalTo(scrollViewWidth/4)
            $0.width.equalTo(scrollViewWidth/6)
        }
        
        listScrollView.snp.makeConstraints {
            $0.top.equalTo(indicatorView.snp.bottom).offset(1)
            $0.left.right.bottom.equalToSuperview()
        }
                        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(listScrollView.contentLayoutGuide)
            $0.height.equalTo(listScrollView.frameLayoutGuide)
            $0.width.equalTo(scrollViewWidth*2)
        }
        
        albumListView.snp.makeConstraints {
            $0.top.left.bottom.equalTo(contentView)
            $0.width.equalTo(scrollViewWidth)
        }
        
        tagListView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.left.equalTo(albumListView.snp.right)
            $0.width.equalTo(scrollViewWidth)
        }
    }
}

// MARK: - extension
extension TopTapBarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tapBarCollectionView.dequeueReusableCell(
            withReuseIdentifier: TopTapBarCollectionViewCell.identifier,
            for: indexPath
        ) as? TopTapBarCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configTitle("앨범목록")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tapBarCollectionView {
            guard let cell = tapBarCollectionView.cellForItem(at: indexPath) as? TopTapBarCollectionViewCell else { return }
            
            let width = collectionView.bounds.width
            let scrollViewStart = width * CGFloat(indexPath.row)
            
            self.indicatorView.snp.remakeConstraints {
                $0.top.equalTo(self.tapBarCollectionView.snp.bottom)
                $0.height.equalTo(2)
                $0.centerX.equalTo(cell.snp.centerX)
                $0.width.equalTo(width/6)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
                self.listScrollView.setContentOffset(CGPoint(x: scrollViewStart, y: 0), animated: false)
            }
        }
    }
}
    
extension TopTapBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 10
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: 35)
    }
}

extension TopTapBarView: UIScrollViewDelegate {
    
    /// scrollView 스크롤 시 indicator 바가 함께 움직이도록 하는 메서드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = UIScreen.main.bounds.width
        let offsetX = scrollView.contentOffset.x
        
        self.indicatorView.snp.remakeConstraints {
            $0.top.equalTo(self.tapBarCollectionView.snp.bottom)
            $0.height.equalTo(2)
            $0.centerX.equalTo(offsetX/2 + width/4)
            $0.width.equalTo(width/6)
        }
        
        UIView.animate(
            withDuration: 0.1,
            animations: { self.layoutIfNeeded() }
        )
    }
}

