//
//  YXJTagView.swift
//  YXJTagView
//
//  Created by 袁晓钧 16/1/25.
//  Copyright © 2016年 袁晓钧. All rights reserved.
//

import UIKit

/**
 *  代理
 */
@objc public protocol YXJTagViewDelegate {
    optional func didClickView(text: String, index: Int)
}

public class YXJTagView: UIView {
    /// 横向间距
    public var horizontalSpace: CGFloat = 10.0
    /// 纵向间距
    public var verticalSpace: CGFloat = 10.0
    /// 左边空隙距离
    public var margin: CGFloat = 0.0

    /// 标签文字------使用场景1:纯文字
    public var textData: [String]?
    /// 标签字体
    public var textFont = UIFont.systemFontOfSize(15)
    /// 标签文字颜色
    public var textColor = UIColor.whiteColor()

    /// 标签图片------使用场景2:图片
    public var imageData: [UIImage]?
    /// 标签图片size,如果不设置，将根据高宽度自动适应
    public var imageSize: CGSize?

    /// 标签图片------使用场景3:视图
    public var viewData: [UIView]?
    /// 标签视图size,如果不设置，将根据高宽度自动适应
    public var viewSize: CGSize?

    /// 标签背景颜色
    public var textBackgorund = UIColor.lightGrayColor()
    /// 选中颜色
    public var selecteColor = UIColor.orangeColor()
    /// 是否可以选中,默认是
    public var selecteEnable = true

    ///
    public var title: String?
    ///
    public var titleFont = UIFont.systemFontOfSize(15)
    ///
    public var titleColor = UIColor.blackColor()

    /// 代理
    public var delegate: YXJTagViewDelegate?

    /// 是否是DEBUG模式
    public var debug = true

    private var btnClick: UIButton!
    private var label: UILabel?

    private var horizontalWidth: CGFloat = 0
    private var vertical: CGFloat = 0
    private var verticalHeight: CGFloat = 8
    private var index = -1

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func setupUI() {
        remove()
        if title != nil {
            setLabel(title!, titleFont: titleFont, titleColor: titleColor)
        }
        tagView(textFont, viewWidth: frame.width)
    }

    deinit {
        YXJLog("YXJTagView 已经被释放了")
    }
}

// MARK: - 点击方法
extension YXJTagView {

    func btnClick(sender: UIButton) {
        if btnClick == nil {
            btnClick = sender
        }
        if !btnClick.isEqual(sender) {
            btnClick.backgroundColor = textBackgorund
            btnClick.selected = false
        }
        sender.backgroundColor = selecteColor
        sender.selected = true
        btnClick = sender

        if let d = delegate {
            if let click = d.didClickView?(sender.currentTitle!, index: sender.tag - 100) {
                d.didClickView?(sender.currentTitle!, index: sender.tag - 100)
            } else {
                YXJLog("未实现YXJTagView > didClickView方法")
            }
        } else {
            YXJLog("未实现YXJTagView协议")
        }
    }
}

// MARK: - 私有方法
extension YXJTagView {
    private func setLabel(title: String, titleFont: UIFont, titleColor: UIColor) {
        label = UILabel()
        label!.text = title
        label!.textColor = titleColor
        label!.textAlignment = NSTextAlignment.Left
        let size = NSString(string: title).sizeWithAttributes([NSFontAttributeName: titleFont])
        label!.frame = CGRectMake(10, 10, size.width + 20, size.height)
        addSubview(label!)
    }

    private func tagView(textFont: UIFont, viewWidth: CGFloat) {
        if textData != nil {
            for str in textData! {
                index += 1;
                let button = UIButton()
                let size = NSString(string: str).sizeWithAttributes([NSFontAttributeName: textFont]);
//                self.setBtn(button, size: size, viewWidth: viewWidth, str: str)
                self.setTagViewFrame(nil, button: button, size: size, viewWidth: viewWidth, str: str)

                button.backgroundColor = textBackgorund
                button.layer.masksToBounds = true
                button.layer.cornerRadius = button.frame.height / 2
                button.clipsToBounds = true

                if index == textData!.count - 1 {
                    self.frame.size.height = CGRectGetMaxY(button.frame) + 10
                }
            }
        }
        if imageData != nil {
            for img in imageData! {
                index += 1;
                let button = UIButton()

                var size: CGSize!
                if imageSize != nil {
                    size = imageSize
                } else {
                    size = img.size
                }

//                self.setBtn(button,size: size,viewWidth: viewWidth,str: "")
                self.setTagViewFrame(nil, button: button, size: size, viewWidth: viewWidth, str: "")

                button.backgroundColor = textBackgorund
                button.setImage(img, forState: UIControlState.Normal)

                if index == imageData!.count - 1 {
                    self.frame.size.height = CGRectGetMaxY(button.frame) + 10
                }
            }
        }
        if viewData != nil {
            for tempView in viewData! {
                index += 1;
                let button = UIButton()

                var size: CGSize!
                if viewSize != nil {
                    size = viewSize
                } else {
                    size = tempView.frame.size
                }

//                button.backgroundColor = textBackgorund
                self.setTagViewFrame(tempView, button: button, size: size, viewWidth: viewWidth, str: "")
//                button.setImage(img, forState: UIControlState.Normal)

                if index == viewData!.count - 1 {
                    self.frame.size.height = CGRectGetMaxY(button.frame) + 10
                }
            }
        }
    }

