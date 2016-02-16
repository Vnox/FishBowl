

import Foundation
import UIKit
import CoreData


class JSSAlertView: UIViewController {
    
    var containerView:UIView!
    var alertBackgroundView:UIView!
    var dismissButton:UIButton!
    var cancelButton:UIButton!
    var buttonLabel:UILabel!
    var cancelButtonLabel:UILabel!
    var titleLabel:UILabel!
    var textView:UITextView!
    weak var rootViewController:UIViewController!
    var iconImage:UIImage!
    var iconImageView:UIImageView!
    var closeAction:(()->Void)!
    var cancelAction:(()->Void)!
    var isAlertOpen:Bool = false
    var event = [NSManagedObject]()

    
    // Leon Added text field & slider
    var myTextField:UITextField!
    var mySegcontrol:UISegmentedControl!
    var myTimeDisplay:UIImageView!
    var myTimeLabel:UILabel!
    
    // Leon the dial - oh damn this is so complicated
    var button0:UIButton!
    var button1:UIButton!
    var button2:UIButton!
    var button3:UIButton!
    var button4:UIButton!
    var button5:UIButton!
    var button6:UIButton!
    var button7:UIButton!
    var button8:UIButton!
    var button9:UIButton!
    var buttoncon:UIButton!
    var buttondel:UIButton!

    
    enum FontType {
        case Title, Text, Button
    }
    var titleFont = "HelveticaNeue-Light"
    var textFont = "HelveticaNeue"
    var buttonFont = "HelveticaNeue-Bold"
    
    var defaultColor = UIColorFromHex(0xF2F4F4, alpha: 1)
    
    enum TextColorTheme {
        case Dark, Light
    }
    var darkTextColor = UIColorFromHex(0x000000, alpha: 0.75)
    var lightTextColor = UIColorFromHex(0xffffff, alpha: 0.9)
    
    enum ActionType {
        case Close, Cancel
    }
    
    let baseHeight:CGFloat = 160.0
    var alertWidth:CGFloat = 290.0
    let buttonHeight:CGFloat = 70.0
    let padding:CGFloat = 20.0
    
    var viewWidth:CGFloat?
    var viewHeight:CGFloat?
    
    // Allow alerts to be closed/renamed in a chainable manner
    class JSSAlertViewResponder {
        let alertview: JSSAlertView
        
        init(alertview: JSSAlertView) {
            self.alertview = alertview
        }
        
        func addAction(action: ()->Void) {
            self.alertview.addAction(action)
        }
        
        func addCancelAction(action: ()->Void) {
            self.alertview.addCancelAction(action)
        }
        
        func setTitleFont(fontStr: String) {
            self.alertview.setFont(fontStr, type: .Title)
        }
        
        func setTextFont(fontStr: String) {
            self.alertview.setFont(fontStr, type: .Text)
        }
        
        func setButtonFont(fontStr: String) {
            self.alertview.setFont(fontStr, type: .Button)
        }
        
        func setTextTheme(theme: TextColorTheme) {
            self.alertview.setTextTheme(theme)
        }
        
        func getTextfieldText() -> String{
            return self.alertview.myTextField.text!
        }
        
        @objc func close() {
            self.alertview.closeView(false)
        }
    }
    
    func setFont(fontStr: String, type: FontType) {
        switch type {
        case .Title:
            self.titleFont = fontStr
            if let font = UIFont(name: self.titleFont, size: 24) {
                self.titleLabel.font = font
            } else {
                self.titleLabel.font = UIFont.systemFontOfSize(24)
            }
        case .Text:
            if self.textView != nil {
                self.textFont = fontStr
                if let font = UIFont(name: self.textFont, size: 16) {
                    self.textView.font = font
                } else {
                    self.textView.font = UIFont.systemFontOfSize(16)
                }
            }
        case .Button:
            self.buttonFont = fontStr
            if let font = UIFont(name: self.buttonFont, size: 24) {
                self.buttonLabel.font = font
            } else {
                self.buttonLabel.font = UIFont.systemFontOfSize(24)
            }
        }
        // relayout to account for size changes
        self.viewDidLayoutSubviews()
    }
    
    func setTextTheme(theme: TextColorTheme) {
        switch theme {
        case .Light:
            recolorText(lightTextColor)
        case .Dark:
            recolorText(darkTextColor)
        }
    }
    
