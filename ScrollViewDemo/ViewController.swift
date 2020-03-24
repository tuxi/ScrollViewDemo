//
//  ViewController.swift
//  ScrollViewDemo
//
//  Created by xiaoyuan on 2020/3/24.
//  Copyright © 2020 enba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var contentView = WechatBindContentView()
    
    fileprivate lazy var emptyView = DefaultEmpatyView()
    
    fileprivate lazy var topView = WechatBindTopView()
    
    fileprivate var isFailured = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadNewData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(networkDidChange(notifi:)), name: NSNotification.Name.DidChangeReachabilityStatus, object: nil)
        
        scrollView.delegate = self
    }
    
    private func setupUI() {
        
        self.title = "微信电话服务"
        
        self.scrollView.backgroundColor = .clear
        self.view.backgroundColor = rgb(242, 242, 242)
        
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        self.view.addSubview(self.topView)
        self.topView.translatesAutoresizingMaskIntoConstraints = false
        self.topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.topView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.scrollView.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        
        self.view.addSubview(self.emptyView)
        self.emptyView.translatesAutoresizingMaskIntoConstraints = false
        self.emptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.emptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.emptyView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.emptyView.isHidden = true
        emptyView.button.isUserInteractionEnabled = false
        emptyView.addTarget(self, action: #selector(clickEmptyView(sender:)), for: .touchUpInside)
        
        addHideKeyboardGesture()
        setupContentView()
        
        self.contentView.unbindView.verificationCodeTF.delegate = self
        self.contentView.customerWxName = "mintPure"
    }
    
    private func setupContentView() {
        self.contentView.clickBindBlock = {[weak self] btn in
            self?.contentView.bindedWxName = "xiaoyuan"
        }
        
        self.contentView.clickChangeBindBlock = { btn in
            btn.isUserInteractionEnabled = false
            self.contentView.bindedWxName = nil
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                btn.isUserInteractionEnabled = true
            }
        }
        
//        self.contentView.clickGetCouponBlock = { [weak self] btn in
//            let vc = IncomeCenterMainViewController(defaultIndex: 2)
//            self?.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @objc private func clickEmptyView(sender: DefaultEmpatyView) {
        
    }
    
    @objc private func clickBackBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if self.contentView.unbindView.verificationCodeTF.isFirstResponder == false {
            return
        }
        
        guard let info = notification.userInfo else { return }
        let rect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        let keyboardHeight = rect.size.height
        //        let duration = info?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        let keyboardY = self.scrollView.frame.size.height - keyboardHeight
        let tfRect = self.contentView.unbindView.verificationCodeTF.convert(self.contentView.unbindView.verificationCodeTF.frame, to: self.view)
        if tfRect.maxY > keyboardY {
            var insets = self.scrollView.contentInset
            insets.bottom = keyboardHeight + 5.0
            self.scrollView.contentInset = insets
            self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height), animated: true)
        }
    }
    
    
    @objc private func keyBoardWillHide(notification: Notification) {
        guard let info = notification.userInfo else { return }
        let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
        
        var insets = self.scrollView.contentInset
        insets.bottom = 0
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = insets
        }
    }
    
//    @objc private func networkDidChange(notifi: Notification) {
//        self.emptyView.reload(isFailured: self.isFailured)
//        if self.isFailured && NetWorkUtils.shared.isConnected {
//            self.loadNewData()
//        }
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController {
    fileprivate func loadNewData() {
        
        self.contentView.isHidden = false
        self.emptyView.isHidden = true
        self.contentView.bindedWxName = "xiaoyuan"
        
    }
    
    // 查询绑定微信助手的微信id
    private func loadCustomerServerWxid() {
        self.contentView.customerWxName = "xiaoyuan1"
        DispatchQueue.main.async {
            self.scrollView.setNeedsLayout()
            self.scrollView.layoutIfNeeded()
        }
    }
    
}

extension ViewController {
    fileprivate func addHideKeyboardGesture() {
        // collectionView 添加 点击空白隐藏键盘的手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGes.numberOfTouchesRequired = 1
        // 是否取消点击处的其他action
        // tap的cancelsTouchesInView方法，官方描述是“A Boolean value affecting whether touches are delivered to a view when a gesture is recognized.”也就是说，可以通过设置这个布尔值，来设置手势被识别时触摸事件是否被传送到视图。
        // 当值为YES的时候，系统会识别手势，并取消触摸事件；为NO的时候，手势识别之后，系统将触发触摸事件。
        tapGes.cancelsTouchesInView = false
        self.scrollView.addGestureRecognizer(tapGes)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
}


extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        defer {
            self.contentView.unbindView.clickBindBtn()
            self.contentView.unbindView.verificationCodeTF.resignFirstResponder()
        }
        return true
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            topView.topViewTop?.constant = -scrollView.contentOffset.y * 0.5
        }
        else {
            topView.topViewTop?.constant = 0.0
        }
    }
}

