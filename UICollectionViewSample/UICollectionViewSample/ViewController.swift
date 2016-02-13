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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.collectionViewList.dataSource = self
        self.collectionViewList.delegate = self
        
        // カスタムセル
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionViewList.registerNib(nib, forCellWithReuseIdentifier: "cell")
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
        return 365
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
        return CGSizeMake(53.0, 53.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.5, 1.5, 2.0, 0.5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
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
    
}