    func recolorText(color: UIColor) {
        titleLabel.textColor = color
        if textView != nil {
            textView.textColor = color
        }
        buttonLabel.textColor = color
        if cancelButtonLabel != nil {
            cancelButtonLabel.textColor = color
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let size = self.screenSize()
        self.viewWidth = size.width
        self.viewHeight = size.height
        
        var yPos:CGFloat = 0.0
        let contentWidth:CGFloat = self.alertWidth - (self.padding*2)
        
        // position the icon image view, if there is one
        if self.iconImageView != nil {
            yPos += iconImageView.frame.height
            let centerX = (self.alertWidth-self.iconImageView.frame.width)/2
            self.iconImageView.frame.origin = CGPoint(x: centerX, y: self.padding)
            yPos += padding
        }
        
        // position the title
        let titleString = titleLabel.text! as NSString
        let titleAttr = [NSFontAttributeName:titleLabel.font]
        let titleSize = CGSize(width: contentWidth, height: 90)
        let titleRect = titleString.boundingRectWithSize(titleSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: titleAttr, context: nil)
        yPos += padding
        self.titleLabel.frame = CGRect(x: self.padding, y: yPos, width: self.alertWidth - (self.padding*2), height: ceil(titleRect.size.height))
        yPos += ceil(titleRect.size.height)
        
        //Position text field Added by Leon
        self.myTextField.frame = CGRect(x: self.padding, y: yPos + 10, width: self.alertWidth - (self.padding * 2), height:ceil(titleRect.size.height))
        self.myTextField.backgroundColor = UIColor.whiteColor()
        self.myTextField.alpha = 0.8
        self.myTextField.placeholder = "Enter event name"
        self.myTextField.textAlignment = NSTextAlignment.Center
        self.myTextField.font = UIFont(name: "AvenirNext-Regular", size: 18)
        self.myTextField.borderStyle = UITextBorderStyle.RoundedRect
        
        yPos += self.padding * 2
        
        //Position timebox by Leon
        self.myTimeDisplay.frame = CGRect(x: self.padding, y: yPos + 10, width: self.alertWidth - (self.padding * 2), height:ceil(titleRect.size.height))
        self.myTimeDisplay.image = UIImage(named: "timebox")
        
        
        self.myTimeLabel.frame = myTimeDisplay.frame
        self.myTimeLabel.text = "Time"
        self.myTimeLabel.textAlignment = NSTextAlignment.Center
        self.myTimeLabel.font = UIFont(name: "AvenirNext-Regular", size: 18)
        self.myTimeLabel.textColor = UIColor.whiteColor()
        
        yPos += self.padding * 2 + 15
        
        // Posotion the dial by Leon
        let centerX = self.myTimeLabel.center.x - 10
        self.button1.frame = CGRect(x: centerX - 70, y: yPos + 10, width: 13 , height: 18 )
        self.button2.frame = CGRect(x: centerX, y: yPos + 10, width: 13 , height: 18 )
        self.button3.frame = CGRect(x: centerX + 70, y: yPos + 10, width: 13 , height: 18 )
        
        yPos += self.padding * 2
        
        self.button4.frame = CGRect(x: centerX - 70, y: yPos + 10, width: 13 , height: 18 )
        self.button5.frame = CGRect(x: centerX, y: yPos + 10, width: 13 , height: 18 )
        self.button6.frame = CGRect(x: centerX + 70, y: yPos + 10, width: 13 , height: 18 )
        
        yPos += self.padding * 2
        
        self.button7.frame = CGRect(x: centerX - 70, y: yPos + 10, width: 13 , height: 18 )
        self.button8.frame = CGRect(x: centerX, y: yPos + 10, width: 13 , height: 18 )
        self.button9.frame = CGRect(x: centerX + 70, y: yPos + 10, width: 13 , height: 18 )
        
        yPos += self.padding * 2
        
        self.button0.frame = CGRect(x: centerX - 70, y: yPos + 10, width: 13 , height: 19 )
        self.buttondel.frame = CGRect(x: centerX - 5, y: yPos + 10, width: 26 , height: 18 )
        self.buttoncon.frame = CGRect(x: centerX + 70 - 5, y: yPos + 10, width: 22 , height: 22 )

        
        
        self.button1.setBackgroundImage(UIImage(named: "1"), forState: UIControlState.Normal)
        self.button2.setBackgroundImage(UIImage(named: "2"), forState: UIControlState.Normal)
        self.button3.setBackgroundImage(UIImage(named: "3"), forState: UIControlState.Normal)
        self.button4.setBackgroundImage(UIImage(named: "4"), forState: UIControlState.Normal)
        self.button5.setBackgroundImage(UIImage(named: "5"), forState: UIControlState.Normal)
        self.button6.setBackgroundImage(UIImage(named: "6"), forState: UIControlState.Normal)
        self.button7.setBackgroundImage(UIImage(named: "7"), forState: UIControlState.Normal)
        self.button8.setBackgroundImage(UIImage(named: "8"), forState: UIControlState.Normal)
        self.button9.setBackgroundImage(UIImage(named: "9"), forState: UIControlState.Normal)
        self.button0.setBackgroundImage(UIImage(named: "0"), forState: UIControlState.Normal)
        self.buttoncon.setBackgroundImage(UIImage(named: "checkmark-circled"), forState: UIControlState.Normal)
        self.buttondel.setBackgroundImage(UIImage(named: "backspace"), forState: UIControlState.Normal)
        
        yPos += self.padding * 2 + 5

        
        //Position segcontrol by Leon
        self.mySegcontrol.layer.cornerRadius = 5.0
        self.mySegcontrol.tintColor = UIColor.whiteColor()
        self.mySegcontrol.frame = CGRect(x: self.padding, y: yPos + 10, width: self.alertWidth - (self.padding * 2), height:ceil(titleRect.size.height))
        
    
        
        yPos += self.padding * 2 + 10
        
        // position text
        if self.textView != nil {
            let textString = textView.text! as NSString
            let textAttr = [NSFontAttributeName:textView.font as! AnyObject]
            let realSize = textView.sizeThatFits(CGSizeMake(contentWidth, CGFloat.max))
            let textSize = CGSize(width: contentWidth, height: CGFloat(fmaxf(Float(90.0), Float(realSize.height))))
            let textRect = textString.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textAttr, context: nil)
            self.textView.frame = CGRect(x: self.padding, y: yPos, width: self.alertWidth - (self.padding*2), height: ceil(textRect.size.height)*2)
            yPos += ceil(textRect.size.height) + padding/2
        }
        
        // position the buttons
        yPos += self.padding
        
        var buttonWidth = self.alertWidth
        if self.cancelButton != nil {
            buttonWidth = self.alertWidth/2
            self.cancelButton.frame = CGRect(x: 0, y: yPos, width: buttonWidth-0.5, height: self.buttonHeight)
            if self.cancelButtonLabel != nil {
                self.cancelButtonLabel.frame = CGRect(x: self.padding, y: (self.buttonHeight/2) - 15, width: buttonWidth - (self.padding*2), height: 30)
            }
        }
        
        let buttonX = buttonWidth == self.alertWidth ? 0 : buttonWidth
        self.dismissButton.frame = CGRect(x: buttonX, y: yPos, width: buttonWidth, height: self.buttonHeight)
        if self.buttonLabel != nil {
            self.buttonLabel.frame = CGRect(x: self.padding, y: (self.buttonHeight/2) - 15, width: buttonWidth - (self.padding*2), height: 30)
        }
        
        // set button fonts
        if self.buttonLabel != nil {
            buttonLabel.font = UIFont(name: self.buttonFont, size: 20)
        }
        if self.cancelButtonLabel != nil {
            cancelButtonLabel.font = UIFont(name: self.buttonFont, size: 20)
        }
        
        yPos += self.buttonHeight
        
        // size the background view
        self.alertBackgroundView.frame = CGRect(x: 0, y: 0, width: self.alertWidth, height: yPos)
        
        // size the container that holds everything together
        self.containerView.frame = CGRect(x: (self.viewWidth!-self.alertWidth)/2, y: (self.viewHeight! - yPos)/2, width: self.alertWidth, height: yPos)
    }
    
    
    
