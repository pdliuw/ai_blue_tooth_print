//
//  PDResetImage.swift
//  PrinterDemo
//
//  Created by ios on 2019/9/11.
//  Copyright © 2019 XiamenHY. All rights reserved.
//

import UIKit

class PDResetImage: NSObject {

    static func scaleSourceImage(image:UIImage, width:CGFloat, height:CGFloat) -> UIImage? {
        
        //该处绘制图片是向上取整
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: width, height: height), true, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .high
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
        image.draw(in: CGRect.init(x: 0, y: 0, width: width, height: height))
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaleImage
    }
    
    static func scaleImageForWidth(image:UIImage, width:CGFloat) -> UIImage? {
        
        let imageW = image.size.width
        let imageH = image.size.height
        var maxH : CGFloat = 0
//        if imageW > width {
//
//        }else {
//            return image
//        }
        //此处将高度取整
        maxH = CGFloat(Int(width * imageH / imageW))
        return self.scaleSourceImage(image: image, width: width, height: maxH)
    }
}
