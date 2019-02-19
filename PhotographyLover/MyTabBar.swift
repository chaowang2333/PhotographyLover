//
//  MyTabBar.swift
//  PhotographyLover
//  (for future use)
//  Created by wc on 14/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit

protocol MyTabBarDelegate {
    // tab button selected
    func tabBar(tabBar: MyTabBar, selectedButtonfrom: Int, to: Int)
    // middle button clicked
    func tabBardidClickMiddleBtn(tabBar: MyTabBar)
}

class MyTabBar: UIView {
    
    var buttons : NSMutableArray = []
    var curButton : MyTabBarButton?
    var selectedButton : MyTabBarButton?
    var delegate : MyTabBarDelegate?
    var middleButton : UIButton?

    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let middleButton = UIButton()
        middleButton.backgroundColor = UIColor(hexString: "fe2b34")
        middleButton.layer.cornerRadius = 6
        middleButton.layer.masksToBounds = true
        
        let image = UIImage(named: "camera")
        //image?.imageRendererFormat = UIImageRenderingMode.alwaysOriginal
        middleButton.setImage(image, for: UIControlState.normal)
        self.addSubview(middleButton)
        
        middleButton.addTarget(self, action: #selector(middleBtnClick), for: UIControlEvents.touchDown)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // add tab button
    func addTabbarButton(item: UITabBarItem) {
        
        let btn = MyTabBarButton()
        btn.setImage(item.image, for: UIControlState.normal)
        btn.setImage(item.selectedImage, for: UIControlState.selected)
        self.addSubview(btn)
        
        //set tag
        btn.tag = self.buttons.count
        self.buttons.add(btn)
        
        btn.addTarget(self, action: #selector(btnOnClick), for: UIControlEvents.touchDown)
        // default selected
        if (self.buttons.count == 1)
        {
            self.btnOnClick(btn: btn)
        }

    }
    
    // button clicked
    func btnOnClick(btn: MyTabBarButton) {
        self.curButton = btn;
        if (btn.tag == 2 || btn.tag == 4)
        {
            // login check
            
            self.selectTab()
            return;
        }
        else
        {
            self.selectTab()
        }
    }
    
    // select tab
    func selectTab() {
        // select tab delegate
        self.delegate?.tabBar(tabBar: self, selectedButtonfrom: (self.selectedButton?.tag)!, to: (curButton?.tag)!)
        
        // cancel last selected button
        self.selectedButton?.isSelected = false;
        // select current button
        self.curButton?.isSelected = true;
        // record selected button
        self.selectedButton = curButton;
    }
    
    // set subview layout
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupMiddleBtnFrame()
        self.setupOtherBtnFrame()
    }

    // set button frame except middle button
    func setupOtherBtnFrame() {
        for i in 0..<self.buttons.count {
            let btn = self.buttons[i] as! MyTabBarButton
            var x : CGFloat = 0
            if i >= self.buttons.count / 2 {
                x = CGFloat(i + 1) * btn.frame.width
            }
            else {
                x = CGFloat(i) * btn.frame.width
            }
            
            btn.frame = CGRect(x: x, y: 0, width: self.frame.width / CGFloat(self.buttons.count + 1), height: self.frame.height)
        }
    }
    
    // set frame for middle button
    func setupMiddleBtnFrame() {
        self.middleButton?.bounds = CGRect(x: 0, y: 0, width: 112/2.0, height: 68/2.0)
        self.middleButton?.center = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5)
    }
    
    // middle button clicked
    func middleBtnClick() {
        self.delegate?.tabBardidClickMiddleBtn(tabBar: self)
    }
}
