//
//  BlurActionSheet.swift
//  BlurActionSheetDemo
//
//  Created by nathan on 15/4/23.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

import UIKit

class BlurActionSheet: UIView, UITableViewDataSource {

    private let actionSheetCellHeight: CGFloat = 44.0
    private let actionSheetCancelHeight: CGFloat = 58.0
    
    private var showSet: NSMutableSet = NSMutableSet()
    private var titles: [String]?
    private var containerView: UIView?
    private var handler: ((index:Int) -> Void)?
    
    private var tableView: UITableView!
    private var blurBackgroundView: BlurBackgroundView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        blurBackgroundView = BlurBackgroundView()
        addSubview(blurBackgroundView)
        
        tableView                 = UITableView()
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.backgroundView  = nil
        tableView.scrollEnabled   = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle  = .None
        tableView.tableFooterView = UIView()
        addSubview(tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let maxHeight = actionSheetCellHeight * CGFloat(titles!.count - 1) + actionSheetCancelHeight
        
        // TODO: - maxHeight shouldn't be greater than screen's height.
        
        var frame = UIScreen.mainScreen().bounds
        frame.size.height = maxHeight
        frame.origin.y = UIScreen.mainScreen().bounds.height - frame.size.height
        
        tableView.frame = frame

    }
    
    
    
    class func showWithTitles(titles: [String], handler: ((index:Int) -> Void)){
        showWithTitles(titles, view: nil, handler: handler)
    }
    
    class func showWithTitles(titles: [String], view: UIView?, handler: ((index:Int) -> Void)){
        let actionSheet = BlurActionSheet(frame: UIScreen.mainScreen().bounds)
        actionSheet.titles = titles
        actionSheet.containerView = view
        actionSheet.handler = handler
        actionSheet.show()
    }
    
    private func show() {
        
        if (containerView != nil) {
            containerView!.addSubview(self)
        } else {
            UIApplication.sharedApplication().keyWindow?.addSubview(self)
        }
        
        blurBackgroundView.alpha = 0
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.blurBackgroundView.alpha = 1
        })
    }
    
    private func hide() {
        
        var index = 0
        
        for visibleCell in tableView.visibleCells {
            if let cell = visibleCell as? BlurActionSheetCell {
                index = index + 1
                let height = tableView.frame.size.height

                UIView.animateWithDuration(0.45, delay: 0.2, options: .CurveEaseOut, animations: { () -> Void in
                    cell.textLabel?.textColor = UIColor(red: 0.7725, green: 0.1308, blue: 0.13, alpha: 0.0)
                    cell.underLineView?.alpha = 0
                    
                    cell.layer.transform = CATransform3DTranslate(cell.layer.transform, 0, height * 2, 0)
                    }, completion: { (Bool) -> Void in
                        self.removeFromSuperview()
                })
            }
        }
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
           self.blurBackgroundView.alpha = 0.0
        });
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hide()
    }
    
    // MARK: - tableView dataSource and delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (titles != nil) {
            return titles!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let titles = titles {
            return indexPath.row == titles.count - 1 ? actionSheetCancelHeight : actionSheetCellHeight
        }
        return actionSheetCellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier:String = "actionSheetCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? BlurActionSheetCell
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

extension BlurActionSheet: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        hide()
        handler!(index: indexPath.row)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (!showSet.containsObject(indexPath)) {
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