    func info(viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil) -> JSSAlertViewResponder {
        let alertview = self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0x3498db, alpha: 1))
        alertview.setTextTheme(.Light)
        return alertview
    }
    
    func success(viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil) -> JSSAlertViewResponder {
        return self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0x2ecc71, alpha: 1))
    }
    
    func warning(viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil) -> JSSAlertViewResponder {
        return self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0xf1c40f, alpha: 1))
    }
    
    func danger(viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil) -> JSSAlertViewResponder {
        let alertview = self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0xe74c3c, alpha: 1))
        alertview.setTextTheme(.Light)
        return alertview
    }
    
    func show(viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil, color: UIColor?=nil, iconImage: UIImage?=nil) -> JSSAlertViewResponder {
        
        self.rootViewController = viewController.view.window!.rootViewController
        self.rootViewController.addChildViewController(self)
        self.rootViewController.view.addSubview(view)
        
        self.view.backgroundColor = UIColorFromHex(0x000000, alpha: 0.7)
        
        var baseColor:UIColor?
        if let customColor = color {
            baseColor = customColor
        } else {
            baseColor = self.defaultColor
        }
        let textColor = self.darkTextColor
        
        let sz = self.screenSize()
        self.viewWidth = sz.width
        self.viewHeight = sz.height
        
        self.view.frame.size = sz
        
        // Container for the entire alert modal contents
        self.containerView = UIView()
        self.view.addSubview(self.containerView!)
        
        // Background view/main color
        self.alertBackgroundView = UIView()
        alertBackgroundView.backgroundColor = baseColor
        alertBackgroundView.layer.cornerRadius = 4
        alertBackgroundView.layer.masksToBounds = true
        self.containerView.addSubview(alertBackgroundView!)
        
        // Icon
        self.iconImage = iconImage
        if self.iconImage != nil {
            self.iconImageView = UIImageView(image: self.iconImage)
            self.containerView.addSubview(iconImageView)
        }
        
        // Title
        self.titleLabel = UILabel()
        titleLabel.textColor = textColor
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: self.titleFont, size: 24)
        titleLabel.text = title
        self.containerView.addSubview(titleLabel)
        
        
        // TextField. Slider. LEON
        self.myTextField = UITextField()
        self.containerView.addSubview(myTextField)
        
        let myitems = ["Easy", "So-so", "Norm", "Hard", "Hell"]
        self.mySegcontrol = UISegmentedControl(items:myitems)
        self.mySegcontrol.selectedSegmentIndex = 0
        self.containerView.addSubview(mySegcontrol)
        
        self.myTimeDisplay = UIImageView()
        self.containerView.addSubview(myTimeDisplay)
        
        self.myTimeLabel = UILabel()
        self.containerView.addSubview(myTimeLabel)
        
        // Dial by Leon
        self.button1 = UIButton()
        self.button2 = UIButton()
        self.button3 = UIButton()
        self.button4 = UIButton()
        self.button5 = UIButton()
        self.button6 = UIButton()
        self.button7 = UIButton()
        self.button8 = UIButton()
        self.button9 = UIButton()
        self.button0 = UIButton()
        self.buttoncon = UIButton()
        self.buttondel = UIButton()
        self.containerView.addSubview(button1)
        self.containerView.addSubview(button2)
        self.containerView.addSubview(button3)
        self.containerView.addSubview(button4)
        self.containerView.addSubview(button5)
        self.containerView.addSubview(button6)
        self.containerView.addSubview(button7)
        self.containerView.addSubview(button8)
        self.containerView.addSubview(button9)
        self.containerView.addSubview(button0)
        self.containerView.addSubview(buttoncon)
        self.containerView.addSubview(buttondel)

        

        
        
        // View text
        if let text = text {
            self.textView = UITextView()
            self.textView.userInteractionEnabled = false
            textView.editable = false
            textView.textColor = textColor
            textView.textAlignment = .Center
            textView.font = UIFont(name: self.textFont, size: 16)
            textView.backgroundColor = UIColor.clearColor()
            textView.text = text
            self.containerView.addSubview(textView)
        }
        
        // Button
        self.dismissButton = UIButton()
        let buttonColor = UIImage.withColor(adjustBrightness(baseColor!, amount: 0.8))
        let buttonHighlightColor = UIImage.withColor(adjustBrightness(baseColor!, amount: 0.9))
        dismissButton.setBackgroundImage(buttonColor, forState: .Normal)
        dismissButton.setBackgroundImage(buttonHighlightColor, forState: .Highlighted)
        dismissButton.addTarget(self, action: "buttonTap", forControlEvents: .TouchUpInside)
        alertBackgroundView!.addSubview(dismissButton)
        // Button text
        self.buttonLabel = UILabel()
        buttonLabel.textColor = textColor
        buttonLabel.numberOfLines = 1
        buttonLabel.textAlignment = .Center
        if let text = buttonText {
            buttonLabel.text = text
        } else {
            buttonLabel.text = "OK"
        }
        dismissButton.addSubview(buttonLabel)
        
        // Second cancel button
        if let btnText = cancelButtonText {
            self.cancelButton = UIButton()
            let buttonColor = UIImage.withColor(adjustBrightness(baseColor!, amount: 0.8))
            let buttonHighlightColor = UIImage.withColor(adjustBrightness(baseColor!, amount: 0.9))
            cancelButton.setBackgroundImage(buttonColor, forState: .Normal)
            cancelButton.setBackgroundImage(buttonHighlightColor, forState: .Highlighted)
            cancelButton.addTarget(self, action: "cancelButtonTap", forControlEvents: .TouchUpInside)
            alertBackgroundView!.addSubview(cancelButton)
            // Button text
            self.cancelButtonLabel = UILabel()
            cancelButtonLabel.alpha = 1.0
            cancelButtonLabel.textColor = textColor
            cancelButtonLabel.numberOfLines = 1
            cancelButtonLabel.textAlignment = .Center
            if let text = cancelButtonText {
                cancelButtonLabel.text = text
            }
            
            cancelButton.addSubview(cancelButtonLabel)
        }
        
        // Animate it in
        self.view.alpha = 0
        UIView.animateWithDuration(0.2, animations: {
            self.view.alpha = 1
        })
        self.containerView.frame.origin.x = self.view.center.x
        self.containerView.center.y = -500
        UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.containerView.center = self.view.center
            }, completion: { finished in
                
        })
        
        isAlertOpen = true
        return JSSAlertViewResponder(alertview: self)
    }
    
    func addAction(action: ()->Void) {
        self.closeAction = action
    }
    
    func buttonTap() {
        closeView(true, source: .Close);
    }
    
    func addCancelAction(action: ()->Void) {
        self.cancelAction = action
    }
    
    func cancelButtonTap() {
        closeView(true, source: .Cancel);
    }
    
    func closeView(withCallback:Bool, source:ActionType = .Close) {
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.containerView.center.y = self.view.center.y + self.viewHeight!
            }, completion: { finished in
                UIView.animateWithDuration(0.2, animations: {
                    self.view.alpha = 0
                    }, completion: { finished in
                        if withCallback {
                            if let action = self.closeAction where source == .Close {
                                action()
                            }
                            else if let action = self.cancelAction where source == .Cancel {
                                action()
                            }
                        }
                        self.removeView()
                })
                
        })
        
        saveName(self.myTextField.text!)
    }
    
    func saveName(name: String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Entity",inManagedObjectContext:managedContext!)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        person.setValue(myTextField.text!, forKey: "name")

        
        //4
        do {
            try managedContext!.save()
            event.append(person)
            print("saved!")
            //5
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        testButton()
    }
    
    func testButton() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Entity")
        
        do{
            let results =
            try managedContext!.executeFetchRequest(fetchRequest)
            event = results as! [NSManagedObject]
            print(results)
        } catch let error as NSError {
            print("could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    func removeView() {
        isAlertOpen = false
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    
    func screenSize() -> CGSize {
        let screenSize = UIScreen.mainScreen().bounds.size
        if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
            return CGSizeMake(screenSize.height, screenSize.width)
        }
        return screenSize
    }
    
}





// Utility methods + extensions

// Extend UIImage with a method to create
// a UIImage from a solid color
//
// See: http://stackoverflow.com/questions/20300766/how-to-change-the-highlighted-color-of-a-uibutton
extension UIImage {
    class func withColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

// For any hex code 0xXXXXXX and alpha value,
// return a matching UIColor
func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

// For any UIColor and brightness value where darker <1
// and lighter (>1) return an altered UIColor.
//
// See: http://a2apps.com.au/lighten-or-darken-a-uicolor/
func adjustBrightness(color:UIColor, amount:CGFloat) -> UIColor {
    var hue:CGFloat = 0
    var saturation:CGFloat = 0
    var brightness:CGFloat = 0
    var alpha:CGFloat = 0
    if color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
        brightness += (amount-1.0)
        brightness = max(min(brightness, 1.0), 0.0)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    return color
}