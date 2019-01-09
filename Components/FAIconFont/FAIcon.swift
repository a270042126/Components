import Foundation
import UIKit

public extension UITextField {

    public func setRightViewFAIcon(fontType: FAFontType, icon: String, rightViewMode: UITextField.ViewMode = .always, orientation: UIImage.Orientation = UIImage.Orientation.down, textColor: UIColor = .black, backgroundColor: UIColor = .clear, size: CGSize? = nil) {

        let image = UIImage(fontType: fontType, icon: icon, size: size ?? CGSize(width: 30, height: 30), orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
        let imageView = UIImageView.init(image: image)

        self.rightView = imageView
        self.rightViewMode = rightViewMode
    }

    public func setLeftViewFAIcon(fontType: FAFontType, icon: String, leftViewMode: UITextField.ViewMode = .always, orientation: UIImage.Orientation = UIImage.Orientation.down, textColor: UIColor = .black, backgroundColor: UIColor = .clear, size: CGSize? = nil) {

        let image = UIImage(fontType: fontType, icon: icon, size: size ?? CGSize(width: 30, height: 30), orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
        let imageView = UIImageView.init(image: image)

        self.leftView = imageView
        self.leftViewMode = leftViewMode
    }
}

public extension UIBarButtonItem {

    /**
     To set an icon, use i.e. `barName.FAIcon = String.FAGithub`
     */
    func setFAIcon(fontType: FAFontType, icon: String, iconSize: CGFloat) {
        //FontLoader.loadFontIfNeeded()
        let font = UIFont(name: fontType.rawValue, size: iconSize)
        assert(font != nil, ErrorAnnounce)
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .selected)
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .highlighted)
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .disabled)
        title = FAIconDict[fontType.rawValue]?[icon]
    }

    func setFAText(prefixText: String = "", fontType: FAFontType, icon: String, postfixText: String = "", size: CGFloat) {
        //FontLoader.loadFontIfNeeded()
        let font = UIFont(name: fontType.rawValue, size: size)
        assert(font != nil, ErrorAnnounce)
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .selected)
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .highlighted)
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .disabled)

        var text = prefixText
        if let iconText = FAIconDict[fontType.rawValue]?[icon] {
            text += iconText
        }
        text += postfixText
        title = text
    }
}


public extension UIButton {
    /**
     To set an icon, use i.e. `buttonName.setFAIcon(String.FAGithub, forState: .Normal)`
     */
    func setFAIcon(fontType: FAFontType, icon: String, forState state: UIControl.State) {
        guard let titleLabel = titleLabel else { return }
        setAttributedTitle(nil, for: state)
        let font = UIFont(name: fontType.rawValue, size: titleLabel.font.pointSize)
        assert(font != nil, ErrorAnnounce)
        titleLabel.font = font!
        setTitle(FAIconDict[fontType.rawValue]?[icon], for: state)
    }

    /**
     To set an icon, use i.e. `buttonName.setFAIcon(String.FAGithub, iconSize: 35, forState: .Normal)`
     */
    func setFAIcon(fontType: FAFontType,icon: String, iconSize: CGFloat, forState state: UIControl.State) {
        setFAIcon(fontType: fontType, icon: icon, forState: state)
        guard let fontName = titleLabel?.font.fontName else { return }
        titleLabel?.font = UIFont(name: fontName, size: iconSize)
    }

    func setFAText(prefixText: String = "", fontType: FAFontType, icon: String, postfixText: String = "", size: CGFloat?, iconSize: CGFloat? = nil, titleColor: UIColor = .black, iconColor: UIColor = .black, forState state: UIControl.State) {
        setTitle(nil, for: state)
        guard let titleLabel = titleLabel else { return }
        let attributedText = attributedTitle(for: .normal) ?? NSAttributedString()
        let  startFont =  attributedText.length == 0 ? nil : attributedText.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil) as? UIFont
        let endFont = attributedText.length == 0 ? nil : attributedText.attribute(NSAttributedString.Key.font, at: attributedText.length - 1, effectiveRange: nil) as? UIFont
        var textFont = titleLabel.font
        if let f = startFont , f.fontName != fontType.rawValue  {
            textFont = f
        } else if let f = endFont , f.fontName != fontType.rawValue  {
            textFont = f
        }
        if let fontSize = size {
            textFont = textFont?.withSize(fontSize)
        }
        
        var textColor: UIColor = titleColor
        attributedText.enumerateAttribute(NSAttributedString.Key.foregroundColor, in:NSMakeRange(0,attributedText.length), options:.longestEffectiveRangeNotRequired) {
            value, range, stop in
            if value != nil {
                textColor = value as! UIColor
            }
        }