    private func setTagViewFrame(view1: UIView?, button: UIButton, size: CGSize, viewWidth: CGFloat, str: String) {
        button.frame.size.width = size.width + 10
        button.frame.size.height = size.height + 5
        if index == 0 {
            button.frame.origin.x = margin
        } else {
            button.frame.origin.x = horizontalWidth + horizontalSpace
        }
        button.frame.origin.y = verticalHeight

        if button.frame.origin.x + button.frame.size.width > viewWidth {
            horizontalWidth = 0
            vertical++
            button.frame.origin.x = margin

            if verticalHeight < button.frame.size.height + button.frame.origin.y + verticalSpace {
                verticalHeight = button.frame.size.height + button.frame.origin.y + verticalSpace
                button.frame.origin.y = verticalHeight
            }
        }

        if label != nil {
            button.frame.origin.y = CGRectGetMaxY(label!.frame) + button.frame.origin.y
        }
        horizontalWidth = CGRectGetMaxX(button.frame)

        button.setTitle(str, forState: .Normal)
        button.titleLabel?.font = textFont
        button.addTarget(self, action: #selector(YXJTagView.btnClick(_:)), forControlEvents: .TouchUpInside)

        button.setTitleColor(textColor, forState: .Normal)
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        button.userInteractionEnabled = true
        button.titleLabel?.textAlignment = NSTextAlignment.Center
        button.enabled = selecteEnable
        button.tag = 100 + index

        view1?.frame = button.frame
        if let v = view1 {
            addSubview(v)
        }

        addSubview(button)

//        view1.frame.size.width = size.width + 10
//        view1.frame.size.height = size.height + 5
//        if index == 0 {
//            view1.frame.origin.x = margin
//        } else {
//            view1.frame.origin.x = horizontalWidth + horizontalSpace
//        }
//        view1.frame.origin.y = verticalHeight
//
//        if view1.frame.origin.x + view1.frame.size.width > viewWidth {
//            horizontalWidth = 0
//            vertical++
//            view1.frame.origin.x = margin
//
//            if verticalHeight < view1.frame.size.height + view1.frame.origin.y + verticalSpace {
//                verticalHeight = view1.frame.size.height + view1.frame.origin.y + verticalSpace
//                view1.frame.origin.y = verticalHeight
//            }
//        }
//
//        horizontalWidth = CGRectGetMaxX(view1.frame)
    }

//    private func setBtn(button: UIButton, size: CGSize, viewWidth: CGFloat, str: String) {
//        button.frame.size.width = size.width + 10
//        button.frame.size.height = size.height + 5
//        if index == 0 {
//            button.frame.origin.x = margin
//        } else {
//            button.frame.origin.x = horizontalWidth + horizontalSpace
//        }
//        button.frame.origin.y = verticalHeight
//
//        if button.frame.origin.x + button.frame.size.width > viewWidth {
//            horizontalWidth = 0
//            vertical++
//            button.frame.origin.x = margin
//
//            if verticalHeight < button.frame.size.height + button.frame.origin.y + verticalSpace {
//                verticalHeight = button.frame.size.height + button.frame.origin.y + verticalSpace
//                button.frame.origin.y = verticalHeight
//            }
//        }
//
//        if label != nil {
//            button.frame.origin.y = CGRectGetMaxY(label!.frame) + button.frame.origin.y
//        }
//        horizontalWidth = CGRectGetMaxX(button.frame)
//
//        button.setTitle(str, forState: .Normal)
//        button.titleLabel?.font = textFont
//        button.addTarget(self, action: #selector(YXJTagView.btnClick(_:)), forControlEvents: .TouchUpInside)
//
//        button.setTitleColor(textColor, forState: .Normal)
//        button.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
//        button.userInteractionEnabled = true
//        button.titleLabel?.textAlignment = NSTextAlignment.Center
//        button.enabled = selecteEnable
//        button.tag = 100 + index
//        addSubview(button)
//    }

    private func remove() {
        for subV in subviews {
            subV.removeFromSuperview()
        }
    }

    override public func removeFromSuperview() {
        remove()
        super.removeFromSuperview()
    }

    private func YXJLog<T>(message: T, fileName: String = __FILE__, methodName: String = __FUNCTION__, lineNumber: Int = __LINE__) {
        if debug == true {
            let str: String = (fileName as NSString).pathComponents.last!.stringByReplacingOccurrencesOfString("swift", withString: "")
            print("\(str)\(methodName)[\(lineNumber)]:\(message)")
        }
    }
}
