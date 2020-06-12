//
//  ViewController.swift
//  ChattingRoom
//
//  Created by on 2020/6/10.
//  Copyright © 2020 Holo. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    let MessageTableCellIdentifier = "MessageTableCellIdentifier"
    var chatBar = UIView(frame:CGRect(x: 0, y: ScreenHeight - 40, width: ScreenWidth, height: 40))
    var messageTF = UITextField(frame: CGRect(x: 5, y: 3, width: ScreenWidth - 67, height: 34))
    var sendBtn = UIButton(type: .custom)
    var keyboardHeight:CGFloat = 0.0

    var dataSource = [MessageModel]()
    lazy var tableView:UITableView = {
        let tTableView = UITableView(frame: CGRect(x: 0, y: 20, width: ScreenWidth, height: ScreenHeight-60), style: .grouped)
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.backgroundColor = .white
        tTableView.separatorStyle = .none
        tTableView.allowsSelection = false
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableCellIdentifier)
        return tTableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initSendMessageView()

    }

    func initSendMessageView(){
        view.addSubview(tableView)
        chatBar.backgroundColor = .lightGray
        view.addSubview(chatBar)

        messageTF.placeholder = "请输入内容"
        messageTF.textColor = .black
        messageTF.borderStyle  = .roundedRect
        messageTF.delegate = self
        messageTF.clearsOnBeginEditing = true
        messageTF.clearButtonMode  = .always
        chatBar.addSubview(messageTF)

        sendBtn.frame = CGRect(x: ScreenWidth - 60, y: 3, width: 58, height: 34)
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.setTitleColor(.purple, for: .normal)
        sendBtn.layer.cornerRadius = 10
        sendBtn.backgroundColor = .white
        sendBtn.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        chatBar.addSubview(sendBtn)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAction(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAction(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        tableView.addGestureRecognizer(tap)
    }

    @objc func tapGestureAction(){
        messageTF.resignFirstResponder()
    }

    @objc func sendAction(){
        if messageTF.text?.isEmpty ?? true {
            return
        }
        let msgModel = MessageModel()
        msgModel.message = messageTF.text
        msgModel.isMine = true
        //发送消息
        self.sendMessage(msgModel: msgModel)

        messageTF.text = ""
        let newModel = MessageModel()
        newModel.message = arc4random()%2 == 1 ? "What‘s your problem？" : "What's up?"
        newModel.isMine = false

        self.perform(#selector(sendMessage(msgModel:)), with: newModel, afterDelay: 1)

    }

    @objc func sendMessage(msgModel:MessageModel){
        dataSource.append(msgModel)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: dataSource.count-1, section: 0), at: .bottom, animated: true)
    }

    @objc func keyboardWillAction(notify:Notification){
        //获取键盘尺寸
        let rectValue:NSValue = (notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey])! as! NSValue;
        //获取键盘的高度
        let rect:CGRect = rectValue.cgRectValue
        //获取通知的高度
        let height:CGFloat = rect.size.height
        //获取通知的名字
        let nameStr:String = notify.name.rawValue
        var frame = chatBar.frame
        var tableFrame = tableView.frame
        if nameStr == (UIResponder.keyboardWillShowNotification).rawValue{
            if keyboardHeight != height {
                frame.origin.y -=  height  - keyboardHeight
                chatBar.frame = frame
                tableFrame.size.height -= height - keyboardHeight
                tableView.frame  = tableFrame
                if dataSource.count > 0 {
                    tableView.scrollToRow(at: IndexPath(row: dataSource.count-1, section: 0), at: .bottom, animated: true)
                }
                keyboardHeight = height
            }
        }else{
            frame.origin.y += keyboardHeight
            chatBar.frame = frame

            tableFrame.size.height += keyboardHeight
            tableView.frame = tableFrame
            keyboardHeight = 0.0
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTF.resignFirstResponder()
        return true
    }

    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: MessageTableCellIdentifier) as? MessageTableViewCell ?? MessageTableViewCell()
        if indexPath.row  < dataSource.count {
            cell.msgModel = dataSource[indexPath.row]
        }
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row  < dataSource.count{
            let content:String = dataSource[indexPath.row].message ?? ""
            let contentSize = content.boundingRect(with: CGSize(width: 200, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)], context: nil)
            return contentSize.height > 30 ? contentSize.height + 30 : 50
        }
        return 50
    }

}

