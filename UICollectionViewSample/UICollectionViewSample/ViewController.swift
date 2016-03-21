//
//  ViewController.swift
//  UICollectionViewSample
//
//  Created by 堀 正洋 on 2016/01/17.
//  Copyright © 2016年 masahiro_hori. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewList: UICollectionView!
    let userDefault = NSUserDefaults.standardUserDefaults()
    let yearDays = 365
    let linePoint: CGFloat = 1 // 罫線の太さ
    let numberOfCols: CGFloat = 6  //　１行に表示するセルの数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.collectionViewList.dataSource = self
        self.collectionViewList.delegate = self
        
        // カスタムセル
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionViewList.registerNib(nib, forCellWithReuseIdentifier: "cell")
        
        let keys = self.userDefault.dictionaryRepresentation()
        if (keys.count == yearDays) {
            resetMoney()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // セクションの返却数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // セルの返却数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yearDays
    }
    
    // セルの表示内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        let day = indexPath.row + 1
        cell.collectionCell.text = String(day)
        
        if (userDefault.objectForKey(String(indexPath.row)) == nil) {
            cell.backgroundColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = UIColor.grayColor()
        }
        
        return cell
    }
    
    // セルのレイアウト調整
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // (端末の横幅 - 各セルの罫線の合計) / １行に表示するセルの個数
        let size = floor((self.view.frame.size.width - (linePoint*numberOfCols)) / numberOfCols)
        return CGSizeMake(size, size)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return linePoint
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return linePoint
    }
    
    // セルが選択されたら
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        var title = ""
        var message = ""
        
        var okAction = UIAlertAction()
        if (userDefault.objectForKey(String(indexPath.row)) == nil) {
            okAction = UIAlertAction(title: "貯金する", style: .Default){
                action in self.userDefault.setObject(indexPath.row+1, forKey: String(indexPath.row))
                self.userDefault.synchronize()
                collectionView.reloadItemsAtIndexPaths([indexPath])
            }
            title = "貯金"
            message = "貯金しますか？"
        } else {
            okAction = UIAlertAction(title: "取り消し", style: .Default){
                action in self.userDefault.removeObjectForKey(String(indexPath.row))
                self.userDefault.synchronize()
                collectionView.reloadItemsAtIndexPaths([indexPath])
            }
            title = "取り消し"
            message = "取り消しますか？"
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // userDefaultsに保存されている除菌情報を削除する
    func resetMoney(){
        let resetAction = UIAlertAction(title: "リセット", style: .Default){
            action in self.userDefault.removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        
        let alertController = UIAlertController(title: "毎日貯金達成しました！", message: "リセットしますか？", preferredStyle: .Alert)
        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        collectionViewList.reloadData()
    }
}