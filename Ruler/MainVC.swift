//
//  MainVC.swift
//  Ruler
//
//  Created by Tadahiro Kato on 2017/10/25.
//  Copyright © 2017年 goemon. All rights reserved.
//

import UIKit
import NendAd

class MainVC: UIViewController, NADNativeDelegate {
    private var client: NADNativeClient!
    @IBOutlet weak var nadView: UIView!
    @IBOutlet weak var nadImage: UIImageView!
    @IBOutlet weak var nadPrLbl: UILabel!
    @IBOutlet weak var nadText: UILabel!
    @IBOutlet weak var layoutNadView: NSLayoutConstraint!
    
    @IBOutlet var drawView: DrawView!
    var point1: CGPoint!
    var point2: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //広告を引っ込めておく
        self.layoutNadView.constant = -200
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

        self.client = NADNativeClient(spotId: "697897", apiKey: "6085c8209d23a39449ca076e7914c5ab1919797a")
        
        self.client.load(completionBlock: {
            (ad, error) in
            if ad != nil {
                self.nativeLoad(ad: ad!)
            }
            else {
                self.nativeFail()
            }
        })
        
        self.client.enableAutoReload(withInterval: 30.0, completionBlock: {
            (ad, error) in
            if ad != nil {
                self.nativeLoad(ad: ad!)
            }
            else {
                self.nativeFail()
            }
        })
    }

    func nativeLoad(ad: NADNative) {
        self.nadPrLbl.text = ad.prText(for: .PR)
        self.nadText.text = ad.longText

        ad.loadAdImage(completionBlock: {
            (loadAdImage) in
            self.nadImage.image = loadAdImage
        })
        ad.activateAdView(self.nadView, withPrLabel: self.nadPrLbl)
        
        self.layoutNadView.constant = 50
        self.view.setNeedsLayout()
        
        UIView.animate(withDuration: 1.0, animations: {
            () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func nativeFail() {
        self.layoutNadView.constant = -200
        self.view.setNeedsLayout()
        
        UIView.animate(withDuration: 1.0, animations: {
            () -> Void in
            self.view.layoutIfNeeded()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    @IBAction func BackMain(segue: UIStoryboardSegue) {
        let vc = segue.source as! SettingVC
        UserDefaults().set(vc.color1, forKey: "color1")
        UserDefaults().set(vc.color2, forKey: "color2")
        UserDefaults().set(vc.color3, forKey: "color3")
        UserDefaults().set(vc.color4, forKey: "color4")
        drawView.setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        point1 = touch.location(in: self.view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        point2 = touch.location(in: self.view)

        let dy: CGFloat = point2.y - point1.y
        let min: CGFloat = 0.0
        let max: CGFloat = drawView.bounds.height
        
        drawView.start += dy
        if (drawView.start < min) {
            drawView.start = min
        }
        else if (drawView.start > max) {
            drawView.start = max
        }
        
        point1 = point2
        drawView.setNeedsDisplay()
    }
}