        let textAttributes = [NSAttributedString.Key.font: textFont!, NSAttributedString.Key.foregroundColor: textColor] as [NSAttributedString.Key : Any]
        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttributes)

        if let iconText = FAIconDict[fontType.rawValue]?[icon] {
            let iconFont = UIFont(name: fontType.rawValue, size: iconSize ?? size ?? titleLabel.font.pointSize)!
            let iconAttributes = [NSAttributedString.Key.font: iconFont, NSAttributedString.Key.foregroundColor: iconColor] as [NSAttributedString.Key : Any]

            let iconString = NSAttributedString(string: iconText, attributes: iconAttributes)
            prefixTextAttribured.append(iconString)
        }
        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttributes)
        prefixTextAttribured.append(postfixTextAttributed)

        setAttributedTitle(prefixTextAttribured, for: state)
    }

//    func setFATitleColor(color: UIColor, forState state: UIControl.State = .normal) {
//        let attributedString = NSMutableAttributedString(attributedString: attributedTitle(for: state) ?? NSAttributedString())
//        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attributedString.length))
//
//        setAttributedTitle(attributedString, for: state)
//        setTitleColor(color, for: state)
//    }
}


public extension UILabel {


    /**
     To set an icon, use i.e. `labelName.setFAIcon(String.FAGithub, iconSize: 35)`
     */
    func setFAIcon(fontType: FAFontType, icon: String, iconSize: CGFloat = 0) {
        if iconSize == 0{
            let fontAwesome = UIFont(name: fontType.rawValue, size: self.font.pointSize)
            font = fontAwesome!
        }else{
             font = UIFont(name: fontType.rawValue, size: iconSize)
        }
        assert(font != nil, ErrorAnnounce)
        text = FAIconDict[fontType.rawValue]?[icon]
    }

//    func setFAColor(color: UIColor) {
//        let attributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString())
//        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attributedText!.length))
//        textColor = color
//    }
//
//    func setFAText(prefixText: String, fontType: FAFontType, icon: String, postfixText: String, size: CGFloat?, iconSize: CGFloat? = nil) {
//        text = nil
//        //FontLoader.loadFontIfNeeded()
//
//        let attrText = attributedText ?? NSAttributedString()
//        let startFont = attrText.length == 0 ? nil : attrText.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil) as? UIFont
//        let endFont = attrText.length == 0 ? nil : attrText.attribute(NSAttributedString.Key.font, at: attrText.length - 1, effectiveRange: nil) as? UIFont
//        var textFont = font
//        if let f = startFont , f.fontName != fontType.rawValue  {
//            textFont = f
//        } else if let f = endFont , f.fontName != fontType.rawValue  {
//            textFont = f
//        }
//        let textAttribute = [NSAttributedString.Key.font : textFont!]
//        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttribute)
//
//        if let iconText = FAIconDict[fontType.rawValue]?[icon] {
//            let iconFont = UIFont(name: fontType.rawValue, size: iconSize ?? size ?? font.pointSize)!
//            let iconAttribute = [NSAttributedString.Key.font : iconFont]
//
//            let iconString = NSAttributedString(string: iconText, attributes: iconAttribute)
//            prefixTextAttribured.append(iconString)
//        }
//        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttribute)
//        prefixTextAttribured.append(postfixTextAttributed)
//
//        attributedText = prefixTextAttribured
//    }
}


// Original idea from https://github.com/thii/FontAwesome.swift/blob/master/FontAwesome/FontAwesome.swift
public extension UIImageView {

    /**
     Create UIImage from String
     */
    public func setFAIconWithName(fontType: FAFontType, icon: String, textColor: UIColor, orientation: UIImage.Orientation = UIImage.Orientation.down, backgroundColor: UIColor = UIColor.clear, size: CGSize? = nil) {
        self.image = UIImage(fontType: fontType, icon: icon, size: size ?? frame.size, orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
    }
}


public extension UITabBarItem {

    public func setFAIcon(fontType: FAFontType, icon: String, size: CGSize? = nil, orientation: UIImage.Orientation = UIImage.Orientation.down, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear, selectedTextColor: UIColor = UIColor.black, selectedBackgroundColor: UIColor = UIColor.clear) {
        let tabBarItemImageSize = size ?? CGSize(width: 30, height: 30)

        image = UIImage(fontType: fontType, icon: icon, size: tabBarItemImageSize, orientation: orientation, textColor: textColor, backgroundColor: backgroundColor).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

        selectedImage = UIImage(fontType: fontType, icon: icon, size: tabBarItemImageSize, orientation: orientation, textColor: selectedTextColor, backgroundColor: selectedBackgroundColor).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor], for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedTextColor], for: .selected)
    }
}


public extension UISegmentedControl {

    public func setFAIcon(fontType: FAFontType, icon: String, forSegmentAtIndex segment: Int) {
        let font = UIFont(name: fontType.rawValue, size: 23)
        assert(font != nil, ErrorAnnounce)
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
        setTitle(FAIconDict[fontType.rawValue]?[icon], forSegmentAt: segment)
    }
}


public extension UIStepper {

