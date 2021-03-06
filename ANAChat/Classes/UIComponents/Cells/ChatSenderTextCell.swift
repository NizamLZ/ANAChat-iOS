//
//  ChatSenderTextCell.swift
//

import UIKit

class ChatSenderTextCell: UITableViewCell {

    @IBOutlet var senderTextCellView: UIView!
    @IBOutlet var textLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet weak var paddingImageView: UIImageView!
    @IBOutlet weak var arrowView: UIView!
    @IBOutlet weak var arrowViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    
    var shape = CAShapeLayer()
    var maskLayer = CAShapeLayer()
    
    override func awakeFromNib(){
        super.awakeFromNib()
        // Initialization code
        paddingImageView.backgroundColor = PreferencesManager.sharedInstance.getSenderThemeColor()
        cellBackgroundView?.layer.cornerRadius = 10.0
        textLbl?.font = PreferencesManager.sharedInstance.getContentFont()
        textLbl.textColor = UIConfigurationUtility.Colors.TextColor
        timeLbl?.font = UIConfigurationUtility.Fonts.TimeLblFont
        timeLbl?.alpha = 0.5

        self.arrowView.backgroundColor = UIColor.clear
        let trianglePath = CGMutablePath()
        trianglePath.move(to: CGPoint(x: 0, y: 0))
        trianglePath.addLine(to: CGPoint(x: 0, y: 16))
        trianglePath.addLine(to: CGPoint(x: 19, y: 0))
        
        shape.frame = self.arrowView.bounds
        shape.path = trianglePath
        shape.lineWidth = 2.0
        shape.strokeColor = PreferencesManager.sharedInstance.getSenderThemeColor().cgColor
        shape.fillColor = PreferencesManager.sharedInstance.getSenderThemeColor().cgColor
        self.arrowView.layer.insertSublayer(shape, at: 0)
        
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.shadowOffset = CGSize(width : 0, height : 2)
        self.shadowView.layer.shadowRadius = 2
        self.shadowView.layer.shadowOpacity = 1.0
        self.shadowView.layer.shadowColor = UIColor.init(hexString: "#6E6E6E").withAlphaComponent(0.35).cgColor
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect:senderTextCellView.bounds,
                                byRoundingCorners:[.topLeft, .bottomLeft],
                                cornerRadii: CGSize(width: 10, height:  10))

        maskLayer.path = path.cgPath

//        senderTextCellView.layer.mask = maskLayer
    }
    
    
    public func configureView(_ messageObject:Message, showArrow : Bool){
        if showArrow {
            self.arrowViewHeightConstraint.constant = 16
        }else{
            self.arrowViewHeightConstraint.constant = 0
        }
        
        if messageObject.syncedWithServer == true{
            self.statusImageView.image = CommonUtility.getImageFromBundle(name: "sentImage").withRenderingMode(.alwaysTemplate)
        }else{
            self.statusImageView.image = CommonUtility.getImageFromBundle(name: "sendingImage").withRenderingMode(.alwaysTemplate)
        }
        
        self.statusImageView.tintColor = PreferencesManager.sharedInstance.getBaseThemeColor()

        self.setNeedsLayout()
        if let simpleMessage = messageObject as? Simple{
            if let text = simpleMessage.text{
                self.textLbl.text = text
            }
        }else if let inputMessage = messageObject as? Input{
            switch inputMessage.inputType{
            case Int16(MessageInputType.MessageInputTypeOptions.rawValue),Int16(MessageInputType.MessageInputTypeList.rawValue):
                if let inputInfo = inputMessage.inputInfo as? NSDictionary{
                    if let text = inputInfo[Constants.kTextKey] as? String{
                        self.textLbl.text = text
                    }else if let text = inputInfo[Constants.kInputKey] as? String{
                        self.textLbl.text = text
                    }
                }
            case Int16(MessageInputType.MessageInputTypeDate.rawValue):
                if let inputDate = inputMessage as? InputDate{
                    let text = CommonUtility.getDateTextFromMessageObject(inputDate)
                    self.textLbl.text = text
                }
            case Int16(MessageInputType.MessageInputTypeTime.rawValue):
                if let inputTime = inputMessage as? InputTime{
                    let text = CommonUtility.getTimeTextFromMessageObject(inputTime)
                    self.textLbl.text = text
                }
            case Int16(MessageInputType.MessageInputTypeAddress.rawValue):
                if let inputAddress = inputMessage as? InputAddress{
                    let text = CommonUtility.getAddressTextFromMessageObject(inputAddress)
                    self.textLbl.text = text
                }
            default:
                if let inputInfo = inputMessage.inputInfo as? NSDictionary{
                    if let text = inputInfo[Constants.kValKey] as? String{
                        self.textLbl.text = text
                    }else if let text = inputInfo[Constants.kInputKey] as? String{
                        self.textLbl.text = text
                    }
                }
                break
            }
            
        }else if let carousel = messageObject as? Carousel{
            if let inputInfo = carousel.inputInfo as? NSDictionary{
                if let text = inputInfo[Constants.kTextKey] as? String{
                    self.textLbl.text = text
                }else if let value = inputInfo[Constants.kValKey] as? String{
                    self.textLbl.text = value
                }else if let text = inputInfo[Constants.kInputKey] as? String{
                    self.textLbl.text = text
                }
            }
        }
        
        if let messageTimeStamp = messageObject.timestamp{
            self.timeLbl.text = CommonUtility.getTimeString(messageTimeStamp)
        }else{
            self.timeLbl.text = ""
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
