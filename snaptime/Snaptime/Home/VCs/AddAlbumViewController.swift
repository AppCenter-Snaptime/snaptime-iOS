//
//  AddAlbumViewController.swift
//  Snaptime
//
//  Created by 이대현 on 2/28/24.
//

import SnapKit
import UIKit

protocol AddAlbumViewControllerDelegate: AnyObject {
    func didFinishAddAlbum()
}

final class AddAlbumViewController: UIViewController {
    private lazy var QRReaderView: QRReaderView = {
        let readerView = Snaptime.QRReaderView()
        readerView.delegate = self
        return readerView
    }()
    
    weak var delegate: AddAlbumViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        setupConstraints()
    }
    
    private func setupLayouts() {
        self.view.backgroundColor = .systemBackground
        [
            QRReaderView
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        QRReaderView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension AddAlbumViewController: ReaderViewDelegate {
    func readerComplete(status: ReaderStatus) {
        delegate?.didFinishAddAlbum()
    }
}
