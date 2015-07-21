//
//  StringUtils.swift
//  AppFramework
//


import UIKit

class StringUtils: NSObject {
    
}


extension String {
    
    var length: Int { return count(self) }
    
    func isBlank() -> Bool {
        return self.length == 0
    }
    
    func isBlankByTrimming() -> Bool {
        var tmp: NSString = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return tmp.length == 0
    }
    
    func toNSString() -> NSString {
        var s: NSString = NSString(CString: self.cStringUsingEncoding(NSUTF8StringEncoding)!,
            encoding: NSUTF8StringEncoding)!
        return s
    }
    
    func heightWithWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let str = self.toNSString()
        let attributedText = NSAttributedString(string: str as String, attributes: [NSFontAttributeName : font])
        let rect = attributedText.boundingRectWithSize(CGSizeMake(width, CGFloat.max), options:NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return rect.height
    }
    
    
    
    func widthWithHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let str = self.toNSString()
        let attributedText = NSAttributedString(string: str as String, attributes: [NSFontAttributeName : font])
        let rect = attributedText.boundingRectWithSize(CGSizeMake(CGFloat.max, height), options:NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return rect.width
    }
    
    func numberOfLines() -> Int {
        return self.componentsSeparatedByString("\n").count + 1
    }
    
    var md5: String {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        var hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.destroy()
        
        return String(format: hash as String)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluateWithObject(self)
    }
    
}


extension NSAttributedString {
    
    func heightWithWidth(width: CGFloat) -> CGFloat {
        let rect = self.boundingRectWithSize(CGSizeMake(width, CGFloat.max), options:NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return rect.height
    }
    
    
    
    
}



