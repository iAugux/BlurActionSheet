//
//  BlurActionSheet.swift
//  BlurActionSheetDemo
//
//  Created by nathan on 15/4/23.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

import UIKit

class BlurActionSheet: UIView, UITableViewDataSource {

    private let actionSheetCellHeight:CGFloat = 44.0
    
    private var showSet:NSMutableSet = NSMutableSet()
    private var titles:[String]?
    private var containerView:UIView?
    private var handler:((index:Int) -> Void)?
    
    private var tableView:UITableView!
    private var backView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backView = UIView()
        backView.backgroundColor = UIColor(white: 0.7, alpha: 0)
        addSubview(backView)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurView.frame = UIScreen.mainScreen().bounds
        backView.addSubview(blurView)
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
        addSubview(tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    class func showWithTitles(titles:[String], handler: ((index:Int) -> Void)){
        showWithTitles(titles, view: nil, handler: handler)
    }
    
    class func showWithTitles(titles:[String], view:UIView?, handler: ((index:Int) -> Void)){
        let actionSheet = BlurActionSheet(frame: UIScreen.mainScreen().bounds)
        actionSheet.titles = titles
        actionSheet.containerView = view
        actionSheet.handler = handler
        actionSheet.show()
    }
    
    
    private func show(){
        
        if (containerView != nil){
            containerView!.addSubview(self)
        }else{
            UIApplication.sharedApplication().keyWindow?.addSubview(self)
        }
        
        backView.alpha = 0
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.backView.alpha = 1
        })
    }
    
    
    private func hide(){
        
        var index = 0
        let count:CGFloat = CGFloat(tableView.visibleCells.count)
        let minOffset = self.frame.size.width * 0.4 / count
        let cellWidth = self.frame.size.width
        for visibleCell in tableView.visibleCells{
            if let cell = visibleCell as? BlurActionSheetCell {
                index = index + 1
                let underLineWidth: CGFloat = (count - CGFloat(index)) * minOffset
                let height = tableView.frame.size.height
                
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    cell.underLineView.frame = CGRectMake((cellWidth-underLineWidth)/2, 0, underLineWidth, 1)
                }, completion: nil)

                UIView.animateWithDuration(0.5, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    cell.layer.transform = CATransform3DTranslate(cell.layer.transform, 0, height*2, 0)
                }, completion: { (Bool) -> Void in
                    self.removeFromSuperview()
                })
            }
        }
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
           self.backView.alpha = 0.0
        });
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hide()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var maxHeight = actionSheetCellHeight * CGFloat(titles!.count)
        if (maxHeight > self.frame.size.height * 0.7){
            maxHeight = self.frame.size.height * 0.7
        }
        
        var frame = self.bounds;
        frame.size.height = maxHeight
        frame.origin.y = self.bounds.size.height - frame.size.height
        
        backView.frame = self.bounds
        tableView.frame = frame
    }
    
    // tableView dataSource and delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (titles != nil){
            return titles!.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return actionSheetCellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier:String = "actionSheetCell"
        var cell:BlurActionSheetCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? BlurActionSheetCell
        if (cell == nil) {
            cell = BlurActionSheetCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        if (indexPath.row == 0) {
            cell?.underLineView.hidden = true
        }
        
        cell?.textLabel?.text = titles![indexPath.row]
        cell?.textLabel?.textAlignment = .Center
        cell?.textLabel?.textColor = UIColor.whiteColor()
        
        return cell!
    }
    
}

extension BlurActionSheet: UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        hide()
        handler!(index: indexPath.row)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (!showSet.containsObject(indexPath)){
            showSet.addObject(indexPath)
            
            let delayTime: NSTimeInterval! = 0.3 + sqrt(Double(indexPath.row)) * 0.09
            cell.layer.transform = CATransform3DTranslate(cell.layer.transform, 0, 400, 0)
            cell.alpha = 0.5
            
            UIView.animateWithDuration(0.5, delay: delayTime, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1
                
                }, completion: nil)
        }
    }
}
