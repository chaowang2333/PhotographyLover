//
//  TagDisplayView.swift
//  CBE
//
//  Created by crow on 22/11/2018.
//

import UIKit

class TagDisplayView: UIView {
    
    var imgView : UIImageView?
    var textLabel : UILabel?
    var pointView : UIImageView?
    var smallPointView : UIView?
    var timer : Timer?
    
    static let POINT_WIDTH : CGFloat = 11
    static let TAG_HEIGHT : CGFloat = (53/2.0-3)
    static let TAG_FONT_SIZE : Int = 11
    static let SMALL_POINT_WIDTH : CGFloat = 5
    var tagData : TagData?
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // layout
        imgView = UIImageView()
        imgView?.alpha = 0.75
        self.addSubview(imgView!)
        
        textLabel = UILabel()
        textLabel?.textColor = UIColor.white
        textLabel?.backgroundColor = UIColor.clear
        textLabel?.font = UIFont.systemFont(ofSize: 11)
        textLabel?.textAlignment = NSTextAlignment.center
        self.addSubview(textLabel!)
        
        pointView = UIImageView()
        pointView?.image = UIImage(named:"point")
        pointView?.alpha = 0.3
        pointView?.frame = CGRect(x: 0, y: 0, width: TagDisplayView.POINT_WIDTH, height: TagDisplayView.POINT_WIDTH)
        timer = Timer(timeInterval: 1.2, target: self, selector: #selector(flash), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
        self.addSubview(pointView!)
        
        smallPointView = UIView()
        smallPointView?.backgroundColor = UIColor.white
        smallPointView?.frame = CGRect(x: 0, y: 0, width: TagDisplayView.SMALL_POINT_WIDTH, height: TagDisplayView.SMALL_POINT_WIDTH)
        smallPointView?.layer.cornerRadius = TagDisplayView.SMALL_POINT_WIDTH/2.0
        smallPointView?.layer.masksToBounds = true
        self.addSubview(smallPointView!)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // animation
    func flash() {
        UIView.animate(withDuration: 0.8, animations: {
            self.pointView!.bounds = CGRect(x: 0, y: 0, width: TagDisplayView.SMALL_POINT_WIDTH + 0.2, height: TagDisplayView.SMALL_POINT_WIDTH + 0.2)
        }) { (finished) in
            self.pointView?.bounds = CGRect(x: 0, y: 0, width: TagDisplayView.POINT_WIDTH, height: TagDisplayView.POINT_WIDTH)
        }
    }

    // set tag information
    public func setData(tagData: TagData) {
        self.tagData = tagData
        self.textLabel?.text = tagData.text
        self.frame = self.getTagFrame()
    }

    // get tag frame
    func getTagFrame() -> CGRect{
        let tagPadding = 3 as CGFloat
        let text = (self.textLabel?.text)! as String
        var size = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: TagDisplayView.TAG_HEIGHT), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), context: nil).size
        size.width += tagPadding
        
        let deviceSize = UIScreen.main.bounds.size
        var frame = CGRect()
        frame.origin.x = (tagData?.left)! * deviceSize.width/100.0
        frame.origin.y = (tagData?.top)! * deviceSize.width/100.0
        frame.size.height = TagDisplayView.TAG_HEIGHT
        frame.size.width = size.width + TagDisplayView.POINT_WIDTH
        
        // check orientation
        if tagData?.orientation == 0
        {
            var image = UIImage(named: "tag1")
            image = image?.resizableImage(withCapInsets: UIEdgeInsetsMake((image?.size.height)!/2.0, (image?.size.width)!/4.0*3.0-0.1, (image?.size.height)!/2.0, (image?.size.width)!/4.0))
            let size = frame.size
            frame.size.width += (27+6)/43.0*(image?.size.width)!
            frame.origin.y -= TagDisplayView.TAG_HEIGHT/2.0
            imgView?.frame = CGRect(x:TagDisplayView.POINT_WIDTH, y: 0, width: frame.size.width-TagDisplayView.POINT_WIDTH, height: frame.size.height)
            imgView?.image = image
        
            textLabel?.frame = CGRect(x: TagDisplayView.POINT_WIDTH+27/43.0*image!.size.width-2, y: 0, width: size.width-TagDisplayView.POINT_WIDTH, height: frame.size.height)
            pointView?.frame = CGRect(x:0, y: TagDisplayView.TAG_HEIGHT/2.0-TagDisplayView.POINT_WIDTH/2.0, width: TagDisplayView.POINT_WIDTH, height: TagDisplayView.POINT_WIDTH)
            smallPointView?.center = (pointView?.center)!
        }
        else if (tagData?.orientation == 1)
        {
            var image = UIImage(named:"tag2")
            image = image?.resizableImage(withCapInsets: UIEdgeInsetsMake((image?.size.height)!/2.0, (image?.size.width)!/4.0, (image?.size.height)!/2.0, (image?.size.width)!/4.0*3.0-0.1))
            let size = frame.size
            frame.size.width += (27+6)/43.0*(image?.size.width)!
            frame.origin.x -= frame.size.width
            frame.origin.y -= TagDisplayView.TAG_HEIGHT/2.0
            imgView?.frame = CGRect(x: 0, y: 0, width: frame.size.width-TagDisplayView.POINT_WIDTH, height: frame.size.height)
            imgView?.image = image
            
            textLabel?.frame = CGRect(x: tagPadding+2, y: 0, width: size.width-TagDisplayView.POINT_WIDTH, height: frame.size.height)
            pointView?.frame = CGRect(x: frame.size.width-TagDisplayView.POINT_WIDTH, y: TagDisplayView.TAG_HEIGHT/2.0-TagDisplayView.POINT_WIDTH/2.0, width: TagDisplayView.POINT_WIDTH, height: TagDisplayView.POINT_WIDTH)
            smallPointView?.center = (pointView?.center)!
        }
        return frame
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
