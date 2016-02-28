//
//  ViewController.swift
//  Line
//
//  Created by 堀 正洋 on 2016/02/27.
//  Copyright © 2016年 masahiro_hori. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var messageField: UITableView!
    
    @IBOutlet weak var messageBox: UITextField!
    
    
    var messageNameList: [String] = ["堀正洋", "堀正洋", "堀正洋"]
    // データを用意
    var data: Array<Dictionary<String,String>> = [
        ["message":"こんにちは","who":"上司"],
        ["message":"お元気ですか？","who":"部下"],
        ["message":"今大丈夫ですか？","who":"上司"],
        ["message":"今日飲み行きません？","who":"部下"],
        ["message":"お疲れ様です。","who":"上司"]
    ]
    
    // タイマーを用意
    var timer: NSTimer!
    
    // 返信データを用意
    var replyData :Array<String> = [
        "本日は晴天なり",
        "ごめんなさい",
        "お腹が痛いです",
        "本日出社が遅れます",
        "お昼行ってきます",
        "電車遅延で出社が遅れます",
    ]
    
    
    // テキストフィールドの中身を取得
    // 上のデータを追加する
    @IBAction func tabSendMessage(sender: AnyObject) {
        let message = self.messageBox.text
        
        
        // 追加するデータ
        let addData: Dictionary<String,String> = ["message": message!, "who":"部下"]
        
        self.data.append(addData)
        
        // tableViewと相談し直す
        self.messageField.reloadData()
        
        // テキストフィールドの中を空にする
        self.messageBox.text = ""
        
        // タイマーをセットする
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "replyMessage", userInfo: nil, repeats: false)
        
    }
    
    // replyMessage呼ばれたらどうする？
    func replyMessage (){
        // 乱数を用意
        let random = arc4random() % UInt32(self.replyData.count)
        
        // 返信がくる
        let reply = self.replyData[Int(random)]
        // データ追加
        let addData : Dictionary<String, String> = ["message": reply, "who": "上司"]
        
        self.data.append(addData)
        
        // tableViewと相談し直す
        self.messageField.reloadData()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        messageField.delegate = self
        messageField.dataSource = self
        
        // xibファイルを呼んでくる
        let xib = UINib(nibName: "MyMessageTableViewCell", bundle: nil)
        let bossXib = UINib(nibName: "BossMessageTableViewCell", bundle: nil)
        
        // tableViewに登録
        self.messageField.registerNib(xib, forCellReuseIdentifier: "MyCell")
        self.messageField.registerNib(bossXib, forCellReuseIdentifier: "BossCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セルの高さどうする？
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    
    // セルの設定
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 部下の投稿だったら青、上司の投稿だったら赤
        if self.data[indexPath.row]["who"] == "部下" {
            // MyCellを使う
            let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! MyMessageTableViewCell
            cell.messageLabel.text = self.data[indexPath.row]["message"]
            return cell

        } else {
//            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("redCell", forIndexPath: indexPath)
//            cell.textLabel?.text = self.data[indexPath.row]["message"]
            let cell = tableView.dequeueReusableCellWithIdentifier("BossCell", forIndexPath: indexPath) as! BossMessageTableViewCell
            cell.bossMessageLabel.text = self.data[indexPath.row]["message"]
            return cell
        }
    }
    
    // セルの数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
}