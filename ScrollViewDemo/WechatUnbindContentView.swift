//
// WechatUnbindContentView.swift
// rebate
//
// Created by xiaoyuan on 2020/3/24.
// Copyright © 2020 寻宝天行. All rights reserved.
//

import UIKit

class GradientLayerButton: UIButton {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

class WechatUnbindContentView: UIView {

    lazy var bindMethodLabel: UILabel = {
        let label = UILabel()
//        let label = YYLabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var verificationCodeTF: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.contentVerticalAlignment = .center
        textField.contentHorizontalAlignment = .left
        textField.borderStyle = .roundedRect
//        textField.placeholder = "通过微信小助手获取"
        textField.keyboardType = .alphabet
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var verificationCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = rgb(41,41,41)
        return label
    }()
    
    lazy var okBtn: GradientLayerButton = {
        let btn = GradientLayerButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        return btn
    }()
    
    var clickBindBlock: ((_ btn: UIButton) -> Void)?
    
    var bindMethodLabelHeight: NSLayoutConstraint?
    
    // 客服的微信名
    var customerWxName: String? {
        didSet {
            let attM = NSMutableAttributedString()
            
            let customerName = "“喜乐生活助手”"
            //设置以字符为单位的换行和行高 间距 字号 颜色
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.lineSpacing = 2.0
        
            let copyStr = " 复制 "
            let customerWxName = self.customerWxName ?? "mintPure"
            attM.append(NSAttributedString(string: "1.已有“喜乐生活助手”微信好友，直接发送“验证码”获取。\n2.没有，搜索微信号“\(customerWxName)”\(copyStr)，添加好友发送“验证码”获取。\n3.将小助手发送给您的验证码填回来，完成绑定。", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0),
                NSAttributedString.Key.foregroundColor: rgb(41,41,41),
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
            ]))
            
            if let range = attM.string.range(of: customerName) {
                attM.addAttributes([
                    NSAttributedString.Key.foregroundColor: rgb(254, 100, 153),
                ], range: NSRange(range, in: attM.string))
            }
            
//            if let range = attM.string.range(of: copyStr) {
//                attM.addAttributes([
//                    NSAttributedString.Key.foregroundColor: UIColor.white,
//                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0),
//                ], range: NSRange(range, in: attM.string))
//
//                let border = YYTextBorder(fill: RGBA(255,49,75, 1.0), cornerRadius: 3.0)
//                border.insets = .zero
//                border.lineStyle = []
//                let nsrange = NSRange(range, in: attM.string)
//                attM.yy_setTextBackgroundBorder(border, range: nsrange)
//
//                attM.yy_setTextHighlight(nsrange, color: .white, backgroundColor: nil) { (view, att, range, rect) in
//                    UIPasteboard.general.string = customerWxName
//                    MBProgressHUD.xy_show("已拷贝到剪切板")
//                }
//            }
          
            self.bindMethodLabel.attributedText = attM
            
            let maxSize = CGSize(width: self.bindMethodLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
            let textRect = attM.boundingRect(with: maxSize, options: [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin], context: nil)
            let height = textRect.size.height + 10.0
            bindMethodLabelHeight?.constant = height
            
//            DispatchQueue.main.async {
//                self.borderView.rt.addDottedLineBorder()
//            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        [borderView, bindMethodLabel, verificationCodeTF, okBtn, verificationCodeLabel].forEach { (subview) in
            self.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        verificationCodeLabel.setContentHuggingPriority(.required, for: .horizontal)
        verificationCodeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        bindMethodLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 36.0).isActive = true
        bindMethodLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -36.0).isActive = true
        bindMethodLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22.0).isActive = true
        bindMethodLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 12.0 * 2.0 - 36.0 * 2.0
        bindMethodLabelHeight = bindMethodLabel.heightAnchor.constraint(equalToConstant: 50.0)
        bindMethodLabelHeight?.isActive = true
        
        borderView.leadingAnchor.constraint(equalTo: bindMethodLabel.leadingAnchor, constant: -10.0).isActive = true
        borderView.trailingAnchor.constraint(equalTo: bindMethodLabel.trailingAnchor, constant: 10.0).isActive = true
        borderView.topAnchor.constraint(equalTo: bindMethodLabel.topAnchor, constant: -10.0).isActive = true
        borderView.bottomAnchor.constraint(equalTo: bindMethodLabel.bottomAnchor, constant: 10.0).isActive = true
        
        verificationCodeTF.topAnchor.constraint(equalTo: bindMethodLabel.bottomAnchor, constant: 27.0).isActive = true
        verificationCodeTF.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        verificationCodeTF.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60.0).isActive = true
        
        verificationCodeLabel.centerYAnchor.constraint(equalTo: verificationCodeTF.centerYAnchor, constant: 0.0).isActive = true
        verificationCodeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60.0).isActive = true
        verificationCodeLabel.trailingAnchor.constraint(equalTo: verificationCodeTF.leadingAnchor, constant: -6.0).isActive = true
        
        let okBtnHeight: CGFloat = 47.0
        okBtn.topAnchor.constraint(equalTo: verificationCodeTF.bottomAnchor, constant: 30.0).isActive = true
        okBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12.0).isActive = true
        okBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12.0).isActive = true
        okBtn.heightAnchor.constraint(equalToConstant: okBtnHeight).isActive = true
        okBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25.0).isActive = true

        okBtn.layer.cornerRadius = okBtnHeight * 0.5
        okBtn.setTitle("绑定", for: .normal)
        okBtn.addTarget(self, action: #selector(clickBindBtn), for: .touchUpInside)

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
        
        verificationCodeLabel.text = "验证码："
        
    }
    
    @objc func clickBindBtn() {
        if let btn = self.clickBindBlock {
            btn(self.okBtn)
        }
    }
    
}
