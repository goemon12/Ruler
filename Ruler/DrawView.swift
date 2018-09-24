//
//  DrawView.swift
//  Ruler
//
//  Created by Tadahiro Kato on 2017/10/27.
//  Copyright © 2017年 goemon. All rights reserved.
//

import UIKit

class DrawView: UIView {
    let color = [
        UIColor.black,
        UIColor.white,
        UIColor.red,
        UIColor.green,
        UIColor.blue]
    
    let sc_w: CGFloat = UIScreen.main.bounds.width
    let sc_h: CGFloat = UIScreen.main.bounds.height
    var sc_s: CGFloat = 0.0
    var ptmm: CGFloat = 0.0
    var ptin: CGFloat = 0.0
    var start: CGFloat = UIScreen.main.bounds.height / 2

    //0:黒 1:白 2:赤 3:緑 4:青
    var color1: Int = 0 //背景(mm)
    var color2: Int = 1 //文字(mm)
    var color3: Int = 1 //背景(inch)
    var color4: Int = 0 //文字(inch)

    func pt2mm(pt: CGFloat) -> CGFloat {
        return (pt - start) / ptmm
    }
    
    func pt2in(pt: CGFloat) -> CGFloat {
        return (pt - start) / ptin
    }
    
    override func draw(_ rect: CGRect) {
        if (UserDefaults().object(forKey: "color1") != nil) {
            color1 = UserDefaults().integer(forKey: "color1")
            color2 = UserDefaults().integer(forKey: "color2")
            color3 = UserDefaults().integer(forKey: "color3")
            color4 = UserDefaults().integer(forKey: "color4")
        }
        
        switch UIScreen.main.nativeBounds.height {
        case 1136.0://シミュレータ4.0、Apple HP仕様
            sc_s = 4.0
        case 1334.0://シミュレータ4.7、Apple HP仕様
            sc_s = 4.7
        case 1920.0://実機5.5、Apple HP仕様
            sc_s = 5.5
        case 2208.0://シミュレータ5.5
            sc_s = 5.5
        case 2436.0://シミュレータ5.8、Apple HP仕様
            sc_s = 5.8
        case 1792.0://シミュレータ6.1、Apple HP仕様
            sc_s = 6.1
        case 2688.0://シミュレータ6.5、Apple HP仕様
            sc_s = 6.5
        default:
            sc_s = 3.5
        }
        
        ptmm = sqrt(sc_w * sc_w + sc_h * sc_h) / (sc_s * 25.4) //1.0mmのpt数
        ptin = sqrt(sc_w * sc_w + sc_h * sc_h) / (sc_s * 10.0) //0.1inのpt数
        
        let context = UIGraphicsGetCurrentContext()
        let font = UIFont(name: "Courier", size: 20.0)!
        let style = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.alignment = NSTextAlignment.center
        
        context!.setFillColor(color[color1].cgColor)
        context!.fill(CGRect(x: 0, y: 0, width: sc_w / 2, height: sc_h))
        
        
        for i in Int(pt2mm(pt: 0)) ... Int(pt2mm(pt: sc_h)) {
            context!.setStrokeColor(color[color2].cgColor)
            if (i % 10 == 0) {
                context!.setLineWidth(2.0)
                context!.beginPath()
                context!.move(to: CGPoint(x: 0, y: CGFloat(i) * ptmm + start))
                context!.addLine(to: CGPoint(x: sc_w / 4, y: CGFloat(i) * ptmm + start))
                context!.strokePath()
                
                let attr = [
                    NSAttributedStringKey.font: font,
                    NSAttributedStringKey.foregroundColor: color[color2],
                    NSAttributedStringKey.paragraphStyle: style]
                
                let rect = CGRect(x: sc_w / 4, y: CGFloat(i) * ptmm + start - 10,
                                  width: sc_w / 4, height: 20)
                
                NSString(format: "%3d mm", i).draw(in: rect, withAttributes: attr)
            }
            else if (abs(i % 10) == 5) {
                context!.setLineWidth(1.0)
                context!.move(to: CGPoint(x: 0, y: CGFloat(i) * ptmm + start))
                context!.addLine(to: CGPoint(x: sc_w / 5, y: CGFloat(i) * ptmm + start))
                context!.strokePath()
            }
            else {
                context!.setLineWidth(0.5)
                context!.move(to: CGPoint(x: 0, y: CGFloat(i) * ptmm + start))
                context!.addLine(to: CGPoint(x: sc_w / 6, y: CGFloat(i) * ptmm + start))
                context!.strokePath()
            }
        }

        context!.setFillColor(color[color3].cgColor)
        context!.fill(CGRect(x: sc_w / 2, y: 0, width: sc_w / 2, height: sc_h))
        context!.setStrokeColor(color[color4].cgColor)

        for i in Int(pt2in(pt: 0)) ... Int(pt2in(pt: sc_h)) {
            if (i % 10 == 0) {
                context!.setLineWidth(2.0)
                context!.beginPath()
                context!.move(to: CGPoint(x: sc_w, y: CGFloat(i) * ptin + start))
                context!.addLine(to: CGPoint(x: sc_w - sc_w / 4, y: CGFloat(i) * ptin + start))
                context!.strokePath()
                
                let attr = [
                    NSAttributedStringKey.font: font,
                    NSAttributedStringKey.foregroundColor: color[color4],
                    NSAttributedStringKey.paragraphStyle: style]
                
                let rect = CGRect(x: sc_w / 2, y: CGFloat(i) * ptin + start - 10,
                                  width: sc_w / 4, height: 20)
                
                NSString(format: "%2d inch", i / 10).draw(in: rect, withAttributes: attr)
            }
            else if (abs(i % 10) == 5) {
                context!.setLineWidth(1.0)
                context!.move(to: CGPoint(x: sc_w, y: CGFloat(i) * ptin + start))
                context!.addLine(to: CGPoint(x: sc_w - sc_w / 5, y: CGFloat(i) * ptin + start))
                context!.strokePath()
            }
            else {
                context!.setLineWidth(0.5)
                context!.move(to: CGPoint(x: sc_w, y: CGFloat(i) * ptin + start))
                context!.addLine(to: CGPoint(x: sc_w - sc_w / 6, y: CGFloat(i) * ptin + start))
                context!.strokePath()
            }
        }
        
        //中線
        context!.setStrokeColor(color[color2].cgColor)
        context!.setLineWidth(3.0)
        context!.beginPath()
        context!.move(to: CGPoint(x: 0, y: start))
        context!.addLine(to: CGPoint(x: sc_w / 4, y: start))
        context!.strokePath()
        
        context!.setStrokeColor(color[color4].cgColor)
        context!.setLineWidth(3.0)
        context!.beginPath()
        context!.move(to: CGPoint(x: sc_w - sc_w / 4, y: start))
        context!.addLine(to: CGPoint(x: sc_w, y: start))
        context!.strokePath()
    }
}
