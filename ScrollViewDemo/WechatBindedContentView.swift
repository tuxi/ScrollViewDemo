//
// WechatBindedContentView.swift
// rebate
//
// Created by xiaoyuan on 2020/3/24.
// Copyright © 2020 寻宝天行. All rights reserved.
//

import UIKit

/// r g b a color
func RGBA(_ red: CGFloat = 255.0, _ green: CGFloat = 255.0, _ blue: CGFloat = 255.0, _ alpha: CGFloat = 1) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}
func RGB(_ red: CGFloat = 255.0, _ green: CGFloat = 255.0, _ blue: CGFloat = 255.0) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
}
func rgb(_ red: CGFloat = 255.0, _ green: CGFloat = 255.0, _ blue: CGFloat = 255.0) -> UIColor {
    return RGB(red, green, blue)
}


class WechatBindedContentView: UIView {
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    lazy var wechatNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = rgb(153,153,153)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    
    lazy var okBtn: GradientLayerButton = {
        let btn = GradientLayerButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        return btn
    }()

    var clickChangeBindBlock: ((_ btn: UIButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [wechatNameLabel, subTitleLabel, okBtn, wechatNameLabel].forEach { (subview) in
            self.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        subTitleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        subTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        subTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10.0).isActive = true
        subTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 10.0).isActive = true
        
        let okBtnHeight: CGFloat = 47.0
        okBtn.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 16.0).isActive = true
        okBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12.0).isActive = true
        okBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12.0).isActive = true
        okBtn.heightAnchor.constraint(equalToConstant: okBtnHeight).isActive = true
        
        wechatNameLabel.topAnchor.constraint(equalTo: okBtn.bottomAnchor, constant: 15.0).isActive = true
        wechatNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        wechatNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10.0).isActive = true
        wechatNameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 10.0).isActive = true
        wechatNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30.0).isActive = true
        
        subTitleLabel.text = "以上特权均可以第一时间享受"
        subTitleLabel.textColor = rgb(41,41,41)
        subTitleLabel.font = UIFont.systemFont(ofSize: 12.0)
        
        

        okBtn.layer.cornerRadius = okBtnHeight * 0.5
        okBtn.setTitle("换绑", for: .normal)
        okBtn.addTarget(self, action: #selector(clickOkBtn), for: .touchUpInside)

        if let gradientLayer = okBtn.layer as? CAGradientLayer {
            gradientLayer.cornerRadius = 23.5
            gradientLayer.colors = [
                UIColor(red: 65.0 / 255.0, green: 72.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0).cgColor,
                UIColor(red: 84.0 / 255.0, green: 91.0 / 255.0, blue: 124.0 / 255.0, alpha: 1.0).cgColor,
                UIColor(red: 102.0 / 255.0, green: 110.0 / 255.0, blue: 147.0 / 255.0, alpha: 1.0).cgColor]
            gradientLayer.locations = [0, 1, 1]
            gradientLayer.startPoint = CGPoint(x: 1, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }
        
    }
    
    @objc private func clickOkBtn() {
        if let block = self.clickChangeBindBlock {
            block(self.okBtn)
        }
    }
}
