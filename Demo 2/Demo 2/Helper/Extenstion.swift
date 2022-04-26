//
//  Extenstion.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import LocalAuthentication

let RIGHT_SIDE : String = "RIGHT_SIDE_VIEW"
let LEFT_SIDE : String = "LEFT_SIDE_VIEW"

private var kAssociationKeyMaxLength: Int = 0

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "AudioAccessory5,1":                       return "HomePod mini"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
}
extension String {
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }

    func isEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .caseInsensitive)
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    
    func convertStringToInt() -> Int {
        return Int(Double(self) ?? 0.0)
    }
    
    func trim() -> String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }
}

extension NSAttributedString {
    func withLineSpacing(_ spacing: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = spacing
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }
    
}

extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        if range.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
}

private var imgName:String!
extension UIImageView {
    
    var imageName:String {
        get{
            return objc_getAssociatedObject(self, &imgName) as! String
        }
        set(value){
            objc_setAssociatedObject(self, &imgName, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIImage {
    func fixOrientation() -> UIImage? {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }

        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension UITextField {
    
    func isEmpty()->Int{
        let whitespaceSet = CharacterSet.whitespaces
        if self.text!.trimmingCharacters(in: whitespaceSet) != "" {
            return 0
        }
        return 1
    }
    
    func isEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .caseInsensitive)
        return regex?.firstMatch(in: self.text!, options: [], range: NSMakeRange(0, self.text!.count)) != nil
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            self.addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    func isInputMethod() -> Bool {
        if let positionRange = self.markedTextRange {
            if let _ = self.position(from: positionRange.start, offset: 0) {
                return true
            }
        }
        return false
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        
        guard !self.isInputMethod(), let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = String(prospectiveText[..<maxCharIndex])
        selectedTextRange = selection
    }
    
    func setRightViewCenterIcon(icon: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btnView.setImage(icon, for: .normal)
        btnView.imageView?.contentMode = .scaleAspectFit
        
        btnView.imageEdgeInsets = UIEdgeInsets(top: self.frame.height*0.09, left: self.frame.height*0.09, bottom: self.frame.height*0.09, right: self.frame.height*0.09)
        self.rightViewMode = .always
        self.rightView = btnView
    }
}

extension UITextView {
    func isEmpty()->Int{
        let whitespaceSet = CharacterSet.whitespaces
        if self.text.trimmingCharacters(in: whitespaceSet) != "" {
            return 0
        }
        return 1
    }
    
    open override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
}

extension String {
    var hex: Int? {
        return Int(self, radix: 16)
    }
}

extension Date {
    static func getDateWithTimeFromString(_ dateString:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = globalDateFormat + " " + globalTimeFormat 
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    static func getSelectedDateFromString(_ str:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = globalDateFormat
        let date = dateFormatter.date(from: str) ?? Date()
        return date
    }
    
    static func getDateOnly()->String!{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = globalDateFormat
        let date = dateFormatter.string(from: Date())
        return date
    }
    
    func getDateOnly()->String!{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = globalDateFormat
        let date = dateFormatter.string(from: self)
        return date
    }
    
    func getDateOnlyInRequestedTimezone(timeZone: String)->String!{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: timeZone) as TimeZone?
        dateFormatter.dateFormat = globalDateFormat
        let date = dateFormatter.string(from: self)
        return date
    }
    
    static func getHourMinSecondswithDate(_ time:String!)->Date!{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = globalTimeFormat
        let date = dateFormatter.date(from: time ?? Date.getOnlyTime()) ?? Date()
        return date
    }
    
    static func getOnlydate()->String!{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        let date = dateFormatter.string(from: Date())
        return date
    }
    
    func getOnlydate()->String!{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        let date = dateFormatter.string(from: self)
        return date
    }
    
    func getOnlydateInNumbers()->String!{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = API_RESPONSE_DATE_FORMAT
        let date = dateFormatter.string(from: self)
        return date
    }
    
    static func getOnlyTime()->String!{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.string(from: Date())
        return date
    }
    
    func getOnlyTimeWithFormat()->String!{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = globalTimeFormat
        let date = dateFormatter.string(from: self)
        return date
    }
    
    func getOnlyTimeWithHMMSSFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = API_REQUEST_TIME_FORMAT
        let date = dateFormatter.string(from: AppFunctions.sharedInstance.getCurrentDateInSettingTimezone())
        return date
    }
    
    func getOnlyTimeWithHMMSSInRequiredTimezone(timeZone: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: timeZone) as TimeZone?
        dateFormatter.dateFormat = API_REQUEST_TIME_FORMAT
        let date = dateFormatter.string(from: AppFunctions.sharedInstance.getCurrentDateInRequestedTimezone(timeZone: timeZone))
        return date
    }
    
    static func getOnlyTimeWithFormat()->String!{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.string(from: Date())
        return date
    }
    
    func isGreaterThanDate(_ dateToCompare : Date) -> Bool{
        var isGreater = false
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending
        {
            isGreater = true
        }
        return isGreater
    }
    
    static func getDateFromStringValue(_ strDate: String, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateFromStr = dateFormatter.date(from: strDate)!
        //Output: Jan 1, 2000
        // Usage
        let timeFromDate = dateFormatter.string(from: dateFromStr)
        print(timeFromDate)
        return timeFromDate
    }
    
    func getHourMinSecondswithDate(_ time:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
        dateFormatter.dateFormat = SUBSCRIPTION_DATE_OUTPUT_FORMAT
        let date = dateFormatter.date(from: time) ?? Date()
        return date
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var leftBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = UIColor(cgColor: layer.borderColor!)
            line.tag = 110
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    
    @IBInspectable var topBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            line.tag = 110
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
        }
    }
    
    @IBInspectable var rightBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: bounds.width, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            line.tag = 110
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    
    @IBInspectable var bottomBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            line.tag = 110
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
        }
    }
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIColor {
    
    convenience init(rgb: UInt)
    {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(HexCode: Int) {
        self.init(
            red: (HexCode >> 16) & 0xFF,
            green: (HexCode >> 8) & 0xFF,
            blue: HexCode & 0xFF
        )
    }
    
    convenience init?(hexString: String) {
        guard let hex = hexString.hex else {
            return nil
        }
        self.init(HexCode: hex)
    }
}

public extension UIApplication {
    var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
    
    func openSettings() {
        let urlString = UIApplication.openSettingsURLString
        guard let url = URL(string: urlString) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}

extension UITableView {
    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)

        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
}

extension Int {
    var byteSize: String {
        return ByteCountFormatter().string(fromByteCount: Int64(self))
    }
}

extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }

    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Capture these recoverable error through fabric
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                return .none
            }
        }

        return self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }

}

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension UISlider {
    public func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        let percent = minimumValue + Float(location.x / bounds.width) * maximumValue
        setValue(percent, animated: true)
        sendActions(for: .valueChanged)
    }
}
