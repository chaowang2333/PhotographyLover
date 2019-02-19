//
//  TagView.swift
//  CBE
//
//  Created by crow on 22/11/2018.
//

import UIKit

protocol TagDeleteDelegate {
    func removeTagWithTag(tagView: TagView)
}

class TagView: TagDisplayView {

    var longPress : UILongPressGestureRecognizer?
    var tmpPoint : CGPoint?
    var delegate : TagDeleteDelegate?
  
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(changeSide))
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeTag))
        self.addGestureRecognizer(longPress!)
        // tap need long press fail
        tap.require(toFail: longPress!)
        self.addGestureRecognizer(tap)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // remove tag
    func removeTag() {
        delegate?.removeTagWithTag(tagView: self)
    }
    
    // touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        // record current position
        tmpPoint = touch?.location(in: self.superview)
        super.touchesBegan(touches, with: event)
    }
    
    // change side
    func changeSide(gesture: UILongPressGestureRecognizer) {
        if gesture.state != UIGestureRecognizerState.began {
            return
        }
        let text = (self.textLabel?.text)! as String
        var size = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: TagDisplayView.TAG_HEIGHT), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), context: nil).size
        size.width += 3
        
        let image = UIImage(named: "tag1")
        size.width += (27+6)/43.0*(image?.size.width)! + TagDisplayView.POINT_WIDTH
        
        let deviceSize = UIScreen.main.bounds.size
        // check orientation
        if tagData?.orientation == 0
        {
            self.tagData?.orientation = 1
            var leftF = CGFloat((self.tagData?.left)!)
            leftF += CGFloat(size.width/deviceSize.width*100.0)
            self.tagData?.left = leftF
        }
        else
        {
            self.tagData?.orientation = 0
            var leftF = CGFloat((self.tagData?.left)!)
            leftF -= CGFloat(size.width/deviceSize.width*100.0)
            self.tagData?.left = leftF
        }
        let frame = self.getTagFrame()
        self.frame = frame
    }
    
    // touch moves
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        var curPoint = touch?.location(in: self.superview)
        
        var x = CGFloat((curPoint?.x)! - (tmpPoint?.x)!)
        var y = CGFloat((curPoint?.y)! - (tmpPoint?.y)!)
        let tmpLeft = self.tagData?.left
        let tmpTop = self.tagData?.top
        
        let deviceSize = UIScreen.main.bounds.size
        x += tmpLeft!*deviceSize.width/100.0
        y += tmpTop!*deviceSize.width/100.0
        
        self.tagData?.top = y/deviceSize.width*100
        self.tagData?.left = x/deviceSize.width*100
        
        let frame = self.getTagFrame()
        if frame.origin.x<0 || frame.origin.y<0 || frame.origin.x+frame.size.width>deviceSize.width || frame.origin.y+frame.size.height>deviceSize.width
        {
            self.tagData?.left = tmpLeft
            self.tagData?.top = tmpTop
            return
        }
        self.frame = frame
        tmpPoint = curPoint
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
