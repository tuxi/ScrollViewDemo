//
//  DefaultEmpatyView.swift
//  rebate
//
//  Created by xiaoyuan on 2020/3/3.
//  Copyright © 2020 寻宝天行. All rights reserved.
//

import UIKit

class DefaultEmpatyView: UIControl {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "icon_default_empty")
        imageView.contentMode = .scaleAspectFill;
        return imageView
    }()

    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 8.0
        button.layer.masksToBounds = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [imageView, detailLabel, button].forEach { (subview) in
            self.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0).isActive = true
        
        detailLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10.0).isActive = true
        detailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -80).isActive = true
        
        button.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 20.0).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30.0).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30.0).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0).isActive = true

    }
    
    func reload(isFailured: Bool) {
//        var isConnected = NetWorkUtils.shared.isConnected
        let isConnected = false
        if isConnected == true {
            if isFailured == true {
                self.button.isHidden = false
                self.button.setTitle("重新加载", for: .normal)
                self.detailLabel.text = "加载失败\n点击屏幕重新尝试"
            }
            else {
                self.button.isHidden = true
                self.detailLabel.text = "暂无数据"
            }
        }
        else {
            self.button.isHidden = false
            self.button.setTitle("前去设置", for: .normal)
            self.detailLabel.text = "网络未连接\n检查后点击屏幕重新尝试"
        }
    }
}
