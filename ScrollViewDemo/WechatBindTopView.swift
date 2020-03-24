//
// WechatBindTopView.swift
// rebate
//
// Created by xiaoyuan on 2020/3/24.
// Copyright © 2020 寻宝天行. All rights reserved.
//

import UIKit

class WechatBindTopView: UIView {

    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var topViewTop: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(self.imageView)
        
        imageView.image = UIImage(named: "icon_wechatbind_bg")
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        topViewTop = self.imageView.topAnchor.constraint(equalTo: self.topAnchor)
        topViewTop?.isActive = true
//        self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 750 / 544.0).isActive = true
    }
}
