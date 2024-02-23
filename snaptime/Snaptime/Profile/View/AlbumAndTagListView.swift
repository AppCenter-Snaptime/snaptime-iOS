//
//  AlbumAndTagListView.swift
//  Snaptime
//
//  Created by Bowon Han on 2/23/24.
//

import UIKit
import SnapKit

/// 프로필 내부 album, tag list tabButton 과 각각 화면을 나타내는 View
final class AlbumAndTagListView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayouts()
        self.setupConstraints()
        
        self.listScrollView.delegate = self
        self.tabAlbumButton()
        self.tabTagButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tabButtonStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var albumTabButton = ProfileTabListButton("앨범 목록")
    private lazy var tagTabButton = ProfileTabListButton("태그 목록")
        
    private let indicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    private var listScrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        
        return scrollView
    }()
    
    private let tagListView = TagListView()
    private let albumListView = AlbumListView()
    
    private let contentView = UIView()
    
    // MARK: - 메서드
    /// albumList와 tagList button 을 클릭했을때 indicator 바와 아래 scrollView가 scroll되도록하는 메서드
    private func tabAlbumButton() {
        let scrollViewWidth = UIScreen.main.bounds.width

        albumTabButton.tabButtonAction = { [weak self] in
            self?.indicatorView.snp.remakeConstraints {
                $0.top.equalTo((self?.tabButtonStackView.snp.bottom)!)
                $0.height.equalTo(2)
                $0.width.equalTo(scrollViewWidth/6)
                $0.centerX.equalTo(scrollViewWidth/4)
            }

            UIView.animate(
                withDuration: 0.4,
                animations: { self?.layoutIfNeeded() }
            )
            self?.listScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }

    private func tabTagButton() {
        let scrollViewWidth = UIScreen.main.bounds.width

        tagTabButton.tabButtonAction = { [weak self] in
            self?.indicatorView.snp.remakeConstraints {
                $0.top.equalTo((self?.tabButtonStackView.snp.bottom)!)
                $0.height.equalTo(2)
                $0.width.equalTo(scrollViewWidth/6)
                $0.centerX.equalTo(scrollViewWidth*3/4)
            }

            UIView.animate(
                withDuration: 0.4,
                animations: { self?.layoutIfNeeded() }
            )

            self?.listScrollView.setContentOffset(CGPoint(x: scrollViewWidth, y: 0), animated: true)
        }
    }
    
    // MARK: - setup UI
    private func setupLayouts() {
        [albumTabButton,
         tagTabButton].forEach {
            tabButtonStackView.addArrangedSubview($0)
        }
        
        [albumListView,
         tagListView].forEach {
            contentView.addSubview($0)
        }
        
        listScrollView.addSubview(contentView)
        
       [tabButtonStackView,
        indicatorView,
        listScrollView].forEach {
           addSubview($0)
       }
    }
    
    private func setupConstraints() {
        tabButtonStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        let scrollViewWidth = UIScreen.main.bounds.width

        indicatorView.snp.makeConstraints {
            $0.top.equalTo(tabButtonStackView.snp.bottom)
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
extension AlbumAndTagListView : UIScrollViewDelegate {
    
    /// scrollView 스크롤 시 indicator 바가 함께 움직이도록 하는 메서드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = UIScreen.main.bounds.width
        let offsetX = scrollView.contentOffset.x
        
        self.indicatorView.snp.remakeConstraints {
            $0.top.equalTo(self.tabButtonStackView.snp.bottom)
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
