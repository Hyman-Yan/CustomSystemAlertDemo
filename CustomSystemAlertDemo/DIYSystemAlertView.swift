//
//  DIYSystemAlertView.swift
//  CustomSystemAlertDemo
//
//  Created by WeCarMac02 on 15/10/12.
//  Copyright © 2015年 WeCarMac02. All rights reserved.
//

//index  注释需要清晰，0代表 1代表


import UIKit

enum AlertType: Int {
    
    case Default = 1
    case Toast = 2
    case NetReachFail = 3
    
}

//管理提示框 数组

private var _alertArr: [DIYSystemAlertView]! = []
private let _alertManager = AlertManager()
/// 网络不通提示时间间隔
private let _timeIntervalWhenUnReach: NSTimeInterval = 60

private class AlertManager: NSObject {
    
    private var _timer: NSTimer!
    
    //是否提示网络可达
    private var _netReachShallShow: Bool = true
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appDidEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    
    private func appDidEnterBackground() {
        _alertArr.removeAll()
        _timer.invalidate()
        _timer = nil
    }
    
    private func appDidBecomeActive() {
        _timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "beginMonitor", userInfo: nil, repeats: true)
    }
    
    
    private func beginMonitor() {
        
        if _timer == nil {
            _timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "beginMonitor", userInfo: nil, repeats: true)
        }
        if _alertArr.count > 0 {
            _alertArr.last!.show()
            _alertArr.removeLast()
        } else {
            _timer.invalidate()
            _timer = nil
        }
    }
    
    
    private class func shareManager() -> AlertManager{
        return _alertManager
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func wc_addAlert(alert: DIYSystemAlertView) {
        _alertArr.append(alert)
    }
    
}



class DIYSystemAlertView: NSObject,UIAlertViewDelegate {


    
    // MARK: - Assist Variable
    private var _title: String?//主题
    private var _message: String?//信息
    private var _btnTitles: [String]!//按钮title 不能为空
    private var _clickBlock:((index:Int) -> Void)!//点击按钮回调block
    private var _showClick: (() -> Void)!//提示框回调(UIAlertController)
    private var _alertView:UIAlertView!//提示框(UIAlertView)
    //private var _alertControl:UIAlertController!//报错：只适用于iOS 8之后的系统
    
    
    init(title: String?, message: String?, buttonTitles:[String], clickBlock:((index:Int) -> Void)?) {
        super.init()
        _title = title
        _message = message
        _btnTitles = buttonTitles
        _clickBlock = clickBlock
        
        
        if #available(iOS 9.0,*){
            //UIAlertController
            let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.Alert)
            for title in buttonTitles{
                let action = UIAlertAction(title: title, style: UIAlertActionStyle.Default, handler: {[unowned self] (alertAction) -> Void in
                    let index = self._btnTitles.indexOf(title)
                    if self._clickBlock != nil{
                        self._clickBlock(index: index!)
                    }else{
                        print("DIYSystemAlertView Warning: No Click Block Event")
                    }
                    //点击过后 数组不再持有本类对象
                    _alertArr.removeAll()
                    
                    })
                alert.addAction(action)
            }
            
            _showClick = {() -> Void in
                UIApplication.sharedApplication().delegate!.window!!.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
        }else{
            //UIAlertView
            _alertView = UIAlertView(title: _title, message: _message, delegate: self, cancelButtonTitle: nil)
            for btnTitle in buttonTitles{
                _alertView.addButtonWithTitle(btnTitle)
            }
            
            
        }

    }
    
    convenience init(title: String?, message: String?, buttonTitles:String... , clickBlock:((index:Int) -> Void)?){
        self.init(title:title, message:message,buttonTitles:buttonTitles,clickBlock:clickBlock)
    }
    
    // MARK: - Private Method
    
    
    
    // MARK: - UIAlertViewDelegate 代理
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if _clickBlock != nil{
            _clickBlock(index: buttonIndex)
        }else{
            
            print("DIYSystemAlertView Warning: No Click Block Event ")
        }
        //点击过后 数组不再持有本类对象
        _alertArr.removeAll()
        
    }
    
    private func show(){
        
        if #available(iOS 9.0,*){
            _showClick()
        }else{
            _alertView.show()
        }
    }
    
    // MARK: - Outer Interface
    //==============对外开放接口=====================
    
    //弹出提示框
    
    
    /**
    提示一段文字
    
    - parameter title:   标题
    - parameter message: 提示内容
    - parameter type:    提示类型
    */
    class func wc_show(title: String? = nil, message: String? = nil, type : AlertType = .Default, buttonTitles: [String], clickBlock: ((index: Int) -> Void)? = nil) {
        
        var titleArray : [String] = []
        
        for titleText in buttonTitles {
            titleArray.append(titleText)
        }
        
        let alert = DIYSystemAlertView(title: title, message: message, buttonTitles:buttonTitles, clickBlock: clickBlock)
        AlertManager.shareManager().wc_addAlert(alert)
        AlertManager.shareManager().beginMonitor()
    }
    
}