    public func setFABackgroundImage(fontType: FAFontType, icon: String, forState state: UIControl.State) {
        let backgroundSize = CGSize(width: 47, height: 29)
        let image = UIImage(fontType: fontType, icon: icon, size: backgroundSize)
        setBackgroundImage(image, for: state)
    }

    public func setFAIncrementImage(fontType: FAFontType, icon: String, forState state: UIControl.State) {
        let incrementSize = CGSize(width: 16, height: 16)
        let image = UIImage(fontType: fontType, icon: icon, size: incrementSize)
        setIncrementImage(image, for: state)
    }

    public func setFADecrementImage(fontType: FAFontType, icon: String, forState state: UIControl.State) {
        let decrementSize = CGSize(width: 16, height: 16)
        let image = UIImage(fontType: fontType, icon: icon, size: decrementSize)
        setDecrementImage(image, for: state)
    }
}


public extension UIImage {

    public convenience init(fontType: FAFontType, icon: String, size: CGSize, orientation: UIImage.Orientation = UIImage.Orientation.down, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center

        let fontAspectRatio: CGFloat = 1.28571429
        let fontSize = min(size.width / fontAspectRatio, size.height)
        let font = UIFont(name: fontType.rawValue, size: fontSize)
        assert(font != nil, ErrorAnnounce)
        let attributes = [NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.backgroundColor: backgroundColor, NSAttributedString.Key.paragraphStyle: paragraph]

        let attributedString = NSAttributedString(string: FAIconDict[fontType.rawValue]?[icon] ?? "", attributes: attributes)
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.draw(in: CGRect(x: 0, y: (size.height - fontSize) * 0.5, width: size.width, height: fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        if let image = image {
            var imageOrientation = image.imageOrientation

            if(orientation != UIImage.Orientation.down){
                imageOrientation = orientation
            }

            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: imageOrientation)
        } else {
            self.init()
        }
    }

    public convenience init(fontType: FAFontType, bgIcon: String, orientation: UIImage.Orientation = UIImage.Orientation.down, bgTextColor: UIColor = .black, bgBackgroundColor: UIColor = .clear, topIcon: String, topTextColor: UIColor = .black, bgLarge: Bool? = true, size: CGSize? = nil) {

        let bgSize: CGSize!
        let topSize: CGSize!
        let bgRect: CGRect!
        let topRect: CGRect!

        if bgLarge! {
            topSize = size ?? CGSize(width: 30, height: 30)
            bgSize = CGSize(width: 2 * topSize.width, height: 2 * topSize.height)
        } else {
            bgSize = size ?? CGSize(width: 30, height: 30)
            topSize = CGSize(width: 2 * bgSize.width, height: 2 * bgSize.height)
        }

        let bgImage = UIImage.init(fontType: fontType, icon: bgIcon, size: bgSize, orientation: orientation, textColor: bgTextColor)
        let topImage = UIImage.init(fontType: fontType, icon: topIcon, size: topSize, orientation: orientation, textColor: topTextColor)

        if bgLarge! {
            bgRect = CGRect(x: 0, y: 0, width: bgSize.width, height: bgSize.height)
            topRect = CGRect(x: topSize.width/2, y: topSize.height/2, width: topSize.width, height: topSize.height)
            UIGraphicsBeginImageContextWithOptions(bgImage.size, false, 0.0)
        } else {
            topRect = CGRect(x: 0, y: 0, width: topSize.width, height: topSize.height)
            bgRect = CGRect(x: bgSize.width/2, y: bgSize.height/2, width: bgSize.width, height: bgSize.height)
            UIGraphicsBeginImageContextWithOptions(topImage.size, false, 0.0)

        }

        bgImage.draw(in: bgRect)
        topImage.draw(in: topRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let image = image {
            var imageOrientation = image.imageOrientation

            if(orientation != UIImage.Orientation.down){
                imageOrientation = orientation
            }

            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: imageOrientation)
        } else {
            self.init()
        }
    }
}


public extension UISlider {

    func setFAMaximumValueImage(fontType: FAFontType, icon: String, orientation: UIImage.Orientation = UIImage.Orientation.down, customSize: CGSize? = nil) {
        maximumValueImage = UIImage(fontType: fontType, icon: icon, size: customSize ?? CGSize(width: 25,height: 25), orientation: orientation)
    }

    func setFAMinimumValueImage(fontType: FAFontType, icon: String, orientation: UIImage.Orientation = UIImage.Orientation.down, customSize: CGSize? = nil) {
        minimumValueImage = UIImage(fontType: fontType, icon: icon, size: customSize ?? CGSize(width: 25,height: 25), orientation: orientation)
    }
}

public extension UIViewController {
    
    func setFATitle(fontType: FAFontType, icon: String){
        let font = UIFont(name: fontType.rawValue, size: 23)
        assert(font != nil,ErrorAnnounce)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font!]
        title = FAIconDict[fontType.rawValue]?[icon]
    }
}
private let ErrorAnnounce = "****** FONT AWESOME SWIFT - FontAwesome font not found in the bundle or not associated with Info.plist when manual installation was performed. ******"


