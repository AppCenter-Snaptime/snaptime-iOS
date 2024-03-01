//
//  SettingTableViewCEll.swift
//  Snaptime
//
//  Created by Bowon Han on 2/28/24.
//

import UIKit
import SnapKit

final class SettingTableViewCell: UITableViewCell {
    private lazy var settingTitleLabel : UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func configSettingTitle(_ title: String) {
        settingTitleLabel.text = title
    }
    
    private func setLayout(){
        contentView.addSubview(settingTitleLabel)
        
        settingTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
        }
    }
}
