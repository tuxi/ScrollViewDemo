//
// WechatBindContentView.swift
// rebate
//
// Created by xiaoyuan on 2020/3/23.
// Copyright © 2020 寻宝天行. All rights reserved.
//

import UIKit

fileprivate class WechatBindContentViewCell: UICollectionViewCell {
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = rgb(41,41,41)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = rgb(102,102,102)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    var item: WechatBindContentView.Item? {
        didSet {
            self.iconView.image = UIImage(named: item?.icon ?? "")
            self.titleLabel.text = item?.title
            self.subTitleLabel.text = item?.subTitle
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
        [iconView, titleLabel, subTitleLabel].forEach { (subview) in
            contentView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0.0).isActive = true
        iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0).isActive = true
        iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor, constant: 0.0).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10.0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0.0).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0).isActive = true
        subTitleLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        subTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0).isActive = true
    }
}

class WechatBindContentView: UIView {
    
    struct Item {
        let title: String
        var subTitle: String?
        let icon: String
        
    }

    lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    static let ItemHeight: CGFloat = 110.0
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    
    lazy var subTitleView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = rgb(41,41,41)
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.textAlignment = .center
        label.text = "开通方法"
        return label
    }()
    
    lazy var unbindView = WechatUnbindContentView()
    lazy var bindedView = WechatBindedContentView()
    
    private var unbindViewBottom: NSLayoutConstraint?
    private var bindedViewBottom: NSLayoutConstraint?
    
    var clickBindBlock: ((_ btn: UIButton) -> Void)? {
           didSet {
               self.unbindView.clickBindBlock = clickBindBlock
           }
       }
    var clickChangeBindBlock: ((_ btn: UIButton) -> Void)? {
        didSet {
            self.bindedView.clickChangeBindBlock = clickChangeBindBlock
        }
    }
    
    // 当前绑定的微信名
    var bindedWxName: String? {
        didSet {
            
            updateBindedWxName(bindedWxName, animated: false)
        }
    }
    
    // 客服的微信名
    var customerWxName: String? {
        didSet {
            
            self.unbindView.customerWxName = customerWxName
        }
    }
    
    lazy var items = [Item]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addItems()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addItems() {
        items.append(Item(title: "免费领菜券", subTitle: "3张特价菜券", icon: "icon_wechatbind_mflcq"))
        items.append(Item(title: "每日特惠菜", subTitle: "88折/新品体验", icon: "icon_wechatbind_mrtjc"))
        items.append(Item(title: "极速退款", icon: "icon_wechatbind_kstk"))
        items.append(Item(title: "极速补货", icon: "icon_wechatbind_jsbh"))
        items.append(Item(title: "7＊24免费服务", icon: "icon_wechatbind_free_service"))
        items.append(Item(title: "更多权益", subTitle: "敬请期待", icon: "icon_wechatbind_more"))
    }
    
    private func setupUI() {
        
        [contentView, collectionView, subTitleView, unbindView, bindedView].forEach { (subview) in
            self.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WechatBindContentViewCell.self, forCellWithReuseIdentifier: "WechatBindContentViewCell")
        
        let padding: CGFloat = 12.0
        
        contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 100.0).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100.0).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 41.0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: Self.ItemHeight * CGFloat(items.count / 3)).isActive = true
        
        subTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
        subTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0).isActive = true
        subTitleView.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        subTitleView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10.0).isActive = true
        
        unbindView.topAnchor.constraint(equalTo: subTitleView.bottomAnchor, constant: 3.0).isActive = true
        unbindView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        unbindView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        unbindViewBottom = unbindView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0)
        unbindViewBottom?.isActive = false
        
        bindedView.topAnchor.constraint(equalTo: unbindView.topAnchor).isActive = true
        bindedView.leadingAnchor.constraint(equalTo: unbindView.leadingAnchor).isActive = true
        bindedView.trailingAnchor.constraint(equalTo: unbindView.trailingAnchor).isActive = true
        bindedViewBottom = bindedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0)
        bindedViewBottom?.isActive = true
        
        let style1 = UIView(frame: CGRect(x: 108, y: 424, width: 50, height: 1))
        style1.layer.backgroundColor = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0).cgColor
        style1.alpha = 1
        
        let style2 = UIView(frame: CGRect(x: 108, y: 424, width: 50, height: 1))
        style2.layer.backgroundColor = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0).cgColor
        style2.alpha = 1
        
        [subTitleLabel, style1, style2].forEach { (subview) in
             subTitleView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        subTitleLabel.centerXAnchor.constraint(equalTo: subTitleView.centerXAnchor).isActive = true
        subTitleLabel.centerYAnchor.constraint(equalTo: subTitleView.centerYAnchor).isActive = true
        
        style1.trailingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor, constant: -8.0).isActive = true
        style1.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        style1.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        style1.centerYAnchor.constraint(equalTo: subTitleLabel.centerYAnchor).isActive = true
        
        style2.leadingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor, constant: 8.0).isActive = true
        style2.widthAnchor.constraint(equalTo: style1.widthAnchor).isActive = true
        style2.heightAnchor.constraint(equalTo: style1.heightAnchor).isActive = true
        style2.centerYAnchor.constraint(equalTo: subTitleLabel.centerYAnchor).isActive = true
    }
    
    private func updateBindedWxName(_ bindedWxName: String?, animated: Bool) {
        if let bindedWxName = bindedWxName {
            self.bindedView.wechatNameLabel.text = "当前APP已绑定微信号：\(bindedWxName)"
            self.bindedView.isHidden = false
            self.bindedViewBottom?.isActive = true
            self.unbindViewBottom?.isActive = false
            self.unbindView.alpha = 0.0
            self.bindedView.alpha = 1.0
            if animated == true {
                UIView.animate(withDuration: 0.1, animations: {
                    self.layoutIfNeeded()
                }) { (isFinished) in
                    self.unbindView.verificationCodeTF.text = ""
                    self.unbindView.isHidden = true
                }
            }
            else {
                self.layoutIfNeeded()
                self.unbindView.verificationCodeTF.text = ""
                self.unbindView.isHidden = true
            }
        }
        else {
            self.bindedView.wechatNameLabel.text = nil
            self.unbindView.isHidden = false
            self.bindedViewBottom?.isActive = false
            self.unbindViewBottom?.isActive = true
            self.unbindView.alpha = 1.0
            self.bindedView.alpha = 0.0
            if animated == true {
                UIView.animate(withDuration: 0.1, animations: {
                    self.layoutIfNeeded()
                }) { (isFinished) in
                    self.bindedView.isHidden = true
                }
            }
            else {
                self.layoutIfNeeded()
                self.bindedView.isHidden = true
            }
        }
    }
    
}

extension WechatBindContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WechatBindContentViewCell", for: indexPath) as! WechatBindContentViewCell
        cell.item = items[indexPath.row]
        return cell
    }
}

extension WechatBindContentView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: floor(collectionView.frame.size.width / 3.0 - 1.0), height: Self.ItemHeight)
    }
}
