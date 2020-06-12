//
//  MessageTableViewCell.swift
//  ChattingRoom
//
//  Created by on 2020/6/10.
//  Copyright © 2020 Holo. All rights reserved.
//

import UIKit
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let Width_Ratio6 = ScreenWidth / 375.0
let Height_Ratio6 = (ScreenHeight / 667.0 >= 1 ? 1 : ScreenHeight / 667.0)

class MessageTableViewCell: UITableViewCell {
    var headImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    var bubbleImgView = UIImageView(frame: .zero)
    var contentLabel = UILabel(frame: .zero)
    var msgModel:MessageModel = MessageModel(){
        didSet{
            self.changeContent()
        }
    }
    func changeContent(){
        var headFrame = headImgView.frame
        headFrame.origin.x = msgModel.isMine==true ? ScreenWidth - 50 : 10
        headImgView.frame = headFrame
        headImgView.image = UIImage(named: (msgModel.isMine==true ? "me.jpg":"you.jpg"))
        var bubbleFrame = bubbleImgView.frame
        let message:String = msgModel.message ?? ""
        //宽度限定、高度可变
        let contentRect:CGRect = message.boundingRect(with: CGSize(width: 200 * Width_Ratio6, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)], context: nil)
        let contentSize = contentRect.size
        let originX = msgModel.isMine==true ? (ScreenWidth - 50 - (contentSize.width + 10)) : 50
        let originY = contentSize.height > 30 ? contentSize.height + 30 : 50
        bubbleFrame.origin.x = originX
        let bubbleImgName = msgModel.isMine == true ? "my_bubble":"thy_bubble"
        //图像拉伸
        bubbleImgView.image = UIImage(named: bubbleImgName)?.stretchableImage(withLeftCapWidth: 10, topCapHeight: 15)

        bubbleFrame.size.width = contentSize.width + 10
        bubbleFrame.size.height = originY
        bubbleImgView.frame = bubbleFrame

        var labelFrame = contentLabel.frame
        labelFrame.origin.x = 5
        labelFrame.origin.y = 5
        labelFrame.size.width = contentSize.width
        labelFrame.size.height = bubbleFrame.size.height - 10
        contentLabel.text = msgModel.message ?? ""
        contentLabel.frame = labelFrame
        contentLabel.textColor = msgModel.isMine == true ? UIColor.red : UIColor.purple
        self.frame.size.height = originY
    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initWithSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initWithSubViews(){
        headImgView.layer.cornerRadius = 20;
        headImgView.layer.masksToBounds = true
        contentView.addSubview(headImgView)
        contentView.addSubview(bubbleImgView)
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byCharWrapping
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        bubbleImgView.addSubview(contentLabel)
    }



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
