//
//  SettingVC.swift
//  Ruler
//
//  Created by Tadahiro Kato on 2017/10/25.
//  Copyright © 2017年 goemon. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    @IBOutlet weak var selColor1: UISegmentedControl!
    @IBOutlet weak var selColor2: UISegmentedControl!
    @IBOutlet weak var selColor3: UISegmentedControl!
    @IBOutlet weak var selColor4: UISegmentedControl!
    
    //0:黒 1:白 2:赤 3:緑 4:青
    var color1: Int = 0 //背景(mm)
    var color2: Int = 1 //文字(mm)
    var color3: Int = 1 //背景(inch)
    var color4: Int = 0 //文字(inch)

    override func viewDidLoad() {
        super.viewDidLoad()

        if (UserDefaults().object(forKey: "color1") != nil) {
            color1 = UserDefaults().integer(forKey: "color1")
            color2 = UserDefaults().integer(forKey: "color2")
            color3 = UserDefaults().integer(forKey: "color3")
            color4 = UserDefaults().integer(forKey: "color4")
        }
        selColor1.selectedSegmentIndex = color1
        selColor2.selectedSegmentIndex = color2
        selColor3.selectedSegmentIndex = color3
        selColor4.selectedSegmentIndex = color4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//  }

    @IBAction func chgColor1(_ sender: UISegmentedControl) {
        color1 = sender.selectedSegmentIndex
    }
    @IBAction func chgColor2(_ sender: UISegmentedControl) {
        color2 = sender.selectedSegmentIndex
    }
    @IBAction func chgColor3(_ sender: UISegmentedControl) {
        color3 = sender.selectedSegmentIndex
    }
    @IBAction func chgColor4(_ sender: UISegmentedControl) {
        color4 = sender.selectedSegmentIndex
    }
}
